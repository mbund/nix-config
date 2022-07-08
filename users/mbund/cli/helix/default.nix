{ lib
, pkgs
, self
, ...
}: {
  programs.helix = {
    enable = true;
    package = self.inputs.helix.packages.${pkgs.system}.default;

    languages = import ./languages.nix { inherit pkgs; };

    settings = {
      theme = "catppuccin_mocha";
      editor = {
        true-color = true;
      };
      keys.normal.space.u = {
        f = ":format"; # format using LSP formatter
        a = [ "select_all" ":pipe alejandra" ]; # format Nix with Alejandra
        w = ":set whitespace.render all";
        W = ":set whitespace.render none";
      };
    };
  };

  xdg.configFile =
    let
      variants = [ "catppuccin_latte" "catppuccin_frappe" "catppuccin_macchiato" "catppuccin_mocha" ];
    in
    lib.mapAttrs' (n: lib.nameValuePair "helix/themes/${n}.toml") (lib.genAttrs variants (n: { source = "${self.inputs.catppuccin-helix}/italics/${n}.toml"; }));
}
