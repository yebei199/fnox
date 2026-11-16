{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  udev,
}:
let
  release = lib.importJSON ./release.json;
in
stdenv.mkDerivation {
  pname = "fnox";
  inherit (release) version;

  src = fetchurl {
    url = "https://github.com/jdx/fnox/releases/download/v${release.version}/fnox-x86_64-unknown-linux-gnu.tar.gz";
    inherit (release) hash;
  };
  sourceRoot = ".";

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [
    stdenv.cc.cc.lib
    udev
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 fnox $out/bin/fnox
    runHook postInstall
  '';

  # A missing library passes autoPatchelf only when nothing names it; running the binary does not.
  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/fnox --version | grep -F ${release.version}
  '';

  meta = {
    description = "fnox, packaged from the official Linux release";
    homepage = "https://github.com/jdx/fnox";
    changelog = "https://github.com/jdx/fnox/releases/tag/v${release.version}";
    license = lib.licenses.mit;
    mainProgram = "fnox";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
