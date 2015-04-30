{ stdenv, fetchgit, cmake, wxGTK30, gtk2, freetype, ftgl, sfml, fluidsynth, libmodplug, freeimage, p7zip, zlib, bzip2, mesa, glew, pkgconfig }:

stdenv.mkDerivation {
  name = "slade-20150424";
  src = fetchgit {
    url = https://github.com/sirjuddington/SLADE;
    rev = "2afd7b3be0a9f18dbaf5b0a28a3f2c704e8ee41f";
    sha256 = "18rpxz5gi5zxfmmw5pgkcvr3ywgha3yykj8z8zsxrianylwdcgsm";
  };

  buildInputs = [ cmake wxGTK30 gtk2 freetype ftgl glew sfml fluidsynth libmodplug freeimage p7zip zlib bzip2 mesa pkgconfig ];

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

