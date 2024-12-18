{ pkgs, inputs, system, user, ... }: {
	programs.home-manager.enable = true;
	home = {
		username = user;
		homeDirectory = /home/${user};
		packages = [
			pkgs.nautilus
			pkgs.gthumb
			pkgs.baobab
			pkgs.dialect
			pkgs.overskride
			pkgs.pwvucontrol
			pkgs.hyprshot
			pkgs.vesktop
			pkgs.nixd
			pkgs.adwaita-icon-theme
			pkgs.obsidian
			pkgs.taterclient-ddnet
			pkgs.devenv
			pkgs.protonvpn-gui
    	pkgs.bottles
    	pkgs.adwsteamgtk
    	pkgs.pulseaudio
    	pkgs.tty-clock
			pkgs.linux-wallpaperengine
			inputs.self.packages.${system}.audiorelay
			inputs.zen-browser.packages.${system}.specific
		];
		stateVersion = "24.05";
	};

	programs.fastfetch.enable = true;
  programs.cava.enable = true;
  programs.btop.enable = true;
  services.network-manager-applet.enable = true;
	programs.rofi.enable = true;
}
