{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "oos-randomizer-${version}";

  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "jangler";
    repo = "oos-randomizer";
    rev = "${version}";
    sha256 = "18ckqwpiq62b2qw299450i6xpqwiqdwzb82kxds4ik1qijjzqkkk";
  };

  goPackagePath = "github.com/jangler/oos-randomizer";

  meta = with stdenv.lib; {
    homepage = https://github.com/jangler/oos-randomizer;
    description = "Item location randomizer for the Game Boy Color classic, The Legend of Zelda: Oracle of Seasons";
    maintainers = with maintainers; [ MP2E ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
