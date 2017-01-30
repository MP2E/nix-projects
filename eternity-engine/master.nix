{ stdenv, cmake, mesa, SDL, SDL_mixer, SDL_net, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "eternity-engine-20170127";
  src = fetchFromGitHub {
    owner = "team-eternity";
    repo = "eternity";
    rev = "65981e70d87390e439d1682b6a63b27042aaa51a";
    sha256 = "1rvjrmli020bsvbs77bc0jwjc14x6nbdzdjm6jml0c8ja19l00i7";
  };

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
