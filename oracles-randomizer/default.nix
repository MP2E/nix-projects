{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "oracles-randomizer-${version}";

  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "jangler";
    repo = "oracles-randomizer";
    rev = "${version}";
    sha256 = "sha256:0lkxk43sjyiw5ynlrjgxqsb6bifqz4cq91b463xi791kf5v64cih";
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
