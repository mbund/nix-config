{
  self,
  pre-commit-hooks,
  ...
}: system:
with self.pkgs.${system};
  {
    pre-commit-check =
      pre-commit-hooks.lib.${system}.run
      {
        src = lib.cleanSource ../.;
        hooks = {
          alejandra.enable = true;
          statix.enable = true;
          actionlint = {
            enable = true;
            files = "^.github/workflows/";
            types = ["yaml"];
            entry = "${actionlint}/bin/actionlint";
          };
        };
      };
  }
  // (deploy-rs.lib.deployChecks self.deploy)
