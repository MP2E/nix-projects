{ stdenv, cmake, fetchsvn, pkgconfig, SDL, SDL_mixer, SDL_net }:

stdenv.mkDerivation rec {
  name = "odamex-20141019";
  src = fetchsvn {
    url = http://odamex.net/svn/root/trunk;
    rev = "5139";
    sha256 = "1lwnlb38fs9bgd7gw395czrgfxwj25h9jcjl5q3rv7war8crcyq3";
  };

  cmakeFlags = ''
    -DCMAKE_BUILD_TYPE=Release
  '';

  buildInputs = [ stdenv cmake pkgconfig SDL SDL_mixer SDL_net ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://odamex.net/;
    description = "A port with a focus on setting the standard in online Doom";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ MP2E ];
  };
}
