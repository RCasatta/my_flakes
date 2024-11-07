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
    eternitywall = {
      url = "github:RCasatta/eternitywall";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    opreturn_org = {
      url = "github:RCasatta/opreturn_org";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    lightdash = {
      url = "github:RCasatta/lightdash";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    pay2email = {
      url = "github:RCasatta/pay2email";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    electrs = {
      url = "github:blockstream/electrs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    esplora-enterprise-monitoring = {
      url = "git+ssh://git@git.casatta.it/git/esplora-enterprise-monitoring";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    post2fs = {
      url = "git+ssh://git@git.casatta.it/git/post2fs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    sling = {
      url = "github:daywalker90/sling";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    summars = {
      url = "github:daywalker90/summars";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    lwk_cli = {
      url = "github:blockstream/lwk";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    dinasty = {
      url = "git+ssh://git@git.casatta.it/git/dinasty";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    multiqr = {
      url = "github:RCasatta/multiqr";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , blocks_iterator
    , fbbe
    , waterfalls
    , eternitywall
    , opreturn_org
    , lightdash
    , pay2email
    , electrs
    , esplora-enterprise-monitoring
    , post2fs
    , sling
    , summars
    , lwk_cli
    , dinasty
    , multiqr
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      blocks_iterator_pkg = blocks_iterator.packages.${system};
      fbbe_pkg = fbbe.packages.${system};
      waterfalls_pkg = waterfalls.packages.${system};
      eternitywall_pkg = eternitywall.packages.${system};
      opreturn_org_pkg = opreturn_org.packages.${system};
      lightdash_pkg = lightdash.packages.${system};
      pay2email_pkg = pay2email.packages.${system};
      electrs_pkg = electrs.packages.${system};
      esplora-enterprise-monitoring_pkg = esplora-enterprise-monitoring.packages.${system};
      post2fs_pkg = post2fs.packages.${system};
      sling_pkg = sling.packages.${system};
      summars_pkg = summars.packages.${system};
      lwk_cli_pkg = lwk_cli.packages.${system};
      dinasty_pkg = dinasty.packages.${system};
      multiqr_pkg = multiqr.packages.${system};

    in
    {
      packages.blocks_iterator = blocks_iterator_pkg.default;
      packages.fbbe = fbbe_pkg.default;
      packages.waterfalls = waterfalls_pkg.default;
      packages.eternitywall = eternitywall_pkg.default;
      packages.opreturn_org = opreturn_org_pkg.default;
      packages.lightdash = lightdash_pkg.default;
      packages.pay2email = pay2email_pkg.default;
      packages.electrs = electrs_pkg.bin;
      packages.electrs_liquid = electrs_pkg.binLiquid;
      packages.esplora-enterprise-monitoring = esplora-enterprise-monitoring_pkg.default;
      packages.post2fs = post2fs_pkg.default;
      packages.sling = sling_pkg.default;
      packages.summars = summars_pkg.default;
      packages.lwk_cli = lwk_cli_pkg.default;
      packages.dinasty = dinasty_pkg.default;
      packages.multiqr = multiqr_pkg.default;

    });
}
