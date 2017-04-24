{ stdenv, cmake, pkgconfig, SDL2, SDL2_mixer, SDL2_net, ffmpeg, zlib, libpng, mesa }:

stdenv.mkDerivation rec {
  name = "strife-ve-2.0";
  src = ../../strife-ve-src/strife-ve-src;
  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ SDL2 SDL2_mixer SDL2_net ffmpeg zlib libpng mesa ];

  installPhase = ''
    mkdir -p $out/bin
    cp strife-ve $out/bin
  '';

  meta = {
    homepage = "http://store.steampowered.com/app/317040/";
    description = "Strife: Veteran Edition";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ MP2E ];
  };
}
