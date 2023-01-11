{self, ...}: system:
with self.pkgs.${system};
  devshell.mkShell {
    name = "nix-config";
    packages = [
      deploy-rs.deploy-rs
      alejandra
      ragenix
      rnix-lsp
      statix
    ];
    devshell.startup.install-git-hooks.text = ''
      ${self.checks.${system}.pre-commit-check.shellHook}
    '';
  }
