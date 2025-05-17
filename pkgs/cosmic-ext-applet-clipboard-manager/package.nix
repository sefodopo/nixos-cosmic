{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  just,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-ext-applet-clipboard-manager";
  version = "0.1.0-unstable-2025-05-17";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "clipboard-manager";
    rev = "7adadb2c4608b90eb965b64a4fb67fa7a4a0d576";
    hash = "sha256-+AJAbw1tOKsteD4RX0mnVIcVoHvRryQ4IUyumQAvyPw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-OabpLa0mkpSOXIiJnNbnbV2QU8aTC6ybdwLNBpjm0aQ=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "env-dst"
    "${placeholder "out"}/etc/profile.d/cosmic-ext-applet-clipboard-manager.sh"
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-applet-clipboard-manager"
  ];

  preCheck = ''
    export XDG_RUNTIME_DIR="$TMP"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/cosmic-utils/clipboard-manager";
    description = "Clipboard manager for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-ext-applet-clipboard-manager";
  };
}
