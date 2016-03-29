{ stdenv, cmake, ffmpeg, imagemagick, libzip, pkgconfig, qt54, SDL2 }:

stdenv.mkDerivation rec {
  name = "mgba-20150817";
  src = /home/cray/mgba-src;

  buildInputs = [ cmake ffmpeg imagemagick libzip pkgconfig qt54 SDL2 ];

  enableParallelBuilding = true;

  meta = {
    homepage = https://endrist.com/mgba/;
    description = "A modern GBA emulator with a focus on accuracy";
    license = stdenv.lib.licenses.mpl20;
    maintainers = with stdenv.lib.maintainers; [ MP2E ];
  };
}

