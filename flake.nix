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
        pkgs = import nixpkgs { inherit system; config = { allowUnsupportedSystem = true; }; };
      in rec {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            stdenv # gcc gnumake libc-dev curl 
            avrdude 
            pkgsCross.avr.buildPackages.gcc # avrgcc 
            # pkgsCross.avr.buildPackages.libc # part of the above
            hidapi
            systemdMinimal
            pkg-config
            rustup
            sdcc 
            xxd
          ];
        };
        formatter = pkgs.alejandra;
      }
    );
}
