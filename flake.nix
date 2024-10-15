{
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		hyprland = {
			url = "github:hyprwm/Hyprland";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		ags = {
			url = "github:aylur/ags/v2";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		zen-browser = {
			url = "github:ch4og/zen-browser-flake";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	}; 
	outputs = { self, nixpkgs, home-manager, ... }@inputs:
		let
			system = "x86_64-linux";
			pkgs = import nixpkgs {
				inherit system;
				overlays = import ./overlays/bundle.nix; 
				config.allowUnfree = true;
			};
		in {
		packages.${system} = pkgs.callPackage ./pkgs/bundle.nix {};
		nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
			inherit system;
			specialArgs = { inherit inputs; inherit system; };
			modules = [
				./nixos/configuration.nix 
				home-manager.nixosModules.home-manager
				{
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						users.zaer1n.imports = [
							./home/home.nix
						];
					};
				}
			];
		};
	};
}
