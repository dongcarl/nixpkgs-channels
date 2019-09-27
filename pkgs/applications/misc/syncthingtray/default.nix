{ mkDerivation
, stdenv
, lib
, fetchFromGitHub
, qtbase
, qtwebengine
, qtdeclarative
, extra-cmake-modules
, cpp-utilities
, qtutilities
, cmake
, kio
, plasma-framework
, qttools
, webviewSupport ? true
, jsSupport ? true
, kioPluginSupport ? true
, plasmoidSupport  ? true
, systemdSupport ? true
}:

mkDerivation rec {
  version = "0.10.0";
  pname = "syncthingtray";

  src = fetchFromGitHub {
    owner = "Martchus";
    repo = "syncthingtray";
    rev = "v${version}";
    sha256 = "18h6z6baaiyr0wr7kyz6ysg45zb12550m63j3vqiap4hfrrwhly5";
  };

  buildInputs = [ qtbase cpp-utilities qtutilities ]
    ++ lib.optionals webviewSupport [ qtwebengine ]
    ++ lib.optionals jsSupport [ qtdeclarative ]
    ++ lib.optionals kioPluginSupport [ kio ]
    ++ lib.optionals plasmoidSupport [ extra-cmake-modules plasma-framework ]
  ;

  nativeBuildInputs = [ cmake qttools ];

  cmakeFlags = [
    # See https://github.com/Martchus/syncthingtray/issues/42
    "-DQT_PLUGIN_DIR:STRING=${placeholder "out"}/lib/qt-5"
  ] ++ lib.optionals (!plasmoidSupport) ["-DNO_PLASMOID=ON"]
    ++ lib.optionals (!kioPluginSupport) ["-DNO_FILE_ITEM_ACTION_PLUGIN=ON"]
    ++ lib.optionals systemdSupport ["-DSYSTEMD_SUPPORT=ON"]
  ;

  meta = with lib; {
    homepage = "https://github.com/Martchus/syncthingtray";
    description = "Tray application and Dolphin/Plasma integration for Syncthing";
    license = licenses.gpl2;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.linux;
  };
}