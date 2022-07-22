{ pkgs, ... }: {
  home.packages = with pkgs; [
    arkade
    k3sup
    k9s
    kind
    kompose
    kubernetes
    kubernetes-helm-wrapped
    kustomize
    minikube

    doctl
    linode-cli
    vultr-cli
  ];

  programs.zsh.shellAliases = {
    "k" = "kubectl";
    "h" = "helm";
  };
}
