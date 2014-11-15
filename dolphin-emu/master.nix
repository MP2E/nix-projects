{ stdenv, pkgconfig, cmake, bluez, ffmpeg, libao, mesa, gtk2, glib
, gettext, git, libpthreadstubs, libXrandr, libXext, readline
, openal, libXdmcp, portaudio, SDL, wxGTK30, fetchgit
, pulseaudio ? null }:

stdenv.mkDerivation rec {
  name = "dolphin-emu-20141113";
  src = fetchgit {
    url = git://github.com/dolphin-emu/dolphin.git;
    rev = "e7899203400b6add851425194ff0ce38c8050f36";
    sha256 = "0g56z6kcs8zy5qlq51x8k1pw45k8z3kg9zyl63l4jlj27306n89h";
    fetchSubmodules = false;
  };

  cmakeFlags = ''
    -DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib}/lib/glib-2.0/include
    -DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2}/lib/gtk-2.0/include
    -DGTK2_INCLUDE_DIRS=${gtk2}/include/gtk-2.0
    -DCMAKE_BUILD_TYPE=Release
    -DENABLE_LTO=True
  '';

  enableParallelBuilding = true;

  buildInputs = [ pkgconfig cmake bluez ffmpeg libao mesa gtk2 glib
                  gettext libpthreadstubs libXrandr libXext readline openal
                  git libXdmcp portaudio SDL wxGTK30 pulseaudio ];

  patches = [ ./rogue-leader-fix.patch ];

  meta = {
    homepage = http://dolphin-emu.org/;
    description = "Gamecube/Wii/Triforce emulator for x86_64 and ARM";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ MP2E ];
  };
}
