{
  description = "fnox, packaged from the official Linux release";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      fnox = pkgs.callPackage ./nix/package.nix { };
    in
    {
      packages.${system} = {
        inherit fnox;
        default = fnox;
      };
      apps.${system}.default = {
        type = "app";
        program = "${fnox}/bin/fnox";
      };
    };
}
