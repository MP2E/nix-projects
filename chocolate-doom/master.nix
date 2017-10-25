{ stdenv, autoconf, automake, pkgconfig, SDL2, SDL2_mixer, SDL2_net }:

stdenv.mkDerivation rec {
  name = "chocolate-doom-20171025";
  src = lib.cleanSource ../../cdoomgit;
  nativeBuildInputs = [ autoconf automake pkgconfig ];
  buildInputs = [ SDL2 SDL2_mixer SDL2_net ];
  patchPhase = ''
    sed -e 's#/games#/bin#g' -i src{,/setup}/Makefile.am
    ./autogen.sh --prefix=$out
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = http://chocolate-doom.org/;
    description = "A Doom source port that accurately reproduces the experience of Doom as it was played in the 1990s";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ MP2E ];
  };
}
