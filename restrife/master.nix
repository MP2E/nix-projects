{ stdenv, cmake, pkgconfig, mesa, SDL2, SDL2_mixer, SDL2_net, ffmpeg }:

stdenv.mkDerivation rec {
  name = "restrife-20141215";
  src = /home/cray/restrife/strife-ve-src;
  buildInputs = [ cmake pkgconfig mesa SDL2 SDL2_mixer SDL2_net ffmpeg ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://store.steampowered.com/app/317040/;
    description = "Strife: Veteran Edition";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ MP2E ];
  };
}
