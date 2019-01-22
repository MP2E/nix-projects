{ stdenv, lib, buildGoPackage }:

buildGoPackage rec {
  name = "oracles-randomizer-${version}";

  version = "3.3.4-dev";

  src = lib.cleanSource /home/cray/oracles-rando-git;

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
