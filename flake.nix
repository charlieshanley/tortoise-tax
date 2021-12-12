{
  description = "Tortoise Tax";

  inputs.nixpkgs.url = "nixpkgs/nixos-21.05";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      inherit (pkgs) cabal-install cabal2nix ghcid haskellPackages mkShell;
    in
      {
        devShell = mkShell {
          nativeBuildInputs = [
            cabal-install cabal2nix haskellPackages.ghc ghcid
          ];
        };
      });
}
