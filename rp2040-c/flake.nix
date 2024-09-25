{
  inputs = {
    utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, utils }: utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      pico-sdk-tusb = with pkgs; pico-sdk.overrideAttrs(oldAttrs:
        rec {
          pname = "pico-sdk";
          version = "2.0.0";
          src = fetchFromGitHub {
            fetchSubmodules = true;
            owner = "raspberrypi";
            repo = pname;
            rev = version;
            sha256 = "sha256-fVSpBVmjeP5pwkSPhhSCfBaEr/FEtA82mQOe/cHFh0A=";
          };
      });
      pico-extras = with pkgs; stdenv.mkDerivation rec {
        pname = "pico-extras";
        version = "sdk-2.0.0";

        src = fetchFromGitHub {
          owner = "raspberrypi";
          repo = pname;
          rev = version;
          sha256 = "sha256-UXKFqo56Vr9MvdZkE9J0/gFvO3uwIhg1fIh3Yg5OWpY=";
        };

        # SDK contains libraries and build-system to develop projects for RP2040 chip
        # We only need to compile pioasm binary
        sourceRoot = "";

        installPhase = ''
          runHook preInstall
          mkdir -p $out/lib/pico-extras
          cp -a ./* $out/lib/pico-extras/
          runHook postInstall
        '';
      };
    in
    {
      devShell = pkgs.mkShell {
        packages = with pkgs; [
          # LSP
          cmake-language-server

          # Build support
          just

          # Uploading
          picotool

          # Debugging
          usbutils
          minicom
          openocd-rp2040
          gef
        ];
        nativeBuildInputs = with pkgs; [ pico-sdk-tusb pico-extras cmake gcc-arm-embedded git ];

        shellHook = ''
        export PICO_SDK_PATH=${pico-sdk-tusb.out}/lib/pico-sdk/
        export PICO_EXTRAS_PATH=${pico-extras.out}/lib/pico-extras/
        '';
      };
    }
  );
}
