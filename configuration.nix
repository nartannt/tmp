# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{

  programs.bash.shellAliases = {
      vim="nvim";
  };

  nix.extraOptions="experimental-features = nix-command flakes";
  
  # fix the broken thing
  #hardware.opengl.mesaPackage = pkgs.mesa; 
  
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #home-manager/nixos
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-bb52ebe0-a875-4a78-831d-1d2cead2faa6".device = "/dev/disk/by-uuid/bb52ebe0-a875-4a78-831d-1d2cead2faa6";
  boot.initrd.luks.devices."luks-bb52ebe0-a875-4a78-831d-1d2cead2faa6".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "tulkas"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.utf8";
    LC_IDENTIFICATION = "fr_FR.utf8";
    LC_MEASUREMENT = "fr_FR.utf8";
    LC_MONETARY = "fr_FR.utf8";
    LC_NAME = "fr_FR.utf8";
    LC_NUMERIC = "fr_FR.utf8";
    LC_PAPER = "fr_FR.utf8";
    LC_TELEPHONE = "fr_FR.utf8";
    LC_TIME = "fr_FR.utf8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  
  # For docker
  virtualisation.docker.enable = true;
  
# Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "fr";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "fr";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # enable opengl
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

   # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Do not disable this unless your GPU is unsupported or if you have a good reason to.
    open = true;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.nvidia.prime = {
      sync.enable = true;
		# Make sure to use the correct Bus ID values for your system!
		intelBusId = "PCI:0:2:0";
		nvidiaBusId = "PCI:2:0:0";
	};

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
   aurore = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ firefox ];
   };
   nartan = {
    isNormalUser = true;
    description = "nartan";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    packages = with pkgs; [

      # utils
      lshw

      	# programming
 	#Prolog
 		gprolog
 		swiProlog
        # C
        	gcc cmake clang-tools
        # Rust
        	rustup
        # OCaml
        	ocaml
 		opam
        ocamlPackages.lsp
 		ocamlPackages.merlin
         # Python
 	(let
 		my-python-packages = python-packages: with python-packages; [
 			pandas
 			numpy
 			matplotlib
 			z3
 		];
 	python-with-my-packages = python3.withPackages my-python-packages;
 	in
 	python-with-my-packages)
 		python3
       	# general tools
        	gnumake
       	# media
 		fragments
 	# music
 		beets
 		vlc
 		ffmpeg
        picard
	# typesetting
       		typst
       # general utilities
	nodejs
	
	# for gaming purposes
	lutris
	wine
	wine-staging

	alass
	zip
	unzip
       zotero
       xcalib
	wget
       libreoffice
       firefox-wayland
       vim
       neovim
       python311Packages.pynvim
       starship
       zoom-us
       tree
       steam
       flatpak
	rPackages.proton
	ytmdl
	spotdl
        pkgs.gnome.gvfs
	htop
	minecraft
    tagger
    # open source launcher for epic games games
    heroic-unwrapped
    wormhole-rs
    #audacity
    #shotcut
    #kdenlive
    #shotwell
    inkscape
	prismlauncher
    inetutils
       thunderbird
       evolution
       #gromacs
       wl-clipboard
       syncthing
       openvpn
       git
       gitlab-runner
       	# security
         gnupg 
         pass
       
       # communication
       element-desktop
       signal-desktop
       skypeforlinux
 
       # aurore
       ansible
       python310Packages.dnspython
      
       # packages i need but don't really understand 
       #nodejs less than 16 for copilot apparently
       libGL
       bc
       xorg.libX11
       binutils
       findutils
    ];
  };
  };


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # i don't really like this, but don't really know how to do otherwise
  # allows openssl 1.1 as an unsafe package
  nixpkgs.config.permittedInsecurePackages = [
  	"openssl-1.1.1t"
  	"openssl-1.1.1u"
  ];



  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  sfml
  gcc
  pkg-config
  fontconfig 
  neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    #plugins = with pkgs.vimPlugins; [
    #  lazy-lsp-nvim
    #];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
   programs.mtr.enable = true;
   programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };

  # getting steam working
  services.flatpak.enable = true;
  programs.steam = {
	enable = true;
	remotePlay.openFirewall = true;
	dedicatedServer.openFirewall = true;
  };

  # List services that you want to enable:
  
  
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
