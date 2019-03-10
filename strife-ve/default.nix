{ stdenv, cmake, pkgconfig, SDL, SDL_mixer, SDL_net, ffmpeg_2, zlib, libpng, fetchFromGitHub }:

stdenv.mkDerivation rec {

  name = "strife-ve-1.3";

  src = fetchFromGitHub {
    owner = "svkaiser";
    repo  = "strife-ve";
    rev = "1b7015956edd184fb9f94a912c8eb4c60f2b83f4";
    sha256 = "03xmwnk50z75fj2pfwps29ksl3sxcb589qj4binaa5z052aylq4d";
  };

  patches = [ ./fix_gl_defines.patch ];

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ SDL SDL_mixer SDL_net ffmpeg_2 zlib libpng ];

  configurePhase = ''
    mkdir -p Build
    pushd Build
    cmake ../strife-ve-src -DCMAKE_INSTALL_PREFIX=$out \
                           -DOpenGL_GL_PREFERENCE=GLVND \
                           -DCMAKE_BUILD_TYPE=Release
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp strife-ve $out/bin
  '';

  meta = {
    homepage = http://store.steampowered.com/app/317040/;
    description = "Strife: Veteran Edition";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ MP2E ];
  };
}
