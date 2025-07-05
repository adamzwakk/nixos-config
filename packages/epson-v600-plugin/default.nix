{ lib, stdenv, fetchurl, autoPatchelfHook, rpm, cpio }:

let
  pname = "epson-v-600-plugin";
  version = "2.30.4";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    urls = [
      "https://download2.ebz.epson.net/iscan/plugin/gt-x820/rpm/x64/iscan-gt-x820-bundle-2.30.4.x64.rpm.tar.gz"
    ];
    sha256 = "sha256-Y2R9rGjia/7lvXUQjMak3w/duEU6HjusLWPep9tRi+4=";
  };

  nativeBuildInputs = [ autoPatchelfHook rpm ];

  installPhase = ''
    cd plugins
    ${rpm}/bin/rpm2cpio iscan-plugin-gt-x820-*.x86_64.rpm | ${cpio}/bin/cpio -idmv
    mkdir -p $out/share
    mkdir -p $out/lib
    cp -r usr/share/* $out/share
    cp -r usr/lib64/* $out/lib
  '';

  meta = with lib; {
    homepage = "https://download.ebz.epson.net/dsc/search/01/search/searchModule";
    description = "plugin files for epson perfection v600 scanner";
    license = licenses.epson;
    platforms = platforms.linux;
  };
}