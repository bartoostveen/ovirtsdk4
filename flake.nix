{
  description = "Python SDK for oVirt Engine API";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      perSystem =
        { pkgs, self', ... }:

        {
          treefmt = {
            programs.nixfmt.enable = true;
            programs.ruff-check.enable = true;
            programs.ruff-format.enable = true;
            programs.clang-format.enable = true;
          };

          packages = {
            ovirtsdk4 = pkgs.callPackage ./package.nix { };
            default = self'.packages.ovirtsdk4;
          };

          devShells.default = pkgs.mkShell {
            packages = [
              pkgs.python314
              pkgs.uv
              pkgs.ruff
              pkgs.libxml2.dev
              pkgs.pkg-config
            ];
          };
        };
    };
}
