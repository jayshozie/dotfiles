#!/usr/bin/env bash

# ARCHLINUX POST-INSTALLATION SYNCRONIZATION SCRIPT (a.k.a. PISS.sh)
# Execution: Run as ROOT while chrooting into the system.

# Fail safe, fail hard.
set -euo pipefail
# This is not a toy or a vibe-coded slop that doesn't matter, we can't take
# chances.

TARGET_USRNAME='jaysh'
TARGET_ID='1000' # Target for both UID and GID

echo "[ARCH-INSTALL] === INITIALIZING SEQUENCE ==="

# ---------------------------------------------------------
# PHASE 1: IDENTITY & SECURITY (ROOT)
# ---------------------------------------------------------

echo "[ARCH-INSTALL] Validating Identity for: $TARGET_USRNAME (UID/GID: $TARGET_ID)"

# [SAFETY CHECKS - PRESERVED]
# check if UID 1000 is taken by a weird ahh user
UID_HOLDER=$(getent passwd "$TARGET_ID" | cut -d: -f1)
if [[ -n "$UID_HOLDER" && "$UID_HOLDER" != "$TARGET_USRNAME" ]]; then
    echo "[CRITICAL] UID $TARGET_ID is occupied by '$UID_HOLDER'."
    echo "Make sure it is safe to remove that user, and run:"
    echo "userdel -r $UID_HOLDER"
    exit 1
fi
# check if GID 1000 is taken by a weird ahh group
GID_HOLDER=$(getent group "$TARGET_ID" | cut -d: -f1)
if [[ -n "$GID_HOLDER" && "$GID_HOLDER" != "$TARGET_USRNAME" ]]; then
    echo "[CRITICAL] GID $TARGET_ID is occupied by group '$GID_HOLDER'."
    echo "Make sure it is safe to remove that group, and run:"
    echo "groupdel $GID_HOLDER"
    exit 1
fi

# [GROUP ENFORCEMENT]
if ! getent group "$TARGET_USRNAME" >/dev/null; then
    echo "[ARCH-INSTALL] Creating group '$TARGET_USRNAME' at GID $TARGET_ID..."
    groupadd -g "$TARGET_ID" "$TARGET_USRNAME"
else
    CURR_GID=$(getent group "$TARGET_USRNAME" | cut -d: -f3)
    if [[ "$CURR_GID" != "$TARGET_ID" ]]; then
        echo "[ARCH-INSTALL] Correcting GID for group '$TARGET_USRNAME'..."
        groupmod -g "$TARGET_ID" "$TARGET_USRNAME"
    fi
fi

# [USER ENFORCEMENT]
if id "$TARGET_USRNAME" &>/dev/null; then
    echo "[ARCH-INSTALL] User exists. Verifying configuration..."
    usermod -u "$TARGET_ID" -g "$TARGET_ID" -aG wheel -s /bin/bash "$TARGET_USRNAME"
else
    echo "[ARCH-INSTALL] Creating clean user..."
    useradd -m -u "$TARGET_ID" -g "$TARGET_ID" -G wheel -s /bin/bash "$TARGET_USRNAME"
    echo "[ARCH-INSTALL] Set password for $TARGET_USRNAME:"
    passwd "$TARGET_USRNAME"
fi

# [SUDOERS]
echo "[ARCH-INSTALL] Enabling sudo access for %wheel group..."
if grep -q "^# %wheel ALL=(ALL:ALL) ALL" /etc/sudoers; then
    sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
    if ! visudo -c; then
        echo "[CRITICAL] /etc/sudoers syntax is broken!"
        exit 1
    fi
    echo "[ARCH-INSTALL] Sudo access enabled."
fi

# ---------------------------------------------------------
# PHASE 2: SYSTEM PACKAGES (ROOT CONTEXT)
# ---------------------------------------------------------
echo "[ARCH-INSTALL] System Update & Package Installation..."

# Enable Multilib
sed -i '/^\[multilib\]/,/^\[/{s/^#//}' /etc/pacman.conf

# Atomic Install Function
inst() {
    pacman -Syu --needed --noconfirm "$@"
}

# 1. Update DB
pacman -Syu --noconfirm

# 2. System Stuff
inst base linux-headers linux-firmware networkmanager sudo age man-db man-pages
inst less openssh snapper grub-btrfs inotify-tools

# 3. Dev Stack
inst base-devel git github-cli gcc tree-sitter-cli gdb valgrind clang
inst cmake ninja strace lua51 alacritty tmux starship bash-completion ripgrep fd
inst fzf unzip wget tree btop fastfetch tldr git-filter-repo bat bat-extras rust
inst python python-pip qemu-full virt-manager libvirt edk2-ovmf dnsmasq eza entr
inst iptables-nft git-delta

# 4. LSP's
inst bash-language-server lua-language-server harper

# 4. Desktop (Hyprland)
inst hyprland xdg-desktop-portal-hyprland xdg-desktop-portal-gtk grim slurp vlc
inst hyprlock hyprpaper hyprpicker greetd greetd-tuigreet waybar mako udiskie
inst rofi thunar wl-clipboard cliphist nwg-look xdg-user-dirs qbittorrent via
inst qt5-graphicaleffects qt5-quickcontrols2 qt5-svg
inst xorg-xwayland qt5-wayland qt6-wayland

# 5. Drivers
inst intel-ucode nvidia-open nvidia-utils nvidia-settings lib32-nvidia-utils
inst egl-wayland pipewire pipewire-alsa pipewire-pulse wireplumber pavucontrol
inst bluez bluez-utils blueman

# 6. Fonts
inst ttf-jetbrains-mono-nerd noto-fonts-emoji noto-fonts-cjk

# ---------------------------------------------------------
# PHASE 3: CONFIGURATION (ROOT CONTEXT)
# ---------------------------------------------------------
HOMEDIR="/home/${TARGET_USRNAME}"

# Skeleton
mkdir -p "${HOMEDIR}/uni"
mkdir -p "${HOMEDIR}/src/{upstream,aur,refs}"
chown -R "$TARGET_USRNAME:$TARGET_USRNAME" "$HOMEDIR"

# Services
systemctl enable NetworkManager sshd bluetooth greetd

# Grub Nvidia Patch
# TODO: Refactor it to put the flags:
# ibt=off nvidia_drm.modeset=1 nvidia_drm.fbdev=1 acpi_backlight=native nvidia.NVreg_EnableBacklightHandler=1 module_blacklist=nvidia_wmi_ec_backlight
if ! grep -q "nvidia_drm.modeset=1" /etc/default/grub; then
    echo "[ARCH-INSTALL] Patching GRUB..."
    sed -i '/^GRUB_CMDLINE_LINUX_DEFAULT=/ {
        # If the line ALREADY contains the parameter, do nothing (skip to end)
        /nvidia_drm.modeset=1/b

        # Otherwise, replace the closing quote (and any trailing garbage)
        s/"[[:space:]]*$/ nvidia_drm.modeset=1"/
    }' /etc/default/grub
    grub-mkconfig -o /boot/grub/grub.cfg
fi

# TODO: /etc/mkinitcpio.conf Nvidia Patch
# Current Flags:
# MODULES=(i915 nvidia nvidia_modeset nvidia_uvm nvidia_drm)

# ---------------------------------------------------------
# PHASE 4: USER SPACE & KEY REHYDRATION (CONTEXT SWITCH)
# ---------------------------------------------------------
echo "---------------------------------------------------------------"
echo "[ARCH-INSTALL] >> SWITCHING CONTEXT TO: $TARGET_USRNAME      <<"
echo "[ARCH-INSTALL] >> PREPARE YOUR PASSPHRASE FOR KEY DECRYPTION <<"
echo "---------------------------------------------------------------"

# We pass variables into the heredoc, but escape internal vars ($?) as \$?
sudo -u "$TARGET_USRNAME" bash <<EOF
    # -- USER CONTEXT STARTED --
    pushd "$HOMEDIR"

    # Define a smart permission checker function
    enforce_perm() {
        local path="\$1"
        local want_perm="\$2"
        local user="$TARGET_USRNAME"

        if [[ -e "\$path" ]]; then
            # Check ownership
            local current_owner=\$(stat -c "%U:%G" "\$path")
            if [[ "\$current_owner" != "\$user:\$user" ]]; then
                echo "   [FIX] Ownership mismatch on \$path. Fixing..."
                chown "\$user:\$user" "\$path"
            fi

            # Check Permissions
            local current_perm=\$(stat -c "%a" "\$path")
            if [[ "\$current_perm" != "\$want_perm" ]]; then
                echo "   [FIX] Permission mismatch on \$path (\$current_perm -> \$want_perm). Fixing..."
                chmod "\$want_perm" "\$path"
            else
                echo "   [OK] \$path is safe (\$want_perm)"
            fi
        fi
    }

    # 1. CLONE DEV (HTTPS)
    if [[ ! -d "dev" ]]; then
        echo "[USER-CTX] Cloning dev (HTTPS)..."
        git clone https://github.com/jayshozie/dev.git
    fi

    # 2. KEY REHYDRATION PROTOCOL
    # I learned my lesson. I won't copy keys over systems again.
    # KEY_ARCHIVE="${HOMEDIR}/dev/identity.tar.age.pass1"

    # if [[ -f "\$KEY_ARCHIVE" ]]; then
    #     echo '---------------------------------------------------'
    #     echo '------- !!! DECRYPTING IDENTITY ARCHIVE !!! -------'
    #     echo '---------------------------------------------------'

    #     # Interactive decryption
    #     age -d "\$KEY_ARCHIVE" | tar -xv -C "$HOMEDIR"

    #     # CAPTURE EXIT CODE of the pipe
    #     DECRYPT_STATUS=\${PIPESTATUS[0]}

    #     if [[ \$DECRYPT_STATUS -eq 0 ]]; then
    #         echo "[USER-CTX] Decryption successful. verifying permissions..."

    #         # 3. VERIFY & ENFORCE PERMISSIONS (Based on your ls -l)
    #         # SSH
    #         enforce_perm "${HOMEDIR}/.ssh" "700"
    #         enforce_perm "${HOMEDIR}/.ssh/id_ed25519" "600"
    #         enforce_perm "${HOMEDIR}/.ssh/id_ed25519.pub" "644"
    #         enforce_perm "${HOMEDIR}/.ssh/known_hosts" "600"

    #         # GPG
    #         enforce_perm "${HOMEDIR}/.gnupg" "700"
    #         enforce_perm "${HOMEDIR}/.gnupg/private-keys-v1.d" "700"
    #         enforce_perm "${HOMEDIR}/.gnupg/trustdb.gpg" "600"
    #         # Pubring usually 644 or 664, allowing existing state if safe, forcing 600 if paranoid.
    #         # We will force 600 for safety as GPG complains otherwise.
    #         enforce_perm "${HOMEDIR}/.gnupg/pubring.kbx" "664"

    #         # 4. SWITCH GIT REMOTE
    #         echo "[USER-CTX] Trusting GitHub & Switching Remote..."
    #         mkdir -p "${HOMEDIR}/.ssh"
    #         # Prevent "Host key verification failed" by scanning github
    #         ssh-keyscan -t ed25519 github.com >> "${HOMEDIR}/.ssh/known_hosts" 2>/dev/null

    #         pushd "${HOMEDIR}/dev"
    #         git remote set-url origin git@github.com:jayshozie/dev.git
    #         echo "[USER-CTX] Remote updated to SSH: git@github.com:jayshozie/dev.git"
    #         popd

    #     else
    #         echo ""
    #         echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    #         echo "[CRITICAL] DECRYPTION FAILED (Wrong Passphrase?)"
    #         echo "Skipping git remote switch to prevent errors."
    #         echo ""
    #         echo ">> TO FIX THIS MANUALLY AFTER REBOOT:"
    #         echo "1. Run this to retry decryption:"
    #         echo "   age -d ~/dev/identity.tar.age.pass1 | tar -xv -C ~"
    #         echo ""
    #         echo "2. Run this to switch the git remote:"
    #         echo "   cd ~/dev && git remote set-url origin git@github.com:jayshozie/dev.git"
    #         echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    #         echo ""
    #     fi
    # else
    #     echo "[WARNING] Key archive not found at \$KEY_ARCHIVE"
    # fi

    # 5. PARU INSTALLATION
    if ! command -v paru &> /dev/null; then
        echo "[USER-CTX] Installing Paru..."
        pushd "${HOMEDIR}/src/aur"
        [[ ! -d paru ]] && git clone https://aur.archlinux.org/paru.git
        popd
        pushd "${HOMEDIR}/src/aur/paru"
        makepkg -si --noconfirm
        popd
    fi

    paru -S rofi-polkit-agent-git pinentry-rofi jellyfin-desktop

    # 6. CLONE REPOSITORIES

    pushd "$HOMEDIR"
    git clone --recursive git@github.com:jayshozie/projects.git
    popd
    pushd "${HOMEDIR}/projects"
    git submodule foreach --recursive 'git switch main'
    pushd

    pushd "${HOMEDIR}/uni"
    git clone git@github.com:jayshozie/ceng240.git
    git clone git@github.com:jayshozie/ceng301.git
    git clone git@github.com:jayshozie/ce231.git
    git clone git@github.com:jayshozie/ce241.git
    popd

    pushd "${HOMEDIR}/src/refs"
    git clone git@github.com:ThePrimeagen/dev.git prime-dev
    popd

    pushd "${HOMEDIR}/src/upstream"
    git clone git@github.com:nvim-treesitter/nvim-treesitter.git
    git clone git@github.com:neovim/neovim.git
    git clone git@github.com:tmux/tmux.git
    git clone git@github.com:ThePrimeagen/tmux-sessionizer.git
    popd
    # now build/install dev stuff
    pushd "${HOMEDIR}/dev"
    ./dev
    ./run
    popd

    popd
    # -- USER CONTEXT END --
EOF

echo "[ARCH-INSTALL] System Provisioned."
echo "[ARCH-INSTALL] === You can now reboot. ==="
