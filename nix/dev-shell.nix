{self, ...}: system:
with self.pkgs.${system};
  devshell.mkShell {
    devshell.name = "nix-config";
    devshell.packages = [
      deploy-rs.deploy-rs
      nix-linter
      alejandra
      ragenix
      rnix-lsp
      statix
    ];
    devshell.startup.install-git-hooks.text = ''
      ${self.checks.${system}.pre-commit-check.shellHook}
    '';
  }
