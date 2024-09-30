
# my_flakes

`my_flakes` is a flake collecting nix flakes that I use.
I am making this collection so that all the flakes follows the same nixpkgs, otherwise on a system you can end up with many slightly different versions.

For example can be used in a standard `configuration.nix` like so:

```nix
{ config, lib, pkgs, ... }:
let
  my_flakes_flake = builtins.getFlake "github:RCasatta/my_flakes";
  my_flakes = my_flakes.packages.${builtins.currentSystem};
in
{
  systemd.services.my_service = {
    path = [ my_flakes.my_services ];
    script = "my_service --help";
  };
}
```

## update

To update a single flake input use for example:

```
nix flake lock --update-input waterfalls
```
