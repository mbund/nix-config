{ config, pkgs, ... }: {
  home.pointerCursor = {
    x11.enable = true;
    gtk.enable = true;
    size = 16;

    package = pkgs.nur.repos.ambroisie.vimix-cursors;
    name = "Vimix-white-cursors";
    # name = "Vimix-cursors";
  };

  home.sessionVariables = {
    # wlroots based wayland compositors read these to set their cursor
    XCURSOR_THEME = config.xsession.pointerCursor.name;
    XCURSOR_SIZE = config.xsession.pointerCursor.size;
  };

  xdg.configFile =
    let
      gtkconf = ''
        decoration, decoration:backdrop, window {
          box-shadow: none;
          border: none;
          margin: 0;
        }
      '';
    in
    {
      "gtk-3.0/gtk.css".text = gtkconf;
      "gtk-4.0/gtk.css".text = gtkconf;
    };

  gtk = {
    enable = true;

    font = {
      name = "Roboto";
      package = pkgs.roboto;
    };

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "Catppuccin-orange-dark-compact";
      package = pkgs.catppuccin-gtk.override { size = "compact"; };
    };
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = {
      name = "adwaita";
      package = pkgs.adwaita-qt;
    };
  };
}
