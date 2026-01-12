{ pkgs, lib, ... }:

{
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
    ];
    functions = {
      fish_greeting = {
        body = "";
      };
    };
    interactiveShellInit = ''
      set -g fish_color_command green
    '';
  };

  home.activation.configure-tide = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    ${pkgs.fish}/bin/fish -c '
      if functions -q tide
        tide configure --auto \
          --style=Classic \
          --prompt_colors="True color" \
          --classic_prompt_color=Darkest \
          --show_time="24-hour format" \
          --classic_prompt_separators=Angled \
          --powerline_prompt_heads=Sharp \
          --powerline_prompt_tails=Flat \
          --powerline_prompt_style="Two lines, frame" \
          --prompt_connection=Dotted \
          --powerline_right_prompt_frame=No \
          --prompt_connection_andor_frame_color=Lightest \
          --prompt_spacing=Sparse \
          --icons="Many icons" \
          --transient=No
      else
        echo "tide not installed, skipping configure"
      end'
  '';
}
