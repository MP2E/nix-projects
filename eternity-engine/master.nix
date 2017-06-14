{ stdenv, cmake, mesa_noglu, SDL, SDL_mixer, SDL_net, makeWrapper }:

stdenv.mkDerivation rec {
  name = "eternity-engine-${version}";
  version = "20170613";
  src = ~/eternitygit;

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = [ mesa_noglu SDL SDL_mixer SDL_net ];

  enableParallelBuilding = true;

  installPhase = ''
    install -Dm755 source/eternity $out/lib/eternity/eternity
    cp -r $src/base $out/lib/eternity/base
    mkdir $out/bin
    makeWrapper $out/lib/eternity/eternity $out/bin/eternity
  '';

  meta = {
    homepage = http://doomworld.com/eternity;
    description = "New school Doom port by James Haley";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ MP2E ];
  };
}
