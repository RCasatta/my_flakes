{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";

    blocks_iterator = {
      url = "github:RCasatta/blocks_iterator";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    fbbe = {
      url = "github:RCasatta/fbbe";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    waterfalls = {
      url = "github:RCasatta/waterfalls";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, blocks_iterator, fbbe, waterfalls }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        blocks_iterator_pkg = blocks_iterator.packages.${system};
        fbbe_pkg = fbbe.packages.${system};
        waterfalls_pkg = waterfalls.packages.${system};
      in
      {
        packages.blocks_iterator = blocks_iterator_pkg.default;
        packages.fbbe = fbbe_pkg.default;
        packages.waterfalls = waterfalls_pkg.default;
      });
}
