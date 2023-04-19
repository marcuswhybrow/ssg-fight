{
  description = "Static Site Generator written in Rust";

  inputs.rust-overlay.url = "github:oxalica/rust-overlay";
  inputs.cargo2nix.url = "github:cargo2nix/cargo2nix/unstable";
  inputs.cargo2nix.inputs.rust-overlay.follows = "rust-overlay";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.follows = "cargo2nix/nixpkgs";

  outputs = inputs: with inputs; flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [ cargo2nix.overlays.default ];
    };

    # https://github.com/cargo2nix/cargo2nix#arguments-to-makepackageset
    rustPkgs = pkgs.rustBuilder.makePackageSet {
      rustVersion = "1.68.2";
      rustChannel = "stable";
      packageFun = import ./Cargo.nix;
    };
  in {
    packages.default = (rustPkgs.workspace.ssg-rust {}).bin;
  });
}
