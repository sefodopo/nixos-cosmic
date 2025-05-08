{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  just,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-applibrary";
  version = "1.0.0-alpha.7-unstable-2025-05-07";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-applibrary";
    rev = "a5426a2015be1348cc43205967ba113059a623c6";
    hash = "sha256-QSY5SnToghWGS83b+R4C/Lv2/1ouE9xBTVV39Qho5wY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-MBjktw0NZ6KBvgt7EK1bHjVG/kRSsxVA3BJCqDxfEjU=";

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
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-app-library"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-applibrary";
    description = "Application Template for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-app-library";
  };
}
