Nix flake for running x11vnc as a service.

# Usage
Add this flake as an input to your configuration:
```nix
# flake.nix
inputs = {
  nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  # Add this line:
  options-x11vnc.url = "github:AcrylonitrileButadieneStyrene/nix-flake-x11vnc";
};
```

Load the module
```nix
# flake.nix
nixpkgs.lib.nixosSystem {
  modules = [
    options-x11vnc.nixosModules.default # Add this line.
    ./configuration.nix
  ];
}
```

Use the service somewhere in your configuration
```nix
# configuration.nix (any module works)

# Change these as you need; your display likely is not :1.
services.x11vnc = {
  socketActivation = true;
  display = ":1";
};
```