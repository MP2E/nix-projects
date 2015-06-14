{ stdenv, autoconf, automake, pkgconfig, SDL, SDL_mixer, SDL_net, fetchgit }:

stdenv.mkDerivation rec {
  name = "chocolate-doom-20150608";
  src = fetchgit {
    url = "https://github.com/fragglet/chocolate-doom.git";
    rev = "ef4c73fc8157ee3be6a41bf1f8bdce82657d715b";
    sha256 = "1hlz7z00hnl5azpyg7939dl56fd6sd6jafyi3zh8n5f6ps1jbwrw";
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
