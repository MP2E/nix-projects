{ stdenv, cmake, mesa, SDL, SDL_mixer, SDL_net, fetchFromGitHub, makeWrapper }:

stdenv.mkDerivation rec {
  name = "eternity-engine-20170130";
  src = fetchFromGitHub {
    owner = "team-eternity";
    repo = "eternity";
    rev = "c5bbb77db8fc63494cf054c59eff61bde971b41a";
    sha256 = "a0d1c4cd0d24eecc8071a9589d1983bc54fc3b404e379bc6dc4818a37c941fbc";
  };

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = [ mesa SDL SDL_mixer SDL_net ];

  enableParallelBuilding = true;

  installPhase = ''
  mkdir -p $out/bin $out/lib
  cp source/eternity $out/lib
  cp -r base/ $out/lib
  makeWrapper $out/lib/eternity $out/bin/eternity
  '';

  meta = {
    homepage = http://doomworld.com/eternity;
    description = "New school Doom port by James Haley";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ MP2E ];
  };
}
