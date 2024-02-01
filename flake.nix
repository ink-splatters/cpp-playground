{
  description = "cpp playground";

  outputs = { nixpkgs, flake-utils, self, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        name = "cpp-playground";

        nativeBuildInputs = with pkgs;[
          ninja
          meson
          (with llvmPackages_latest; [ llvm lldb clang-tools ])
        ];

        # buildInputs = [
        #   boost 
        #   ...
        # ]

      in
      with pkgs ; {
        formatter = nixpkgs-fmt;

        devShells.default = mkShell.override { inherit (llvmPackages_latest) stdenv; } {
          inherit nativeBuildInputs;

          shellHook = ''
            export PS1="\n\[\033[01;32m\]\u $\[\033[00m\]\[\033[01;36m\] \w >\[\033[00m\] "
          '';
        };

        packages.default = mkDerivation {
          inherit name;
          # TODO: version
          src = ./.;
          inherit nativeBuildInputs;

          buildPhase = ''
            meson setup build
            meson compile
          '';
        };
      });
}
