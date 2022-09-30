final: _: {
  godot4-beta = final.stdenv.mkDerivation {
    pname = "godot";
    version = "4.0-beta2";

    src = fetchTarball {
      url = "https://downloads.tuxfamily.org/godotengine/4.0/beta2/godot-4.0-beta2.tar.xz";
      sha256 = "1r4ijy907la1v64d4xam6gw7zmvghqqbn9pxksd6gl77ngxspwpl";
    };

    nativeBuildInputs = with final; [
      pkg-config
      autoPatchelfHook
    ];

    buildInputs = with final; [
      scons
      udev
      xorg.libX11
      xorg.libXcursor
      xorg.libXinerama
      xorg.libXrandr
      xorg.libXrender
      xorg.libXi
      xorg.libXext
      xorg.libXfixes
      freetype
      openssl
      alsa-lib
      libpulseaudio
      libGLU
      zlib
      yasm
      vulkan-loader
    ];

    runtimeDependencies = with final; [
      vulkan-loader
      libpulseaudio
    ];

    patchPhase = ''
      substituteInPlace platform/linuxbsd/detect.py --replace 'pkg-config xi ' 'pkg-config xi xfixes '
    '';

    outputs = ["out" "man" "dev"];

    sconsFlags = "platform=linuxbsd";

    enableParallelBuilding = true;

    installPhase = ''
      mkdir -p "$out/bin"
      cp bin/godot.* $out/bin/godot
      mkdir -p "$dev/godot"
      cp core/extension/gdnative_interface.h "$dev/godot/"
      # "$out/bin/godot" --dump-extension-api "$dev/extension_api.json"
      mkdir -p "$man/share/man/man6"
      cp misc/dist/linux/godot.6 "$man/share/man/man6/"
      mkdir -p "$out"/share/{applications,icons/hicolor/scalable/apps}
      cp misc/dist/linux/org.godotengine.Godot.desktop "$out/share/applications/"
      cp icon.svg "$out/share/icons/hicolor/scalable/apps/godot.svg"
      cp icon.png "$out/share/icons/godot.png"
      substituteInPlace "$out/share/applications/org.godotengine.Godot.desktop" \
        --replace "Exec=godot" "Exec=$out/bin/godot"
    '';
  };
}
