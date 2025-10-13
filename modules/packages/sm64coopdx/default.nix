{
  pkgs,
  lib,
  stdenv,
  requireFile,
  fetchFromGitHub,
  makeDesktopItem,
  baseRom ? requireFile {
    name = "sm64.baserom.us.z64";
    message = ''
      This nix expression requires that sm64.baserom.us.z64 is
      already part of the store. To get this file you can dump your Super Mario 64 cartridge's contents
      and add it to the nix store with nix-store --add-fixed sha256 <FILE>.
      Note that if you are not using a US baserom, you must overwrite the "region" attribute with either "eu" or "jp".
    '';
    sha256 =
      {
        "us" = "17ce077343c6133f8c9f2d6d6d9a4ab62c8cd2aa57c40aea1f490b4c8bb21d91";
        "eu" = "c792e5ebcba34c8d98c0c44cf29747c8ee67e7b907fcc77887f9ff2523f80572";
        "jp" = "9cf7a80db321b07a8d461fe536c02c87b7412433953891cdec9191bfad2db317";
      }
      ."us";
  }
}:
let 
  pname = "sm64coopdx";
  version = "v1.3.2";
  desktopItem = makeDesktopItem {
    name = "SM64 Coop Deluxe";
    desktopName = "SM64 Coop Deluxe";
    genericName = "SM64 Coop Deluxe";
    comment = "Super Mario 64 Multiplayer";
    icon = "sm64coopdx";
    terminal = false;
    type = "Application";
    startupNotify = true;
    categories = [ "Game" ];
    keywords = [ "games" ];

    exec = "sm64coopdx";
  };
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "coop-deluxe";
    repo = "sm64coopdx";
    rev = "v1.3.2";
    hash = "sha256-FHH3+pGowkT8asDmU9qxPNDKy4VPKlkA0X7e4gnX9KY=";
  };

  buildInputs = [
    ## Taken from https://github.com/coop-deluxe/sm64coopdx/wiki/Compiling-(Linux)
    pkgs.python3
    pkgs.pkg-config
    pkgs.SDL2
    pkgs.glew
    pkgs.git
    pkgs.curl
    pkgs.zlib

    pkgs.hexdump
    pkgs.audiofile
  ];

  makeFlags =
    [
      "VERSION=us"
      "-j8"
      "RENDER_API=GL"
      "DISCORD_SDK=0"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "OSX_BUILD=1"
    ];

  preBuild = ''
    patchShebangs extract_assets.py
    ln -s ${baseRom} ./baserom.us.z64
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib
    mkdir -p $out/opt/sm64coopdx

    mv build/us_pc/sm64coopdx $out/opt/sm64coopdx
    mv build/us_pc/dynos $out/opt/sm64coopdx
    mv build/us_pc/lang $out/opt/sm64coopdx
    mv build/us_pc/mods $out/opt/sm64coopdx
    mv build/us_pc/palettes $out/opt/sm64coopdx
    ln -s $out/opt/sm64coopdx/sm64coopdx $out/bin/sm64coopdx

    mkdir -p $out/share/applications/
    ln -s ${desktopItem}/share/applications/* $out/share/applications
  '';
  # meta =
  #   with lib;
  #   {
  #     longDescription =
  #       "sm64coopdx is an online multiplayer project for the Super Mario 64 PC port."
  #       + "\n"
  #       + ''
  #         Note that you must supply a baserom yourself to extract assets from.
  #       '';
  #     homepage = "https://github.com/coop-deluxe/sm64coopdx";
  #     mainProgram = "sm64coopdx";
  #     license = licenses.unfree;
  #     maintainers = [ ];
  #     platforms = platforms.unix;
  #   };
}