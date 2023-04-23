{
  description = "Fantasy computer.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = {self, nixpkgs}: {
    defaultPackage.x86_64-linux =
      with import nixpkgs { system = "x86_64-linux"; };
			stdenv.mkDerivation rec { 
      
				name = "tic-80";
				version = "1.0.2164";

				pro = true;
				withGUI = true;

				src = pkgs.fetchFromGitHub {
					owner = "nesbox";
					repo = "TIC-80";
					rev = "v${version}";
					sha256 = "sha256-SnaAhdYoblxKlzTSyfcnvY6u7X6aIJIYWZAXtL2IIXc=";
					fetchSubmodules = true;
				};

			  postPatch = ''
			    # Cannot use Git to determine version details
			    # Avoid building a custom SDL2
			    substituteInPlace CMakeLists.txt \
			      --replace 'set(VERSION_MAJOR ' 'set(VERSION_MAJOR ${lib.versions.major version})#' \
			      --replace 'set(VERSION_MINOR ' 'set(VERSION_MINOR ${lib.versions.minor version})#' \
			      --replace 'set(VERSION_REVISION ' 'set(VERSION_REVISION ${lib.versions.patch version})#' \
			      --replace 'add_subdirectory(''${THIRDPARTY_DIR}/sdl2)' 'find_package(SDL2 REQUIRED)' \
			      --replace "\''${THIRDPARTY_DIR}/sdl2/include" "\''${SDL2_INCLUDE_DIRS}" \
			      --replace 'SDL2main' "\''${SDL2_LIBRARIES}" \
			      --replace 'SDL2-static' "\''${SDL2_LIBRARIES}"
			  '';

			  nativeBuildInputs = [
			    cmake
			  ];

			  buildInputs = lib.optionals withGUI [
			    SDL2
			    libGLU
			  ];

			  cmakeFlags = [
			    "-DVERSION_HASH=Nixpkgs"
			    "-DBUILD_SDL=${lib.boolToString withGUI}"
			    "-DBUILD_SDLGPU=${lib.boolToString withGUI}"
			    "-DBUILD_SOKOL=OFF"
			    "-DBUILD_LIBRETRO=OFF"
			    "-DBUILD_PRO=${lib.boolToString pro}"
			    "-DBUILD_WITH_MRUBY=OFF"
			  ];
			};
				# installPhase = ''
				# 	mkdir -p $out/{bin,share}/
				# 	mkdir $out/share/pixmaps
				# 	install -m755 tic80 $out/share
				# 	echo "cd $out/share/ && ${pkgs.steam-run}/bin/steam-run ./tic80 \$*" > $out/bin/tic80
				# 	chmod 755 $out/bin/tic80

			 #    cp ${./tic80.png} $out/share/pixmaps/tic80.png
				# '';

			 #  desktopItems = [
			 #    (makeDesktopItem {
			 #      name = "TIC-80";
			 #      icon = "tic80";
			 #      exec = "tic80";
			 #      genericName = "TIC-80";
			 #      desktopName = "TIC-80";
			 #      categories = [ "Game" ];
			 #    })
			 #  ];
  };
}