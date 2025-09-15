{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  fontconfig,
  freetype,
  glib,
  gtk3,
  just,
  libinput,
  pkg-config,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-edit";
  version = "1.0.0-alpha.7-unstable-2025-09-14";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-edit";
    rev = "f6e464ee6182d937e8d5d46b13345978498310dd";
    hash = "sha256-QFUuSBfmchz0PjttQb5aNw7hWWhYf9RMO87tt5catio=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-0pmENYRK9gt3Zytc0/2XX0NFLe0EbC2JBwCWOJEFj8k=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
    pkg-config
  ];
  buildInputs = [
    glib
    gtk3
    libinput
    fontconfig
    freetype
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-edit"
  ];

  env.VERGEN_GIT_SHA = src.rev;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-edit";
    description = "Text Editor for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-edit";
  };
}
