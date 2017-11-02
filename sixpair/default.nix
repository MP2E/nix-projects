{ stdenv, lib, libusb }:

stdenv.mkDerivation rec {
  name = "sixpair";
  src = lib.cleanSource ./.;

  phases = "installPhase";

  installPhase = ''
  mkdir -p $out/bin
  gcc -O2 -lusb $src/sixpair.c -o $out/bin/sixpair
  strip -s $out/bin/sixpair
  '';

  buildInputs = [ libusb ];

  meta = {
    homepage = http://sixpair.org/;
    description = "PS3 pairing tool";
  };
}
