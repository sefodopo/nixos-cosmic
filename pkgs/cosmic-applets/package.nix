{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  dbus,
  glib,
  just,
  libinput,
  pkg-config,
  pulseaudio,
  pipewire,
  stdenv,
  udev,
  util-linux,
  xkeyboard_config,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-applets";
  version = "1.0.0-alpha.7-unstable-2025-09-14";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-applets";
    rev = "c327f88a8a0a32195e16ef02052a47b1cc28d495";
    hash = "sha256-NEjzySWb/xoYG9uYOBzyP0GB4ZN+IqDDihEQlYsW4p4=";
  };

  cargoHash = "sha256-B+V5hw/gGUOrmsVf25ZvYDVPOq350v1YJB7wpHI0ioU=";

  nativeBuildInputs = [
    libcosmicAppHook
    rustPlatform.bindgenHook
    just
    pkg-config
    util-linux
  ];
  buildInputs = [
    dbus
    glib
    libinput
    pulseaudio
    pipewire.dev
    udev
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "target"
    "${stdenv.hostPlatform.rust.cargoShortTarget}/release"
  ];

  postInstall = ''
    libcosmicAppWrapperArgs+=(--set-default X11_BASE_RULES_XML ${xkeyboard_config}/share/X11/xkb/rules/base.xml)
    libcosmicAppWrapperArgs+=(--set-default X11_EXTRA_RULES_XML ${xkeyboard_config}/share/X11/xkb/rules/base.extras.xml)
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-applets";
    description = "Applets for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
  };
}
