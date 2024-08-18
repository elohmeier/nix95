{ self, inputs, ... }: {
  flake.overlays.default = _self: super: {
    chicago95 = super.callPackage ./packages/chicago95 { };
  };

  perSystem = { system, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
      overlays = [ self.overlays.default ];
    };
  };
}

