{
  description = "Windows 95 theme for NixOS";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";

  outputs = publicInputs @ { self, nixpkgs, ... }:
    let
      loadPrivateFlake = path:
        let
          flakeHash = nixpkgs.lib.fileContents "${toString path}.narHash";
          flakePath = "path:${toString path}?narHash=${flakeHash}";
        in
        builtins.getFlake (builtins.unsafeDiscardStringContext flakePath);

      privateFlake = loadPrivateFlake ./dev/private;

      inputs = privateFlake.inputs // publicInputs;
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./overlays.nix
        inputs.pre-commit-hooks-nix.flakeModule
        inputs.treefmt-nix.flakeModule
      ];

      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];

      perSystem = { config, lib, pkgs, self', system, ... }:
        let
          defaultPlatform = pkgs.stdenv.hostPlatform.system == "x86_64-linux";
          inherit (pkgs.stdenv.hostPlatform) isLinux;
        in
        {
          checks =
            let
              devShells = lib.mapAttrs' (n: lib.nameValuePair "devShell-${n}") self'.devShells;
              packages = lib.mapAttrs' (n: lib.nameValuePair "package-${n}") self'.packages;
            in
            devShells // { inherit (self') formatter; } // packages //
            (lib.optionalAttrs isLinux (import ./dev/checks.nix {
              inherit self pkgs;
              prefix = "nixos";
            }))
            // (lib.optionalAttrs isLinux (import ./dev/checks.nix {
              inherit self;
              pkgs = import inputs.nixos-stable {
                inherit system;
                overlays = [ self.overlays.default ];
              };
              prefix = "nixos-stable";
            }));

          packages = {
            update-dev-private-narHash = pkgs.writeScriptBin "update-dev-private-narHash" ''
              nix flake lock ./dev/private
              nix hash path ./dev/private > ./dev/private.narHash
            '';

            inherit (pkgs)
              chicago95;
          };
          pre-commit = {
            check.enable = defaultPlatform;
            settings.hooks.dev-private-narHash = {
              enable = true;
              description = "dev-private-narHash";
              entry = "sh -c '${lib.getExe pkgs.nix} --extra-experimental-features nix-command hash path ./dev/private > ./dev/private.narHash'";
            };
          };
          treefmt = {
            flakeCheck = defaultPlatform;
            imports = [ ./dev/treefmt.nix ];
          };
        };

      # generates future flake outputs: `modules.<kind>.<module-name>`
      flake.modules.nixos = import ./nixos;
      flake.modules.home = import ./home;

      # compat to current schema: `nixosModules` / `homeModules`
      flake.nixosModules = self.modules.nixos;
      flake.homeModules = self.modules.home;
    };
}
