{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "asar-1.50";
  src = fetchFromGitHub {
    owner  = "AndreaOrru";
    repo   = "Asar";
    rev    = "55eac79ef3f1714d26a2d121ed3b7555ad43f877";
    sha256 = "0wcj2wffk97rjl45pwiia3mrxadqlaqqwk9ww96zqa27q9rivr9h";
  };

  buildPhase = ''
    runHook preBuild

    g++ -O2 -Dlinux -DINTERFACE_CLI -Dstricmp=strcasecmp src/*.cpp -o asar

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp asar $out/bin

    runHook postInstall
  '';

  meta = {
    homepage = https://www.smwcentral.net/?p=section&a=details&id=14560;
    description = "Asar is a Super Nintendo assembler, intended to replace xkas v0.06 as the preferred assembler for SNES ROM hacks.";
  };
}

