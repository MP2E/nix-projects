{ stdenv, fetchgit, cmake, wxGTK30, gtk2, freetype, ftgl, sfml, fluidsynth, libmodplug, freeimage, p7zip, zlib, bzip2, mesa, glew, pkgconfig }:

stdenv.mkDerivation {
  name = "slade-20150527";
  src = fetchgit {
    url = https://github.com/sirjuddington/SLADE;
    rev = "78ab9df4cb2449798ae605cd073c7a11a131f402";
    sha256 = "18nnmb1y3dkhhapizywrmrkyzzv88cjg1j6f1avwflwhgcfbcwid";
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

