{ cosmicOverlay }:
{
  disabledModules = [
    "services/desktop-managers/cosmic.nix"
    "services/display-managers/cosmic-greeter.nix"
  ];
  imports = import ./module-list.nix;

  nixpkgs.overlays = [ cosmicOverlay ];
}
