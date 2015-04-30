{ stdenv, fetchgit, cmake, zlib }:

stdenv.mkDerivation rec {
  name = "zdbsp-1.18.1";
  src = fetchgit {
    url = https://github.com/rheit/zdbsp.git;
    rev = "a5ffff9c46d78d8f2126674ce458f2f478b51528";
    sha256 = "13cxqd0rw12ivilivwwln4ik5nixaf7zllwl34jqxmp8vfzv2m21";
  };

  buildInputs = [ cmake zlib ];

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/bin
    cp zdbsp $out/bin
  '';

  meta = {
    homepage = http://zdoom.org;
    description = "Standalone version of ZDoom's internal node builder";
  };
}

