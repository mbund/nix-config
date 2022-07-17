{ pkgs, ... }: {
  home.packages = with pkgs; [
    kubernetes-helm-wrapped
    kubernetes

    linode-cli
    doctl
    vultr-cli
  ];

  programs.zsh.shellAliases = {
    "k" = "kubectl";
    "h" = "helm";
  };
}
