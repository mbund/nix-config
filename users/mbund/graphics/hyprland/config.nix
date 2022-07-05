{ config
, pkgs
, colors
, ...
}:
let
  xargb = colors.xargbColors;

  emoji = "${pkgs.wofi-emoji}/bin/wofi-emoji";
  launcher = "${pkgs.wofi}/bin/wofi --show drun -Iiq";
  term = "${pkgs.kitty}/bin/kitty";

  grim = "${pkgs.grim}/bin/grim";
  light = "${pkgs.light}/bin/light";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  pulsemixer = "${pkgs.pulsemixer}/bin/pulsemixer";
  slurp = "${pkgs.slurp}/bin/slurp";
  wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";

  config = ''
    # should be configured per-profile
    monitor=eDP-1,2560x1600@60,1366x0,1.6
    workspace=eDP-1,1
    monitor=DP-1,1366x768@60,0x0,1
    workspace=DP-1,10
    monitor=DP-2,1366x768@60,0x0,1
    workspace=DP-2,10

    exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY HYPRLAND_INSTANCE_SIGNATURE
    exec-once=systemctl --user start graphical-session-pre.target
    exec-once=systemctl --user start graphical-session.target
    exec-once=swaybg -i ~/.config/wallpaper.jpg
    exec-once=mako

    input {
        kb_layout=ro
        kb_variant=
        kb_model=
        kb_options=
        kb_rules=

        follow_mouse=1
        force_no_accel=1

        touchpad {
          natural_scroll=1
        }
    }

    general {
        sensitivity=1
        main_mod=SUPER

        gaps_in=5
        gaps_out=5
        border_size=2
        col.active_border=0x${xargb.base06}
        col.inactive_border=0x${xargb.base02}

        damage_tracking=full
    }

    decoration {
        rounding=16
        blur=1
        blur_size=3 # minimum 1
        blur_passes=3 # minimum 1, more passes = more resource intensive.
        # Your blur "amount" is blur_size * blur_passes, but high blur_size (over around 5-ish) will produce artifacts.
        # if you want heavy blur, you need to up the blur_passes.
        # the more passes, the more you can up the blur_size without noticing artifacts.
    }

    animations {
        enabled=1
        animation=windows,1,2,default
        animation=borders,1,2,default
        animation=fadein,1,2,default
        animation=workspaces,1,2,slide
    }

    dwindle {
        pseudotile=0 # enable pseudotiling on dwindle
    }

    windowrule=float,title:^(Picture-in-Picture)$
    windowrule=float,title:^(Firefox — Sharing Indicator)$
    windowrule=move 0 0,title:^(Firefox — Sharing Indicator)$

    bind=SUPER,RETURN,exec,${term}
    bind=SUPER,Space,exec,${launcher}
    bind=SUPER,Q,killactive,
    bind=SUPERSHIFT,E,exec,pkill Hyprland
    bind=SUPER,E,exec,${emoji}
    bind=SUPER,F,fullscreen,
    bind=SUPER,T,togglefloating,
    bind=SUPER,P,pseudo,
    bind=SUPER,L,exec,swaylock

    bind=,XF86AudioPlay,exec,${playerctl} play-pause
    bind=,XF86AudioPrev,exec,${playerctl} previous
    bind=,XF86AudioNext,exec,${playerctl} next
    bind=,XF86AudioRaiseVolume,exec,${pulsemixer} --change-volume +6
    bind=,XF86AudioLowerVolume,exec,${pulsemixer} --change-volume -6
    bind=,XF86AudioMute,exec,${pulsemixer} --toggle-mute

    bind=,XF86MonBrightnessUp,exec,${light} -A 5
    bind=,XF86MonBrightnessDown,exec,${light} -U 5

    # screenshot
    # selection
    $ssselection=${grim} -g "$(${slurp})" - | ${wl-copy} -t image/png
    bind=,Print,exec,$ssselection
    bind=SUPERSHIFT,R,exec,$ssselection

    # monitor
    $ssmonitor=${grim} -o "$(${slurp} -f %o -or)" - | ${wl-copy} -t image/png
    bind=CTRL,Print,exec,$ssmonitor
    bind=SUPERSHIFTCTRL,R,exec,$ssmonitor

    # all-monitors
    $ssall=${grim} - | ${wl-copy} -t image/png
    bind=ALT,Print,exec,$ssall
    bind=SUPERSHIFTALT,R,exec,$ssall

    # move focus
    bind=SUPER,left,movefocus,l
    bind=SUPER,right,movefocus,r
    bind=SUPER,up,movefocus,u
    bind=SUPER,down,movefocus,d

    # go to workspace
    bind=SUPER,grave,togglespecialworkspace,eDP-1
    bind=SUPER,1,workspace,1
    bind=SUPER,2,workspace,2
    bind=SUPER,3,workspace,3
    bind=SUPER,4,workspace,4
    bind=SUPER,5,workspace,5
    bind=SUPER,6,workspace,6
    bind=SUPER,7,workspace,7
    bind=SUPER,8,workspace,8
    bind=SUPER,9,workspace,9
    bind=SUPER,0,workspace,10

    # cycle workspaces
    bind=SUPER,bracketleft,workspace,m-1
    bind=SUPER,bracketright,workspace,m+1
    # cycle monitors
    bind=SUPERSHIFT,braceleft,focusmonitor,l
    bind=SUPERSHIFT,braceright,focusmonitor,r

    # move to workspace
    bind=SUPERSHIFT,asciitilde,movetoworkspace,special
    bind=SUPERSHIFT,exclam,movetoworkspace,1
    bind=SUPERSHIFT,at,movetoworkspace,2
    bind=SUPERSHIFT,numbersign,movetoworkspace,3
    bind=SUPERSHIFT,dollar,movetoworkspace,4
    bind=SUPERSHIFT,percent,movetoworkspace,5
    bind=SUPERSHIFT,asciicircum,movetoworkspace,6
    bind=SUPERSHIFT,ampersand,movetoworkspace,7
    bind=SUPERSHIFT,asterisk,movetoworkspace,8
    bind=SUPERSHIFT,parenleft,movetoworkspace,9
    bind=SUPERSHIFT,parenright,movetoworkspace,10
  '';
in
config
