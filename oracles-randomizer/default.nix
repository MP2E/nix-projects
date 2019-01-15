{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "oracles-randomizer-${version}";

  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "jangler";
    repo = "oracles-randomizer";
    rev = "${version}";
    sha256 = "10xz3x5y9xi1yx2vr71ka99vfa6d2wlhjgp388pkc8yk20prlw5r";
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
