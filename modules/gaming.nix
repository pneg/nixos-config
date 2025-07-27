{ config, pkgs, inputs, ... }:

{

  programs.steam.enable = true;
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  environment.systemPackages = with pkgs; [
    mangohud
    steam-tui
    heroic
    fluidsynth
    (pkgs.stdenv.mkDerivation rec {
      pname = "protonhax";
      version = "1.0.5";

      src = fetchFromGitHub {
        owner = "jcnils";
        repo = pname;
        rev = version;
        sha256 = "sha256-5G4MCWuaF/adSc9kpW/4oDWFFRpviTKMXYAuT2sFf9w=";
      };

      installPhase = ''
        mkdir -p $out/bin
        cp protonhax $out/bin
      '';

      postFixup = ''
        sed -i '1s/#!/#!${
          pkgs.lib.escape ["/"] (pkgs.lib.getExe steam-run)
        } /' $out/bin/protonhax
      '';

    })
  ];

}
