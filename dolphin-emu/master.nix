{ stdenv, pkgconfig, cmake, bluez, ffmpeg, libao, mesa, gtk2, glib
, gettext, git, libpthreadstubs, libXrandr, libXext, readline
, openal, libXdmcp, portaudio, SDL, wxGTK30, fetchgit
, pulseaudio ? null }:

stdenv.mkDerivation rec {
  name = "dolphin-emu-20141023";
  src = fetchgit {
    url = git://github.com/dolphin-emu/dolphin.git;
    rev = "a9f0bd72d21bba5c488f73e44426eedaac190023";
    sha256 = "0lgwls4pfip06cjnrjphxjnl96sidkwqdbzr0cn9x9x6hkca1g8p";
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
