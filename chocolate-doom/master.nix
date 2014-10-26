{ stdenv, autoconf, automake, pkgconfig, SDL, SDL_mixer, SDL_net, fetchgit }:

stdenv.mkDerivation rec {
  name = "chocolate-doom-20141026";
  src = fetchgit {
    url = "https://github.com/fragglet/chocolate-doom.git";
    rev = "f55a88fec2949c834aa6c4434f22fcaf717ee11d";
    sha256 = "08a35ar4nx88wrd8k2m4ycgis171m59sf2hn42f20cl10fwd6zr2";
  };
  buildInputs = [ autoconf automake pkgconfig SDL SDL_mixer SDL_net ];
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
