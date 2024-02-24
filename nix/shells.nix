{ pkgs, common, self, system, ... }:
with pkgs; rec {

  default = mkShell.override { inherit (llvmPackages) stdenv; } {

    name = "cpp-shell";

    shellHook = self.checks.${system}.pre-commit-check.shellHook + ''
      export PS1="\n\[\033[01;36m\]‹⊂˖˖› \\$ \[\033[00m\]"
      echo -e "\nto install pre-commit hooks:\n\x1b[1;37mnix develop .#install-hooks\x1b[00m"
    '';
  } // common;

  install-hooks =
    mkShell { inherit (self.checks.${system}.pre-commit-check) shellHook; };
}
