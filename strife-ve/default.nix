{ stdenv, cmake, pkgconfig, SDL, SDL_mixer, SDL_net, ffmpeg_2, zlib, libpng }:

stdenv.mkDerivation rec {
  name = "strife-ve-1.3";
  src = ../../strife-ve-src/strife-ve-src;
  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ SDL SDL_mixer SDL_net ffmpeg_2 zlib libpng ];

  installPhase = ''
    mkdir -p $out/bin
    cp strife-ve $out/bin
  '';

  meta = {
    homepage = http://store.steampowered.com/app/317040/;
    description = "Strife: Veteran Edition";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ MP2E ];
  };
}
