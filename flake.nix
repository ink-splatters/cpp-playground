{
  description = "cpp playground";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = "https://cachix.cachix.org";
    extra-trusted-public-keys = "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM=";
  };

  outputs = { nixpkgs, flake-utils, pre-commit-hooks, self, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        inherit (pkgs.llvmPackages) stdenv lld;

        CXXFLAGS = pkgs.lib.optionalString ("${system}"=="aarch64-darwin") "-mcpu=apple-m1";

        nativeBuildInputs = with pkgs;[
          ninja
          meson
          ccache
          lld
        ];

      in
      with pkgs ; {
        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              clang-format.enable = true;
              clang-tidy.enable = true;
              deadnix.enable = true;
              markdownlint.enable = true;
              nil.enable = true;
              nixpkgs-fmt.enable = true;
              statix.enable = true;
            };

            tools = pkgs;
          };
	  # TODO: default = ...
        };

        formatter = nixpkgs-fmt;

        devShell = mkShell.override { inherit stdenv; } {
          inherit nativeBuildInputs CXXFLAGS;

          shellHook = self.checks.${system}.pre-commit-check.shellHook + ''
            export PS1="\n\[\033[01;32m\]\u $\[\033[00m\]\[\033[01;36m\] \w >\[\033[00m\] "
          '';
        };

        packages.default = stdenv.mkDerivation {
          name = "cpp-playground";
          src = ./.;

          inherit nativeBuildInputs CXXFLAGS;
        };
      });
}
