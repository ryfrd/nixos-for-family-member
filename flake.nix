{
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  outputs = { nixpkgs, ... }: {
    nixosConfigurations.simpleton = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./simpleton.nix
      ];
    };
  };
}
