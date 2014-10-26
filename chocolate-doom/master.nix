{ stdenv, autoconf, fetchgit, pkgconfig, SDL, SDL_mixer, SDL_net }:

stdenv.mkDerivation rec {
  name = "chocolate-doom-20141026";
  src = fetchgit {
    url = https://github.com/chocolate-doom/chocolate-doom;
    rev = "f55a88fec2949c834aa6c4434f22fcaf717ee11d";
    sha256 = "08a35ar4nx88wrd8k2m4ycgis171m59sf2hn42f20cl10fwd6zr2";
  };

  buildInputs = [ autoconf pkgconfig SDL SDL_mixer SDL_net ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://chocolate-doom.org/;
    description = "A port that aims to recreate Doom the way it was experienced in the 90s";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ MP2E ];
  };
}
