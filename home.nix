{ config, pkgs, ... }:

{
  home.stateVersion = "24.05"; # adjust to your NixOS version

  programs.i3status.enable = true;

  xsession.windowManager.i3 = {
    enable = true;

    config = {
      modifier = "Mod4";
      terminal = "alacritty";

      keybindings = {
        "Mod4+Return" = "exec alacritty";
        "Mod4+d" = "exec dmenu_run";
      };

      startup = [
        { command = "picom"; }
      ];
    };
  };

  home.packages = with pkgs; [
    alacritty
    dmenu
    picom
  ];
}
