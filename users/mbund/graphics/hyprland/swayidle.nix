{ pkgs, ... }: {
  home.packages = with pkgs; [
    swayidle
  ];

  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = "swaylock -f"; }
      { event = "lock"; command = "swaylock -f"; }
    ];
    timeouts = [
      { timeout = 230; command = ''notify-send -t 30000 -- "Screen will lock in 30 seconds"''; }
      { timeout = 300; command = "swaylock -f"; }
      {
        timeout = 600;
        command = ''swaymsg "output * dpms off"'';
        resumeCommand = ''swaymsg "output * dpms on"'';
      }
    ];
  };
}
