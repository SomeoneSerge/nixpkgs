{ stdenv
, lib
, blender
, makeWrapper
, extraModules ? []
}:
{ name ? "wrapped" }:
stdenv.mkDerivation {
  pname = "blender-${name}";
  inherit (blender) version;
  src = blender;

  nativeBuildInputs = [ blender.python.pkgs.wrapPython makeWrapper ];
  installPhase = ''
    mkdir $out/{share/applications,bin} -p
    sed 's/Exec=blender/Exec=blender-${name}/g' $src/share/applications/blender.desktop > $out/share/applications/blender-${name}.desktop
    cp -r $src/share/blender $out/share
    cp -r $src/share/doc $out/share
    cp -r $src/share/icons $out/share

    buildPythonPath "$pythonPath"

    makeWrapper ${blender}/bin/blender $out/bin/blender-${name} \
      --prefix PATH : $program_PATH \
      --prefix PYTHONPATH : $program_PYTHONPATH
  '';

  pythonPath = extraModules;

  meta = blender.meta;
}
