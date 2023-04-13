{
	# thanks https://blog.sekun.net/posts/packaging-prebuilt-binaries-with-nix/

  description = "Fantasy computer";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = {self, nixpkgs}: {
    defaultPackage.x86_64-linux =
      with import nixpkgs { system = "x86_64-linux"; };
 stdenv.mkDerivation rec { name = "tic80-${version}";

        version = "1.0.2164";

				src = pkgs.fetchurl {
				  # Remember `rec`!
				  url = "https://github.com/nesbox/TIC-80/releases/download/v${version}/tic80-v1.0-linux.zip";
				  sha256 = "sha256-xeaqapjX3E/7hL8k/Wid/Rj9HIG2BWyt7GWPnlGTwPQ=";
				};

				sourceRoot = ".";

				nativeBuildInputs = [
					unzip
					autoPatchelfHook
				];

				buildInputs = [
					gcc
					libgcc
					libgccjit
				];

				installPhase = ''
					mkdir -p $out/{bin,share}/
					mkdir $out/share/pixmaps
					install -m755 tic80 $out/share
					echo "cd $out/share/ && steam-run ./tic80" > $out/bin/tic80
					chmod 755 $out/bin/tic80

			    cp ${./tic80.png} $out/share/pixmaps/tic80.png
				'';

			  desktopItems = [
			    (makeDesktopItem {
			      name = "TIC-80";
			      icon = "tic80";
			      exec = "tic80";
			      genericName = "TIC-80";
			      desktopName = "TIC-80";
			      categories = [ "Game" ];
			    })
			  ];

      };
  };
}