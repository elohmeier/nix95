{ lib, pkgs, ... }:
{

  services.libinput = {
    enable = lib.mkDefault true;
    touchpad.naturalScrolling = true;
    mouse.naturalScrolling = true;
  };

  services.displayManager.defaultSession = "xfce";

  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
    displayManager.lightdm = {
      background = "#008080";
      greeters.gtk = {
        cursorTheme = {
          package = pkgs.chicago95;
          name = "Chicago95_Animated_Hourglass_Cursors";
        };
        iconTheme = {
          package = pkgs.chicago95;
          name = "Chicago95";
        };
        theme = {
          package = pkgs.chicago95;
          name = "Chicago95";
        };
        extraConfig = ''
          font-name=Helvetica 8
        '';
      };
    };

    xkb = {
      layout = lib.mkDefault "us";
      options = lib.mkDefault "eurosign:e,terminate:ctrl_alt_bksp,compose:ralt";
    };
  };

  programs.thunar = {
    enable = lib.mkDefault true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-media-tags-plugin
      thunar-volman
    ];
  };

  boot.plymouth = {
    enable = lib.mkDefault true;
    logo = ../../assets/Microsoft_Windows_95_wordmark.png;
  };

  environment.systemPackages = with pkgs; [
    chicago95
    libinput
    pavucontrol
    xarchiver
    xclip
    xfce.xfce4-fsguard-plugin
    xfce.xfce4-pulseaudio-plugin
    xsel
  ];

  fonts.packages = [ pkgs.chicago95 ];
}
