{ pkgs, ... }: {
  home.packages = with pkgs; [
    helix
  ];

  xdg.configFile."helix/config.toml".text = ''
    theme = "onedark"

    [editor]
    line-number = "relative"
    auto-pairs = false

    [editor.whitespace]
    render = "all"

    [editor.whitespace.characters]
    space = "·"
    nbsp = "⍽"
    tab = "→"
    newline = "⏎"
  '';
}
