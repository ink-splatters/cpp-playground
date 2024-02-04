{
  description = "cpp playground";

  outputs = { nixpkgs, flake-utils, self, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        nativeBuildInputs = with pkgs;[
          ninja
          meson
        ];

      in
      with pkgs ; {
        formatter = nixpkgs-fmt;

        devShells.default = mkShell {
          inherit nativeBuildInputs;

          shellHook = ''
            export PS1="\n\[\033[01;32m\]\u $\[\033[00m\]\[\033[01;36m\] \w >\[\033[00m\] "
          '';
        };

        packages.default = stdenv.mkDerivation {
          name = "cpp-playground";
          src = ./.;

          CXXFLAGS = if "${system}" == "aarch64-darwin" then "-mcpu=apple-m1" else "";

          inherit nativeBuildInputs;
        };
      });
}
