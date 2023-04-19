{
  description = "Static Site Generator written in Rust";

  inputs.cargo2nix.url = "github:cargo2nix/cargo2nix";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.follows = "cargo2nix/nixpkgs";

  outputs = inputs: with inputs; flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [ cargo2nix.overlays.default ];
    };

    rustPkgs = pkgs.rustBuilder.makePackageSet {
      rustVersion = "1.61.0";
      packageFun = import ./Cargo.nix;
    };
  in {
    packages.default = (rustPkgs.workspace.ssg-rust {}).bin;
  });
}
