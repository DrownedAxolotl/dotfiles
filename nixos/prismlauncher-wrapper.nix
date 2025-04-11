{ lib, stdenvNoCC, appimage-run, fetchurl, autoPatchelfHook, kdePackages }:

stdenvNoCC.mkDerivation rec {
  pname = "prismlauncher-cracked-wrapper";
  version = "9.2";

  src = fetchurl {
    url = "https://github.com/Diegiwg/PrismLauncher-Cracked/releases/download/${version}/PrismLauncher-Linux-Qt6-Portable-${version}.tar.gz";
    sha256 = "57855a03161284a9da5ad788977fe24af5cf7e9ff9bae77103acc677fbd1b88e";
  };

  nativeBuildInputs = [
    #autoPatchelfHook
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.qtbase
    kdePackages.qtsvg
    appimage-run
  ];


  unpackPhase = ''
    runHook preUnpack

    mkdir ./launcher
    tar -xf $src -C launcher

    cat > prismlauncher << 'EOF'
    #!/bin/bash
    appimage-run /home/filip/Apps/PrismLauncher.AppImage
    EOF

    chmod +x prismlauncher
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/applications $out/share/prismlauncher-cracked 
    cp -r ./launcher/share/icons/* $out/share/icons
    cp -r ./launcher/share/applications/* $out/share/applications
    cp prismlauncher $out/bin/
    #ln -s $out/share/prismlauncher-cracked/PrismLauncher $out/bin/prismlauncher-cracked

    runHook postInstall
  '';

  meta = with lib; {
    description = "A custom launcher for Minecraft that allows you to easily manage multiple installations of Minecraft with cracked authentication (AppImage wrapper edition)";
    homepage = "https://github.com/Diegiwg/PrismLauncher-Cracked";
    license = licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ ];
    mainProgram = "prismlauncher-cracked";
  };
}
