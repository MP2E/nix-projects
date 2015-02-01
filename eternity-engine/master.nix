{ stdenv, cmake, mesa, SDL, SDL_mixer, SDL_net, fetchgit }:

stdenv.mkDerivation rec {
  name = "eternity-engine-20150131";
  src = fetchgit {
    url = git://github.com/team-eternity/eternity.git;
    rev = "b653b6471f823c56a6f5297a7ce1e7560652deb7";
    sha256 = "15yldd9w4ydl0vwv51lbglxgav2zg6m3l7pnmyl1ppzrijj0injy";
  };

  cmakeFlags = ''
    -DCMAKE_BUILD_TYPE=Release
  '';

  buildInputs = [ cmake mesa SDL SDL_mixer SDL_net ];

  enableParallelBuilding = true;

  installPhase = ''
  mkdir -p $out/bin
  cp source/eternity $out/bin
  '';

  meta = {
    homepage = http://doomworld.com/eternity;
    description = "New school Doom port by James Haley";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ MP2E ];
  };
}
