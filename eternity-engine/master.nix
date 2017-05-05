{ stdenv, cmake, mesa, SDL, SDL_mixer, SDL_net, fetchFromGitHub, makeWrapper }:

stdenv.mkDerivation rec {
  name = "eternity-engine-20170408";
  src = ~/eternitygit;

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
