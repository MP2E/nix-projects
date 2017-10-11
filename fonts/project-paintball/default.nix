{ stdenv, fetchurl, unzip }:

let
  version = "Beta_4a";
in stdenv.mkDerivation rec {
  name = "project-paintball-${version}";

  src = fetchurl {
    url = "file:///home/cray/Downloads/Paintball_Beta_4a.zip";
    sha256 = "1nfrq6djvahz2nm2282lmzdyihmrklxzc9bj244zpwfs3pgnaikj";
  };

  buildInputs = [unzip];

  sourceRoot = ".";

  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    unzip ${src} -d $out/share/fonts/opentype/
  '';

  meta = with stdenv.lib; {
    homepage = http://fizzystack.web.fc2.com/paintball.html;
    description = "Faithful Splatoon Font Clone";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [maintainers.MP2E];
  };
}
