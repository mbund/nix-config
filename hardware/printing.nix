{pkgs, ...}: {
  programs.system-config-printer.enable = true;

  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    gutenprint
    gutenprintBin
    foo2zjs
    # hplipWithPlugin
  ];

  # services.avahi.enable = true;
  # services.avahi.nssmdns = true;
}
