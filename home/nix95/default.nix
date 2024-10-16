{ lib, pkgs, ... }: {
  home.packages = with pkgs; [ spleen xarchiver ];

  xfconf.settings = {
    xsettings = {
      "Gtk/CursorThemeName" = "Chicago95_Animated_Hourglass_Cursors";
      "Gtk/FontName" = "Helvetica 8";
      # "Gtk/FontName" = "MS Sans Serif 8";
      "Gtk/MonospaceFontName" = "Spleen 8x16 Medium 12";
      "Net/IconThemeName" = "Chicago95";
      "Net/SoundThemeName" = "Chicago95";
      "Net/ThemeName" = "Chicago95";
      "Xft/Antialias" = 1;
      "Xft/DPI" = -1;
      "Xft/HintStyle" = "hintslight";
      "Xft/Hinting" = 1;
      "Xft/RGBA" = "none";
    };

    xfwm4 = {
      "general/show_dock_shadow" = false;
      "general/show_frame_shadow" = false;
      "general/theme" = "Chicago95";
      "general/title_font" = "Helvetica Bold 8";
    };

    thunar = {
      "default-view" = "ThunarDetailsView";
      "last-details-view-zoom-level" = "THUNAR_ZOOM_LEVEL_25_PERCENT";
    };

    xfce4-panel = {
      "panels/panel-1/icon-size" = 16;
      "panels/panel-1/plugin-ids" =
        [ 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 ];
      "panels/panel-1/position" = "p=8;x=0;y=0";
      "panels/panel-1/position-locked" = true;
      "panels/panel-1/size" = 26;

      "plugins/plugin-95" = "applicationsmenu";
      "plugins/plugin-95/button-title" = "Start";

      "plugins/plugin-96" = "separator";
      "plugins/plugin-96/style" = 2;

      "plugins/plugin-97" = "showdesktop";

      "plugins/plugin-98" = "launcher";
      "plugins/plugin-98/items" = [ "firefox.desktop" ];

      "plugins/plugin-99" = "launcher";
      "plugins/plugin-99/items" = [ "thunar.desktop" ];

      "plugins/plugin-100" = "launcher";
      "plugins/plugin-100/items" = [ "xfce4-terminal.desktop" ];

      "plugins/plugin-101" = "separator";
      "plugins/plugin-101/style" = 2;

      "plugins/plugin-102" = "tasklist";
      "plugins/plugin-102/show-handle" = false;
      "plugins/plugin-102/show-labels" = true;
      "plugins/plugin-102/grouping" = false;
      "plugins/plugin-102/sort-order" = 4;

      "plugins/plugin-103" = "separator";
      "plugins/plugin-103/style" = 0;
      "plugins/plugin-103/expand" = true;

      "plugins/plugin-104" = "separator";
      "plugins/plugin-104/style" = 2;

      "plugins/plugin-105" = "systray";

      "plugins/plugin-106" = "pulseaudio";

      "plugins/plugin-107" = "power-manager-plugin";

      "plugins/plugin-108" = "notification-plugin";

      "plugins/plugin-109" = "clock";
      "plugins/plugin-109/digital-date-font" = "Helvetica 8";
      "plugins/plugin-109/digital-time-font" = "Helvetica 8";
    };

    xfce4-desktop = {
      "backdrop/screen0/monitor0/workspace0/rgba1" =
        [ 0.0 0.501961 0.501961 1.0 ];
      "backdrop/screen0/monitor0/workspace0/last-image" =
        "${../../assets/win95wp.png}";
    };
  };

  xdg.configFile."autostart/Chicago95 Login Sound.desktop".text =
    lib.generators.toINI { } {
      "Desktop Entry" = {
        Encoding = "UTF-8";
        Version = "0.9.4";
        Type = "Application";
        Name = "Chicago95 Login Sound";
        Comment = "Plays the Windows 95 startup sound";
        Exec =
          "${pkgs.libcanberra-gtk3}/bin/canberra-gtk-play -i desktop-login";
        RunHook = "0";
        StartupNotify = "false";
        Terminal = "false";
        Hidden = "false";
      };
    };

  home.activation.xfconfWallpaper =
    lib.hm.dag.entryAfter [ "installPackages" ] ''
      ${pkgs.xfce.xfconf}/bin/xfconf-query -c xfce4-desktop -l | grep last-image | while read path; do
        ${pkgs.xfce.xfconf}/bin/xfconf-query -c xfce4-desktop -p $path -s "${
          ../../assets/win95wp.png
        }"
      done
    '';
}
