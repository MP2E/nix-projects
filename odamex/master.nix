{ stdenv, cmake, fetchsvn, pkgconfig, SDL, SDL_mixer, SDL_net }:

stdenv.mkDerivation rec {
  name = "odamex-20150513";
  src = fetchsvn {
    url = http://odamex.net/svn/root/trunk;
    rev = "5397";
    sha256 = "1ly1w9n4hxfd9qs49z9qj04mlkb2bfldhg59zj9ijkhd6g7yjcd5";
  };

  cmakeFlags = ''
    -DCMAKE_BUILD_TYPE=Release
  '';

  buildInputs = [ cmake pkgconfig SDL SDL_mixer SDL_net ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://odamex.net/;
    description = "A client/server port for playing old-school Doom online";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ MP2E ];
  };
}
