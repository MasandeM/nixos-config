{ config, pkgs, ... }:
{
  home.stateVersion = "24.05";
  programs.i3status = {
    enable = true;
    general = {
      colors = true;
      color_good = "#A3BE8C";
      color_degraded = "#EBCB8B";
      color_bad = "#BF616A";
    };
  };

  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "alacritty";
      focus.followMouse = false;
      focus.mouseWarping = false;

      fonts = {
        names = [ "JetBrainsMono Nerd Font" ];
        size = 10.0;
      };

      gaps = {
        inner = 8;
        outer = 4;
      };

      window = {
        border = 2;
        titlebar = false;
      };

      colors = {
        focused = {
          border = "#81A1C1";
          background = "#81A1C1";
          text = "#2E3440";
          indicator = "#88C0D0";
          childBorder = "#81A1C1";
        };
        unfocused = {
          border = "#3B4252";
          background = "#3B4252";
          text = "#D8DEE9";
          indicator = "#3B4252";
          childBorder = "#3B4252";
        };
        focusedInactive = {
          border = "#434C5E";
          background = "#434C5E";
          text = "#D8DEE9";
          indicator = "#434C5E";
          childBorder = "#434C5E";
        };
        urgent = {
          border = "#BF616A";
          background = "#BF616A";
          text = "#2E3440";
          indicator = "#BF616A";
          childBorder = "#BF616A";
        };
      };

      bars = [{
        position = "bottom";
        statusCommand = "${pkgs.i3status}/bin/i3status";
        fonts = {
          names = [ "JetBrainsMono Nerd Font" ];
          size = 10.0;
        };
        colors = {
          background = "#2E3440";
          statusline = "#D8DEE9";
          separator = "#4C566A";
          focusedWorkspace = {
            border = "#81A1C1";
            background = "#81A1C1";
            text = "#2E3440";
          };
          activeWorkspace = {
            border = "#434C5E";
            background = "#434C5E";
            text = "#D8DEE9";
          };
          inactiveWorkspace = {
            border = "#3B4252";
            background = "#3B4252";
            text = "#D8DEE9";
          };
          urgentWorkspace = {
            border = "#BF616A";
            background = "#BF616A";
            text = "#2E3440";
          };
        };
      }];

      keybindings = let
        mod = "Mod4";
      in {
        # Terminal and launcher
        "${mod}+Return" = "exec alacritty";
        "${mod}+d" = "exec dmenu_run";
        
        # Focus windows (vim keys)
        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";
        
        # Focus windows (arrow keys)
        "${mod}+Left" = "focus left";
        "${mod}+Down" = "focus down";
        "${mod}+Up" = "focus up";
        "${mod}+Right" = "focus right";
        
        # Move windows (vim keys)
        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";
        
        # Move windows (arrow keys)
        "${mod}+Shift+Left" = "move left";
        "${mod}+Shift+Down" = "move down";
        "${mod}+Shift+Up" = "move up";
        "${mod}+Shift+Right" = "move right";
        
        # Split orientation
        "${mod}+b" = "split h";
        "${mod}+v" = "split v";
        "${mod}+f" = "fullscreen toggle";
        
        # Layout modes
        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggle split";
        
        # Floating
        "${mod}+Shift+space" = "floating toggle";
        "${mod}+space" = "focus mode_toggle";
        
        # Focus parent/child
        "${mod}+a" = "focus parent";
        
        # Workspaces
        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";
        "${mod}+0" = "workspace number 10";
        
        # Move to workspace
        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9";
        "${mod}+Shift+0" = "move container to workspace number 10";
        
        # Window control
        "${mod}+Shift+q" = "kill";
        
        # i3 control
        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+r" = "restart";
        "${mod}+Shift+e" = "exec i3-msg exit";
        
        # Resize mode
        "${mod}+r" = "mode resize";
      };
      
      modes = {
        resize = {
          "h" = "resize shrink width 10 px or 10 ppt";
          "j" = "resize grow height 10 px or 10 ppt";
          "k" = "resize shrink height 10 px or 10 ppt";
          "l" = "resize grow width 10 px or 10 ppt";
          
          "Left" = "resize shrink width 10 px or 10 ppt";
          "Down" = "resize grow height 10 px or 10 ppt";
          "Up" = "resize shrink height 10 px or 10 ppt";
          "Right" = "resize grow width 10 px or 10 ppt";
          
          "Return" = "mode default";
          "Escape" = "mode default";
        };
      };
      
      startup = [
        { command = "picom"; }
	{ command = "i3-msg workspace number 1"; }
        {
          command = "spice-vdagent";
          always = true;
          notification = false;
        }
      ];
    };
  };

  # Alacritty with Nord theme
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal.family = "JetBrainsMono Nerd Font";
        size = 12;
      };
      window = {
        opacity = 0.92;
        padding = { x = 8; y = 8; };
      };
      colors = {
        primary = {
          background = "#2E3440";
          foreground = "#D8DEE9";
        };
        normal = {
          black = "#3B4252";
          red = "#BF616A";
          green = "#A3BE8C";
          yellow = "#EBCB8B";
          blue = "#81A1C1";
          magenta = "#B48EAD";
          cyan = "#88C0D0";
          white = "#E5E9F0";
        };
        bright = {
          black = "#4C566A";
          red = "#BF616A";
          green = "#A3BE8C";
          yellow = "#EBCB8B";
          blue = "#81A1C1";
          magenta = "#B48EAD";
          cyan = "#8FBCBB";
          white = "#ECEFF4";
        };
      };
    };
  };

  home.packages = with pkgs; [
    dmenu
    picom
  ];

  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      pull.rebase = true;
      user = {
        name = "Masande";
        email = "masande.mti@gmail.com";
      };
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };
  
  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ 
        "git"
        "sudo"
        "docker"
        "kubectl"
      ];
    };

  };

}

