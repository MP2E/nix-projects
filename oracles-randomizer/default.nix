{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "oracles-randomizer-${version}";

  version = "3.3.2";

  src = fetchFromGitHub {
    owner = "jangler";
    repo = "oracles-randomizer";
    rev = "${version}";
    sha256 = "1chimh58vp6ydfl17krg5iy123fsd3npcymbd1ylp22lzjmxh0mw";
  };

  goPackagePath = "github.com/jangler/oracles-randomizer";
  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://github.com/jangler/oracles-randomizer;
    description = "Item location randomizer for the Legend of Zelda Oracle games for Game Boy Color";
    maintainers = with maintainers; [ MP2E ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
