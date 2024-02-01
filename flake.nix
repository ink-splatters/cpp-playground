{
  description = "cpp playground";

  outputs = { nixpkgs, flake-utils, self, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        # pkgs = import nixpkgs {
        #   inherit system;
        #   config.allowUnsupportedSystem = true;
        # };

        CXXFLAGS = "-std=c++20 -stdlib=libc++";
        LDFLAGS= "-lc++";
        name = "cpp-playground";

        nativeBuildInputs = with llvmPackages_latest; [
            ninja
            meson
            ( with llvmPackages_latest; [ llvm lldb clang-tools])
        ];

        # buildInputs = [
        #   boost 
        #   ...
        # ]

      in with pkgs ; {
        formatter = nixpkgs-fmt;

        devShells.default = mkShell.override  { inherit llvmPackages_latest.stdenv; } {
          inherit nativeBuildInputs CXXFLAGS; # LDFLAGS;

        shellHook = ''
                export PS1="\n\[\033[01;32m\]\u $\[\033[00m\]\[\033[01;36m\] \w >\[\033[00m\] "
        '';
        };

        # packages.default = mkDerivation {
        #   inherit name;
        #   # TODO: version
        #   src = ./.
        #   inherit nativeBuildInputs CXXFLAGS; # LDFLAGS;

        #   buildPhase = ''

        #   ''
        # }
}
