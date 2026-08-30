-- Copyright (C)  2026  Emir Baha YILDIRIM
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.

---------------
-- Variables --
---------------
local home = "/home/jaysh"
local pics = home .. "/pics"
local screenshots = pics .. "/screenshots"
local src = home .. "/src"
-- -- In case we need them:
-- local dev_env = home .. '/dev'
-- local projects = home .. '/projects'
-- local downloads = home .. '/Downloads'

--------------
-- Monitors --
--------------
-- Built-In Display
hl.monitor({
  output = "eDP-1",
  mode = "2560x1600@240",
  position = "auto",
  scale = 1.6,
  transform = 0,
})
hl.monitor({
  output = "HDMI-A-1",
  mode = "1920x1080@60",
  position = "auto-left",
  scale = 1,
  transform = 0,
})

---------------------
-- Workspace Rules --
---------------------
for i = 1, 10 do
  local monitor_name
  if i ~= 3 then
    monitor_name = "eDP-1"
  else
    monitor_name = "HDMI-A-1"
  end
  hl.workspace_rule({
    workspace = i,
    monitor = monitor_name,
  })
end

--------------
-- Programs --
--------------
local terminal = "alacritty"
local fileManager = "thunar"
local menu = "rofi -show drun"
local browser = "librewolf"
local waybar = src .. "/upstream/waybar/build/waybar"

---------------
-- Autostart --
---------------
-- stylua: ignore start
hl.on("hyprland.start", function()
  hl.exec_cmd("tmux start")
  hl.exec_cmd("alacritty -e tmux new-session -A -s dev")
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd(waybar)
  hl.exec_cmd("mako") -- notification daemon
  hl.exec_cmd("/usr/bin/rofi-polkit-agent") -- auth agent
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("hypridle")
  hl.exec_cmd('cd "${XDG_DATA_HOME}/actual-budgeting" && actual-server')
  hl.exec_cmd("actual-server") -- budgeting program's server
  hl.exec_cmd("wl-paste --watch cliphist store") -- cliphist
  hl.exec_cmd("sleep 3 && bluetoothctl connect 8C:0D:D9:19:43:B3")
  hl.exec_cmd('gsettings set org.gnome.desktop.interface gtk-theme "Tokyonight-Dark"') -- for GTK3 apps
  hl.exec_cmd('gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"') -- for GTK4 apps
  -- hl.exec_cmd('protonvpn-app')
  ---@TODO: Uncomment the line below when support is added.
  -- hl.exec_cmd('hyprsession')
end)
-- stylua: ignore end

---------------------------
-- Environment Variables --
---------------------------
hl.env("AQ_DRM_DEVICES", "/dev/dri/intel-igpu:/dev/dri/nvidia-dgpu")
hl.env("GRIM_DEFAULT_DIR", screenshots)
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "rose-pine-hyprcursor")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_SCALE_FACTOR", "1.0")

-------------------
-- Look and Feel --
-------------------
hl.config({
  general = {
    gaps_in = 0,
    gaps_out = 0,
    -- gaps_in = 5,
    -- gaps_out = 10,
    border_size = 1,

    col = {
      active_border = {
        colors = {
          "rgba(7aa2f7ee)",
          "rgba(bb9af7ee)",
        },
        angle = 45,
      },
      inactive_border = "rgba(515c7eaa)",
    },
    resize_on_border = true,
    allow_tearing = false,
    layout = "dwindle",

    snap = {
      enabled = true,
    },
  },

  decoration = {
    rounding = 0,
    -- rounding = 12,
    rounding_power = 2,

    active_opacity = 1.0,
    -- inactive_opacity = 0.65,
    inactive_opacity = 1.0,

    shadow = {
      enabled = false,
      range = 4,
      render_power = 3,
      color = "rgba(1a1a1aee)",
    },

    blur = {
      enabled = true,
      size = 2,
      passes = 2,
      noise = 0.0117,
      contrast = 0.8916,
      brightness = 0.5,
      vibrancy = 0.1696,
      vibrancy_darkness = 0.0,
    },
  },

  animations = {
    enabled = false,
  },

  dwindle = {
    preserve_split = true,
  },

  master = {
    new_status = "master",
  },

  scrolling = {
    fullscreen_on_one_column = true,
  },

  misc = {
    force_default_wallpaper = -1,
    disable_hyprland_logo = false,
    disable_splash_rendering = true,
  },

  input = {
    kb_layout = "us,tr",
    kb_variant = "dvorak",
    kb_model = "",
    kb_options = "grp:alt_shift_toggle",
    kb_rules = "",

    numlock_by_default = true,
    repeat_rate = 35,
    repeat_delay = 300,

    follow_mouse = 1,

    sensitivity = 0.0,
    accel_profile = "adaptive",
    force_no_accel = false,

    touchpad = {
      natural_scroll = true,
    },
  },

  xwayland = {
    force_zero_scaling = true,
  },
})

--------------
-- Gestures --
--------------
hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace",
})

-------------
-- Devices --
-------------
hl.device({
  name = "e-signal-usb-gaming-mouse",
  sensitivity = -0.093,
  accel_profile = "flat",
})

-- stylua: ignore start
-----------------
-- Keybindings --
-----------------
local mainMod = "SUPER"
hl.bind(
  mainMod .. " + T",
  hl.dsp.exec_cmd(terminal .. ' -e tmux attach')
)
hl.bind(
  mainMod .. " + SHIFT + T",
  hl.dsp.exec_cmd(terminal)
)
hl.bind(
  mainMod .. " + C",
  hl.dsp.window.close()
)
-- hl.bind(
--     mainMod .. ' + M',
--     hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
-- )
hl.bind(
  mainMod .. " + E",
  hl.dsp.exec_cmd(fileManager)
)
hl.bind(
  mainMod .. " + V",
  hl.dsp.window.float({ action = "toggle" })
)
hl.bind(
  mainMod .. " + R",
  hl.dsp.exec_cmd(menu)
)
hl.bind(
  mainMod .. " + P",
  hl.dsp.window.pseudo({ action = "toggle" })
)
hl.bind(
  mainMod .. " + SHIFT + J",
  hl.dsp.layout("togglesplit") -- @FIXME: may be deprecated, test needed
)
hl.bind(
  mainMod .. " + B",
  hl.dsp.exec_cmd(browser)
)
hl.bind(
  mainMod .. " + SHIFT + S",
  hl.dsp.exec_cmd(
    'grim -g "$(slurp)" - | tee '
      .. screenshots
      .. "/screenshot_$(date +%Y%m%d_%H%M%S).png | wl-copy"
  )
)
hl.bind(
  mainMod .. " + SHIFT + C",
  hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy")
)
hl.bind(
  mainMod .. " + F",
  hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" })
)
hl.bind(
  mainMod .. " + ALT + C",
  hl.dsp.exec_cmd("hyprpicker -n -a -f hex")
)
-- Free Keybind to Use
-- hl.bind(
--     mainMod .. ' + SHIFT + Z',
--     hl.dsp.exec_cmd('')
-- )
hl.bind(
  mainMod .. " + SHIFT + L",
  hl.dsp.exec_cmd("hyprlock")
)
hl.bind(
  "switch:on:Lid Switch",
  hl.dsp.exec_cmd("hyprlock"),
  { -- options
    locked = true,
  }
)
hl.bind(
  mainMod .. " + H",
  hl.dsp.focus({ direction = "l" })
)
hl.bind(
  mainMod .. " + L",
  hl.dsp.focus({ direction = "r" })
)
hl.bind(
  mainMod .. " + K",
  hl.dsp.focus({ direction = "u" })
)
hl.bind(
  mainMod .. " + J",
  hl.dsp.focus({ direction = "d" })
)
for workspace = 1, 10 do
  local key = workspace % 10
  hl.bind(
    mainMod .. " + " .. key,
    hl.dsp.focus({
        workspace = workspace,
    })
  )
  hl.bind(
    mainMod .. " + SHIFT + " .. key,
    hl.dsp.window.move({
      workspace = workspace,
      follow = false,
    })
  )
end
hl.bind(
  mainMod .. " + mouse:272", -- LMB
  hl.dsp.window.drag(),
  { -- options
      mouse = true,
  }
)
hl.bind(
  mainMod .. " + mouse:273", -- RMB
  hl.dsp.window.resize(),
  { -- options
      mouse = true,
  }
)
hl.bind(
  "XF86AudioRaiseVolume",
  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
  { -- options
    repeating = true,
    locked = true,
  }
)
hl.bind(
  "XF86AudioLowerVolume",
  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  { -- options
    repeating = true,
    locked = true,
  }
)
hl.bind(
  "XF86AudioMute",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  { -- options
    repeating = true,
    locked = true,
  }
)
hl.bind(
  "XF86AudioMicMute",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
  { -- options
    repeating = true,
    locked = true,
  }
)
-- Brightness doesn't work on HP OMEN MAX 16 right now.
-- hl.bind(
--   'XF86MonBrightnessUp',
--   hl.dsp.exec_cmd('brightnessctl -e4 -n2 set 5%+')
-- )
-- hl.bind(
--   'XF86MonBrightnessDown',
--   hl.dsp.exec_cmd('brightnessctl -e4 -n2 set 5%-')
-- )
local playerctl = "playerctl"
local playerctl_next = playerctl .. " next"
local playerctl_next_spotify = playerctl_next .. " --player spotify"
local playerctl_previous = playerctl .. " previous"
local playerctl_previous_spotify = playerctl_previous .. " --player spotify"
local playerctl_helper = home .. "/.local/bin/scripts/playerctl-helper"
hl.bind(
  "CONTROL + ALT + space",
  hl.dsp.exec_cmd(playerctl_helper),
  { -- options
    locked = true,
  }
)
hl.bind(
  "CONTROL + ALT + N",
  hl.dsp.exec_cmd(playerctl_next_spotify),
  { -- options
    locked = true,
  }
)
hl.bind(
  "CONTROL + ALT + P",
  hl.dsp.exec_cmd(playerctl_previous_spotify),
  { -- options
    locked = true,
  }
)
hl.bind("XF86AudioNext",
  hl.dsp.exec_cmd(playerctl_next_spotify),
  { -- options
    repeating = true,
    locked = true,
  }
)
hl.bind(
  "XF86AudioPrev",
  hl.dsp.exec_cmd(playerctl_previous_spotify),
  { -- options
    repeating = true,
    locked = true,
  }
)
hl.bind("XF86AudioPlay",
  hl.dsp.exec_cmd(playerctl_helper),
  { -- options
    repeating = true,
    locked = true,
  }
)
hl.bind("XF86AudioPause",
  hl.dsp.exec_cmd(playerctl_helper),
  { -- options
    repeating = true,
    locked = true,
  }
)
---@TODO: Doesn't work, because spotify-launcher is explicitly XWayland. Uncomment when available.
------------------------
-- Special Workspaces --
------------------------
-- hl.workspace_rule({
--   workspace = "special:spotify",
--   default = false,
--   default_name = "Spotify",
--   gaps_in = 10,
--   gaps_out = 20,
-- })
-- hl.bind(mainMod .. " + SHIFT + M",
--   hl.dsp.window.move({ workspace = "special:spotify" })
-- )
-- hl.bind(mainMod .. " + S",
--   hl.dsp.workspace.toggle_special("spotify"),
-- )
-- stylua: ignore end

----------------------------
-- Windows and Workspaces --
----------------------------
-- To Disable:
-- local suppressMaximizeRule = hl.window_rule({
hl.window_rule({
  name = "suppress-maximize-events",
  match = { class = ".*" },
  suppress_event = "maximize",
})
-- To Disable:
-- suppressMaximizeRule:set_enabled(false)

-- To Disable:
-- local fixWaylandDrags = hl.window_rule({
hl.window_rule({
  -- Fix some dragging issues with XWayland
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },

  no_focus = true,
})
-- To Disable:
-- fixWaylandDrags:set_enabled(false)

-- To Disable:
-- local hyprlandRunWindowRule = hl.window_rule({
hl.window_rule({
  -- Hyprland-run windowrule
  name = "move-hyprland-run",
  match = { class = "hyprland-run" },

  move = "20 monitor_h-120",
  float = true,
})
-- To Disable:
-- hyprlandRunWindowRule:set_enabled(false)

-- stylua: ignore start
---------------------------
-- Curves And Animations --
---------------------------
------------
-- Curves --
------------
-- Custom Curves
hl.curve("creamy", { type = "bezier", points = { { 0.05, 0.09 }, { 0.1, 1.0 } } })
hl.curve("bounce", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("smoothOut", { type = "bezier", points = { { 0.36, 0 }, { 0.66, -0.56 } } })
-- Default Curves
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

----------------
-- Animations --
----------------
-- Custom Animations
-- -- Creamy & Fast Animations
-- hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "creamy", style = "popin 90%", })
-- hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "creamy", style = "popin 90%", })
-- hl.animation({ leaf = "windowsMove", enabled = true, speed = 3, bezier = "creamy", })
-- hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "creamy" })
-- hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "creamy", style = "fade", })
-- hl.animation({ leaf = "border", enabled = true, speed = 1, bezier = "linear" })
-- hl.animation({ leaf = "borderangle", enabled = true, speed = 30, bezier = "creamy", style = "loop", })
-- -- Bouncy Boi Animations
-- hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "bounce", style = "popin 80%", })
-- hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, bezier = "smoothOut", style = "popin 80%", })
-- hl.animation({ leaf = "windowsIn", enabled = true, speed = 4, bezier = "bounce", })
-- hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default", })
-- hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "linear", style = "loop", })
-- hl.animation({ leaf = "fade", enabled = true, speed = 10, bezier = "default" })
-- hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "bounce", style = "slide", })
-- Default Animations
hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default", })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint", })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint", })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%", })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%", })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear", })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear", })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint", style = "fade", })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "linear", style = "fade", })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.15, bezier = "linear", style = "fade", })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear", })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear", })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade", })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade", })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade", })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick", })
-- stylua: ignore end
