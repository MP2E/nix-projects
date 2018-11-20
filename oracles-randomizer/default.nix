{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "oracles-randomizer-${version}";

  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "jangler";
    repo = "oracles-randomizer";
#   rev = "${version}";
    rev = "4c1d534963b3a9eb0e07310035118b508190adfe";
    sha256 = "0hxcfd28npjs923bhqk8a7y29kli1y6fv7cj99k6rd02js7jlppc";
  };

  goPackagePath = "github.com/jangler/oos-randomizer";
  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://github.com/jangler/oracles-randomizer;
    description = "Item location randomizer for the Legend of Zelda Oracle games for Game Boy Color";
    maintainers = with maintainers; [ MP2E ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
