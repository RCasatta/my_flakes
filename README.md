
# my_flakes

`my_flakes` is a flake collecting nix flakes that I use.
I am making this collection so that all the flakes follows the same nixpkgs, otherwise on a system you can end up with many slightly different versions.

For example can be used in a standard `configuration.nix` like so:

```nix
{ config, lib, pkgs, ... }:
let
  my_flakes_flake = builtins.getFlake "github:RCasatta/my_flakes";
  my_flakes = my_flakes_flake.packages.${builtins.currentSystem};
in
{
  systemd.services.my_service = {
    path = [ my_flakes.my_services ];
    script = "my_service --help";
  };
}
```

NixOS modules from the inputs are re-exported as `nixosModules`. Their default
packages are the ones in `packages`, built with this flake's nixpkgs:

```nix
{ config, lib, pkgs, ... }:
let
  my_flakes_flake = builtins.getFlake "github:RCasatta/my_flakes";
in
{
  imports = [
    my_flakes_flake.nixosModules.buzz-relay   # relay host
    my_flakes_flake.nixosModules.buzz-agent   # agent host
  ];
  services.buzz-relay.enable = true;
  # See nix/README.md in the buzz repository for the options.
}
```

| Output | Contents |
|--------|----------|
| `packages.buzz` | `buzz-relay`, `buzz-admin`, `buzz-pair-relay` |
| `packages.buzz-sprig` | `buzz-acp`, `buzz-agent`, `buzz-dev-mcp`, and the `buzz` CLI |
| `nixosModules.buzz-relay` | `services.buzz-relay` |
| `nixosModules.buzz-agent` | `services.buzz-agents.<name>` |

## update

To update a single flake input use for example:

```
nix flake lock --update-input waterfalls
```

