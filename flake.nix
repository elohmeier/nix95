{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  };

  outputs = { self, nixpkgs, ... }:
    let
      supportedSystems = [
        "x86_64-linux"
        "i686-linux"
        "aarch64-linux"
        "riscv64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      homeManagerModules = {
        default = self.homeManagerModules.nix95;
        nix95 = import ./modules/home.nix;
      };

      nixosModules = {
        default = self.nixosModules.nix95;
        nix95 = import ./modules/nixos.nix;
      };

      overlays.default = final: prev: {
        chicago95 = final.callPackage ./packages/chicago95 { };
      };

      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; overlays = [ self.overlays.default ]; };
        in
        {
          inherit (pkgs) chicago95;
        });
    };
}
