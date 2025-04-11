{ makeDesktopItem, config, pkgs, ... }:

pkgs.stdenvNoCC.mkDerivation rec {
  pname = "zen-browser";
  version = "1.11.1b";
  src = pkgs.fetchurl {
    url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen.linux-x86_64.tar.xz";
    sha256 = "de187d126db82d18babd60b911c4a3638e1ff37e1a931649ac96907960b1f7e5";
  };

  nativeBuildInputs = [
    pkgs.autoPatchelfHook
    #pkgs.git
   ];
  buildInputs = with pkgs; [
    gtk3
    cairo
    gdk-pixbuf
    glib
    dbus
    nss
    nspr
    atk
    alsa-lib
    cups
    libdrm
    mesa
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    libxkbcommon
  ];

  installPhase = ''
    mkdir -p $out/bin $out/opt/zen $out/share/applications $out/share/icons/hicolor/256x256/apps
    cp -r * $out/opt/zen
    ln -s $out/opt/zen/zen $out/bin/zen


    # Install desktop file
    cp ${desktopItem}/share/applications/* $out/share/applications/

    # Install icon if it exists in the package
    if [ -f $out/opt/zen/zen.png ]; then
      cp $out/opt/zen/zen.png $out/share/icons/hicolor/256x256/apps/zen.png
    fi

    # Handle icons
    #git clone --depth 1 https://github.com/zen-browser/branding.git 
    #cp -r ./branding/Old\ Icons/SVG/zen-black.svg $out/share/icons/hicolor/256x256/apps/zen.svg
 
  '';

  desktopItem = makeDesktopItem {
    name = "zen-browser";
    exec = "zen";
    icon = "zen";
    comment = "A powerful Firefox based browser cuz Mozilla is a cuck";
    desktopName = "Zen Browser";
    categories = [ "Network" "WebBrowser" ];
    keywords = [ "browser" "gecko" "web" "internet" ];
    startupNotify = true;
    mimeTypes = [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "application/vnd.mozilla.xul+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
    ];
  };
}
