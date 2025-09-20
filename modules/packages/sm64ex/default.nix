{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  python3,
  pkg-config,
  audiofile,
  SDL2,
  hexdump,
  libGL,
  requireFile,
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
  pname = "sm64ex";
  version = "0-unstable-2024-07-04";
  desktopItem = makeDesktopItem {
    name = "SM64ex";
    desktopName = "SM64ex";
    genericName = "SM64ex";
    comment = "Super Mario 64 EX";
    icon = "sm64ex";
    terminal = false;
    type = "Application";
    startupNotify = true;
    categories = [ "Game" ];
    keywords = [ "games" ];

    exec = "sm64ex";
  };
in
stdenv.mkDerivation (finalAttrs: {

  pname = "sm64ex";
  version = "0-unstable-2024-07-04";

  src = fetchFromGitHub {
    owner = "sm64pc";
    repo = "sm64ex";
    rev = "20bb444562aa1dba79cf6adcb5da632ba580eec3";
    hash = "sha256-nw+F0upTetLqib5r5QxmcOauSJccpTydV3soXz9CHLQ=";
  };

  patches = [
    (fetchpatch {
      name = "60fps_ex.patch";
      url = "file://${finalAttrs.src}/enhancements/60fps_ex.patch";
      hash = "sha256-2V7WcZ8zG8Ef0bHmXVz2iaR48XRRDjTvynC4RPxMkcA=";
    })
  ];

  nativeBuildInputs = [
    python3
    pkg-config
    hexdump
    libGL
  ];

  buildInputs = [
    audiofile
    SDL2
  ];

  enableParallelBuilding = true;

  makeFlags =
    [
      "VERSION=us"
      "BETTERCAMERA=1"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "OSX_BUILD=1"
    ];

  preBuild = ''
    patchShebangs extract_assets.py
    ln -s ${baseRom} ./baserom.us.z64
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp build/us_pc/sm64.us.f3dex2e $out/bin/sm64ex
    mkdir -p $out/share/applications/
    ln -s ${desktopItem}/share/applications/* $out/share/applications

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/sm64pc/sm64ex";
    description = "Super Mario 64 port based off of decompilation";
    longDescription = ''
      Note that you must supply a baserom yourself to extract assets from.
      If you are not using an US baserom, you must overwrite the "region" attribute with either "eu" or "jp".
      If you would like to use patches sm64ex distributes as makeflags, add them to the "compileFlags" attribute.
    '';
    mainProgram = "sm64ex";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ qubitnano ];
    platforms = lib.platforms.unix;
  };
})
