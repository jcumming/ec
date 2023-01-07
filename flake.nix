{
  description = "System 76 EC firmware";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config = {allowUnsupportedSystem = true;};
        };

        versionRev = self.shortRev or "dirty";
        versionDate = builtins.substring 0 8 (self.lastModifiedDate or self.lastModified or "19700101");
        buildInputs = with pkgs; [stdenv avrdude pkgsCross.avr.buildPackages.gcc sdcc xxd];

        mkBoard = board:
          pkgs.stdenv.mkDerivation {
            inherit buildInputs;
            name = board + "-ec-firmware";
            src = ./.;

            buildPhase = ''
              make BOARD=system76/${board} REV=${versionRev} DATE=${versionDate};
            '';

            installPhase = ''
              mkdir -p $out
              cp build/system76/${board}/*/ec.* $out
            '';
          };
      in rec {
        formatter = pkgs.alejandra;
        devShells.default = pkgs.mkShell {inherit buildInputs;};
        packages = flake-utils.lib.flattenTree {
          system76_ectool = pkgs.rustPlatform.buildRustPackage rec {
            pname = "system76_ectool";
            version = versionDate + "-" + versionRev;
            src = ./tool;
            nativeBuildInputs = with pkgs; [pkg-config];
            buildInputs = with pkgs; [hidapi systemdMinimal];
            cargoLock.lockFile = ./tool/Cargo.lock;
          };

          oryp9-ec-firmware = mkBoard "oryp9";
          galp5-ec-firmware = mkBoard "galp5";
        };
      }
    );
}
