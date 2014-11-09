{ stdenv, autoconf, automake, pkgconfig, SDL, SDL_mixer, SDL_net, fetchgit }:

stdenv.mkDerivation rec {
  name = "chocolate-doom-20141030";
  src = fetchgit {
    url = "https://github.com/fragglet/chocolate-doom.git";
    rev = "563d83b675bf201bf1df5e626b81f9ddb568c8b7";
    sha256 = "0rl0iij9zygz32lbcp3ar16cn82vcsf92lhi4wln13f3cnfvny5n";
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
