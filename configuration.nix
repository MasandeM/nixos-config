# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, callPackage, lib, ... }:
let 
   home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz;
   nixvim = import (builtins.fetchGit {
     url = "https://github.com/nix-community/nixvim";
     ref = "nixos-25.11";
   });
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
      nixvim.nixosModules.nixvim 
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # experimental features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true;
  
  programs.zsh.enable = true;
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  
  # Disable firewall
  networking.firewall.enable = false;
  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };


  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.masande = {
    isNormalUser = true;
    description = "Masande";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    shell = pkgs.zsh;
    packages = with pkgs; [];
  };
  
  # Enable spice guest agent and better integration with host.
  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Use x11 and i3 with LightDM display manager
  services.xserver = {
    enable = true;
    displayManager.lightdm = {
      enable = true;
      greeters.gtk = {
        enable = true;
        theme.name = "Nordic";
        theme.package = pkgs.nordic;
        iconTheme.name = "Nordzy";
        iconTheme.package = pkgs.nordzy-icon-theme;
      };
    };
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
      ];
    };
  };
 
  environment.variables = {
    LIBGL_ALWAYS_SOFTWARE = "1";
  };

  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
    mouse.naturalScrolling = true;
  };


  # mount shared folder for UTM hypervisor
  fileSystems."/mnt/share" = {
    device = "share";
    fsType = "9p";
    options = [
      "trans=virtio"
      "version=9p2000.L"
      "access=any"
      "nofail"
    ];
  };

  systemd.tmpfiles.rules = [
    "d /mnt/share 0755 masande users -"
  ];
  # setup home manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.masande = import /home/masande/.nixos-config/home.nix;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
     git
     xclip
     spice-vdagent
     docker-compose
     openssl
     firefox
     claude-code
     ripgrep
     gcc
     nordic
     nordzy-icon-theme
  ];


  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    
    colorschemes.nord.enable = true;

    globals.mapleader = " ";

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
    };

    plugins.telescope = {
      enable = true;
      keymaps = {
        "<leader>ff" = {
          action = "find_files";
          options.desc = "Find files";
        };
        "<leader>fg" = {
          action = "live_grep";
          options.desc = "Live grep";
        };
        "<leader>fb" = {
          action = "buffers";
          options.desc = "Buffers";
        };
      };
    };

    plugins.web-devicons.enable = true;
    plugins.treesitter = {
      enable = true;
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        python
        nix
        lua
        bash
        json
      ];
      settings = {
        highlight.enable = true;
      };
    };

    plugins.lsp = {
      enable = true;
      keymaps = {
        lspBuf = {
          K = "hover";
          "<leader>rn" = "rename";
          "<leader>ca" = "code_action";
        };
      };
      servers.basedpyright = {
        enable = true;
      };
    }; 
    # progress/spinner indicators
    plugins.fidget = {
      enable = true;
    };

    keymaps = [
      {
        key = "gr";
        action = "<cmd>Telescope lsp_references<CR>";
        options.desc = "Go to references";
      }
      {
        key = "gd";
        action = "<cmd>Telescope lsp_definitions<CR>";
        options.desc = "Go to definition";
      }
      {
	key = "<leader>td";
	action = "<cmd>lua vim.diagnostic.enable(not vim.diagnostic.is_enabled())<CR>";
	options.desc = "Toggle diagnostics";
      }
      { key = "grr"; action = "<Nop>"; }
      { key = "gra"; action = "<Nop>"; }
      { key = "grn"; action = "<Nop>"; }
      { key = "grt"; action = "<Nop>"; }
      { key = "gri"; action = "<Nop>"; }
    ];

    extraConfigLua = ''
      -- Boost Nord contrast
      vim.api.nvim_set_hl(0, "Normal", { fg = "#ECEFF4", bg = "#242933" })
      vim.api.nvim_set_hl(0, "Comment", { fg = "#7B88A1", italic = true })
      vim.api.nvim_set_hl(0, "@keyword.import", { fg = "#81A1C1", bold = true })
      vim.api.nvim_set_hl(0, "@module", { fg = "#88C0D0" })
      vim.api.nvim_set_hl(0, "@function.builtin", { fg = "#88C0D0" })
      vim.api.nvim_set_hl(0, "@string", { fg = "#A3BE8C" })
      vim.api.nvim_set_hl(0, "@type", { fg = "#8FBCBB" })
      vim.api.nvim_set_hl(0, "@variable", { fg = "#ECEFF4" })
      vim.api.nvim_set_hl(0, "@punctuation", { fg = "#D8DEE9" })

      vim.keymap.del("n", "grr")
      vim.keymap.del("n", "gra")
      vim.keymap.del("n", "grn")
      vim.keymap.del("n", "grt")
      vim.keymap.del("n", "gri")
      vim.keymap.del("v", "gra")
    '';

  }; 

  virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}

