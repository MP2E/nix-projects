{ stdenv, fetchFromGitHub, cmake, wxGTK30, webkitgtk, gtk3, freetype, ftgl, sfml, fluidsynth, libmodplug, freeimage, p7zip, zlib, bzip2, mesa, glew, curl, pcre, libpthreadstubs }:

stdenv.mkDerivation rec {
  name = "slade-${version}";
  version = "3.1.4";
  src = fetchFromGitHub {
    owner = "sirjuddington";
    repo = "SLADE";
    rev = "${version}";
    sha256 = "0icz6mv3k0dfl1bxabv1ffjjfzaarjl03z3bn6gh5a555qapxyi0";
  };

  nativeBuildDepends = [ cmake p7zip curl ];

  buildInputs = [ wxGTK30 webkitgtk gtk3 freetype ftgl glew sfml fluidsynth libmodplug freeimage zlib bzip2 mesa pcre libpthreadstubs ];

  enableParallelBuilding = true;

  cmakeFlags = [ "-DWITH_WXPATH=${wxGTK30}/bin" ];

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

