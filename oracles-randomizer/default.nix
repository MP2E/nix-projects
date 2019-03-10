{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "oracles-randomizer-${version}";

  version = "3.3.7";

  src = fetchFromGitHub {
    owner = "jangler";
    repo = "oracles-randomizer";
    rev = "${version}";
    sha256 = "1jdpyyfdwv0qbxkqrr2y6qq2iqyjvlhwmzih1nmjmcsrj1gb47pc";
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
