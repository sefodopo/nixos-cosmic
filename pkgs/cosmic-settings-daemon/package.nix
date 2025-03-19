{
  lib,
  fetchFromGitHub,
  rustPlatform,
  geoclue2-with-demo-agent,
  libinput,
  pkg-config,
  udev,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "cosmic-settings-daemon";
  version = "0-unstable-2025-03-19";

  src = fetchFromGitHub {
    owner = "sefodopo";
    repo = "cosmic-settings-daemon";
    rev = "b298ec1c2a496885a7e3aae69699a53c06c7e618";
    hash = "sha256-ILx5BLF3UB3JW8VzimN3Elk1zGmBcX0+wtLTmnwzB2Y=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-EdvvKBU/7dUsVj5XysrbWZtZmfikUaJKaxCJueR5snA=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libinput
    udev
  ];

  env.GEOCLUE_AGENT = "${lib.getLib geoclue2-with-demo-agent}/libexec/geoclue-2.0/demos/agent";

  postInstall = ''
    mkdir -p $out/share/{polkit-1/rules.d,cosmic/com.system76.CosmicSettings.Shortcuts/v1}
    cp data/polkit-1/rules.d/*.rules $out/share/polkit-1/rules.d/
    cp data/system_actions.ron $out/share/cosmic/com.system76.CosmicSettings.Shortcuts/v1/system_actions
    cp data/vim_symbols.ron $out/share/cosmic/com.system76.CosmicSettings.Shortcuts/v1/vim_symbols
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-settings-daemon";
    description = "Settings daemon for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-settings-daemon";
  };
}
