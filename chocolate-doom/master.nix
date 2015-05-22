{ stdenv, autoconf, automake, pkgconfig, SDL, SDL_mixer, SDL_net, fetchgit }:

stdenv.mkDerivation rec {
  name = "chocolate-doom-20150513";
  src = fetchgit {
    url = "https://github.com/fragglet/chocolate-doom.git";
    rev = "d1bfae16981023899c7703ec5004655cd6f0ffaf";
    sha256 = "1fbsh920yq3cmfis4nfpsb5kgmgsicwah2fj9s89dq657wpr47la";
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
