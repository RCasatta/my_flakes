{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    blocks_iterator = {
      url = "github:RCasatta/blocks_iterator";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    botco = {
      url = "github:RCasatta/botco";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    brokenlinks = {
      url = "github:RCasatta/brokenlinks";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    buzz = {
      url = "github:RCasatta/buzz/nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    fbbe = {
      url = "github:RCasatta/fbbe";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    forge-sync = {
      url = "github:RCasatta/forge-sync";
    };
    funes = {
      url = "github:RCasatta/funes/nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    waterfalls = {
      url = "github:RCasatta/waterfalls";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.rust-overlay.follows = "rust-overlay";
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
      inputs.rust-overlay.follows = "rust-overlay";
    };
    pay2email = {
      url = "github:RCasatta/pay2email";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    sling = {
      url = "github:daywalker90/sling";
      # url = "github:RCasatta/sling";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    summars = {
      url = "github:daywalker90/summars";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    lwk_cli = {
      url = "https://github.com/blockstream/lwk/archive/refs/heads/master.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.rust-overlay.follows = "rust-overlay";
      inputs.waterfalls-rust-overlay.follows = "rust-overlay";
    };
    multiqr = {
      url = "github:RCasatta/multiqr";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    firma2 = {
      url = "github:RCasatta/firma2";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    scriptpubkeys_per_block = {
      url = "github:RCasatta/scriptpubkeys_per_block/bi2";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    btc_median_price = {
      url = "github:RCasatta/btc_median_price";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , rust-overlay
    , blocks_iterator
    , botco
    , brokenlinks
    , buzz
    , fbbe
    , forge-sync
    , funes
    , waterfalls
    , eternitywall
    , opreturn_org
    , lightdash
    , pay2email
    , sling
    , summars
    , lwk_cli
    , multiqr
    , firma2
    , scriptpubkeys_per_block
    , btc_median_price
    }:
    (flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      blocks_iterator_pkg = blocks_iterator.packages.${system};
      botco_pkg = botco.packages.${system};
      brokenlinks_pkg = brokenlinks.packages.${system};
      buzz_pkg = buzz.packages.${system};
      fbbe_pkg = fbbe.packages.${system};
      forge_sync_pkg = forge-sync.packages.${system};
      funes_pkg = funes.packages.${system};
      waterfalls_pkg = waterfalls.packages.${system};
      eternitywall_pkg = eternitywall.packages.${system};
      opreturn_org_pkg = opreturn_org.packages.${system};
      lightdash_pkg = lightdash.packages.${system};
      pay2email_pkg = pay2email.packages.${system};
      sling_pkg = sling.packages.${system};
      summars_pkg = summars.packages.${system};
      lwk_cli_pkg = lwk_cli.packages.${system};
      multiqr_pkg = multiqr.packages.${system};
      firma2_pkg = firma2.packages.${system};
      scriptpubkeys_per_block_pkg = scriptpubkeys_per_block.packages.${system};
      btc_median_price_pkg = btc_median_price.packages.${system};

    in
    {
      packages.blocks_iterator = blocks_iterator_pkg.default;
      packages.botco = botco_pkg.default;
      packages.brokenlinks = brokenlinks_pkg.default;
      packages.buzz = buzz_pkg.default;
      packages.buzz-sprig = buzz_pkg.sprig;
      packages.fbbe = fbbe_pkg.default;
      packages.forge-sync = forge_sync_pkg.default;
      packages.funes = funes_pkg.default;
      packages.waterfalls = waterfalls_pkg.default;
      packages.eternitywall = eternitywall_pkg.default;
      packages.opreturn_org = opreturn_org_pkg.default;
      packages.lightdash = lightdash_pkg.default;
      packages.pay2email = pay2email_pkg.default;
      packages.sling = sling_pkg.default;
      packages.summars = summars_pkg.default;
      packages.lwk_cli = lwk_cli_pkg.default;
      packages.multiqr = multiqr_pkg.default;
      packages.firma2 = firma2_pkg.default;
      packages.scriptpubkeys_per_block = scriptpubkeys_per_block_pkg.default;
      packages.btc_median_price = btc_median_price_pkg.default;

    })) // {
      # NixOS modules are not per-system. Their default packages come from the
      # inputs above, so they are built with this flake's nixpkgs.
      nixosModules.buzz-relay = buzz.nixosModules.buzz-relay;
      nixosModules.buzz-agent = buzz.nixosModules.buzz-agent;
      nixosModules.botco = botco.nixosModules.default;
    };
}
