{
  description = "Static Site Generator written in Golang";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.gomod2nix.url = "github:nix-community/gomod2nix";

  outputs = inputs: inputs.flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [ inputs.gomod2nix.overlays.default ];
    };
  in {
    packages.default = pkgs.buildGoApplication {
      name = "myproject";
      pwd = ./.;
      src = ./.;
      modules = ./gomod2nix.toml;
    };

    devShells.default = pkgs.mkShell {
      name = "myproject";
      packages = [
        (pkgs.mkGoEnv { pwd = ./.; })
        pkgs.gomod2nix
      ];
    };
  });
}
