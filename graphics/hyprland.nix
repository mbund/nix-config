{ pkgs, ... }:
{
  programs.hyprland.enable = true;
  programs.hyprland.extraPackages = [ ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;
  };

  services.xserver = {
    enable = true;

    displayManager.gdm.enable = true;

    displayManager.session = [
      {
        manage = "window";
        name = "home-manager";
        start = "exec $HOME/.xsession-hm";
      }
    ];

    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
      mouse.accelSpeed = "0";
      mouse.middleEmulation = false;
    };
  };

  # allow swaylock to unlock the screen
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    gtkUsePortal = true;
    wlr = {
      enable = true;
      settings.screencast = {
        chooser_type = "simple";
        chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
      };
    };
  };

  programs.dconf.enable = true;
  services.dbus.packages = with pkgs; [ dconf ];
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  programs.seahorse.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
}
