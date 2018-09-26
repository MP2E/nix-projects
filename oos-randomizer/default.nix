{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "oos-randomizer-${version}";

  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "jangler";
    repo = "oos-randomizer";
    rev = "${version}";
    sha256 = "1i1cyw2ffgbqax12l3k2dmgiw8r3ar19rc915gz3chy0sya12hrv";
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
