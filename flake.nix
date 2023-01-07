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
        buildInputs = with pkgs; [stdenv avrdude pkgsCross.avr.buildPackages.gcc hidapi systemdMinimal pkg-config rustup sdcc xxd git];
        mkBoard = board:
          pkgs.stdenv.mkDerivation {
            inherit buildInputs;
            name = board + "-ec-firmware";
            src = ./.;

            buildPhase = ''
              make BOARD=system76/${board} REV=${self.shortRev or "dirty"}
            '';

            installPhase = ''
              mkdir -p $out
              cp build/system76/${board}/*/ec.rom $out
              set +x
            '';
          };
      in rec {
        formatter = pkgs.alejandra;
        devShells.default = pkgs.mkShell {inherit buildInputs;};
        packages = flake-utils.lib.flattenTree {
          oryp9-ec-firmware = mkBoard "oryp9";
          galp5-ec-firmware = mkBoard "galp5";
        };
      }
    );
}
