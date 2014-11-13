{ stdenv, autoconf, automake, pkgconfig, SDL, SDL_mixer, SDL_net, fetchgit }:

stdenv.mkDerivation rec {
  name = "chocolate-doom-20141101";
  src = fetchgit {
    url = "https://github.com/fragglet/chocolate-doom.git";
    rev = "66b295d461789f204d19b7181b1a11804a666728";
    sha256 = "0c37prahdv7hsh718278679p27v2grnvgl5cr0nd9cl4ni9rk5kf";
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
