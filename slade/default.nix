{ stdenv, fetchFromGitHub, cmake, wxGTK30, gtk2, freetype, ftgl, sfml, fluidsynth, libmodplug, freeimage, p7zip, zlib, bzip2, mesa, glew, pkgconfig, curl, pcre, libpthreadstubs }:

stdenv.mkDerivation {
  name = "slade-20170425";
  src = fetchFromGitHub {
    owner = "sirjuddington";
    repo = "SLADE";
    rev = "8d4e7f122a8d4f89247508ebf1abbff742a2082a";
    sha256 = "0lflxzkh1dqdiasjpmkw3x7px39ag18szclkri6jp4h8kbxkl449";
  };

  buildInputs = [ cmake wxGTK30 gtk2 freetype ftgl glew sfml fluidsynth libmodplug freeimage p7zip zlib bzip2 mesa pkgconfig curl pcre libpthreadstubs ];

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/bin
    cp slade $out/bin
    cp slade.pk3 $out/bin
  '';


  meta = {
    homepage = http://slade.mancubus.net/;
    description = "A modern editor for Doom-engine based games and source ports.";
  };
}

