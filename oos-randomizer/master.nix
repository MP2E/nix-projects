{ stdenv, lib, buildGoPackage }:

buildGoPackage rec {
  name = "oos-randomizer-${version}";

  version = "2.1.1-dev";

  src = lib.cleanSource /home/cray/oos-rando-git;

  goPackagePath = "github.com/jangler/oos-randomizer";

  meta = with stdenv.lib; {
    homepage = https://github.com/jangler/oos-randomizer;
    description = "Item location randomizer for the Game Boy Color classic, The Legend of Zelda: Oracle of Seasons";
    maintainers = with maintainers; [ MP2E ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
