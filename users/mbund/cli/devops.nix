{ pkgs, ... }: {
  home.packages = with pkgs; [
    kubernetes-helm-wrapped
    kubernetes
    minikube
    k3sup
    arkade

    linode-cli
    doctl
    vultr-cli
  ];

  programs.zsh.shellAliases = {
    "k" = "kubectl";
    "h" = "helm";
  };
}
