{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "oos-randomizer-${version}";

  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "jangler";
    repo = "oos-randomizer";
    rev = "${version}";
    sha256 = "0dfxavclismyx4p2xxfb5i98b3iavbj7xdhvmjfl6wp87xyzv75g";
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
