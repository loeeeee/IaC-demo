{ config, pkgs, ... }:

{
  # Enable KDE Plasma 6 Wayland desktop environment
  services.desktopManager.plasma6.enable = true;

  # Configure SDDM display manager with Wayland support
  services.displayManager.sddm = {
    enable = true;
    wayland = {
      enable = true;
      compositor = "kwin";
    };
    settings = {
      General = {
        AutoLoginEnable = true;
        AutoLoginUser = "loe";
        AutoLoginSession = "plasma.desktop";
      };
      Wayland = {
        EnableHiDPI = true;
      };
    };
  };

  # Set default session to Plasma Wayland
  services.displayManager.defaultSession = "plasma";

  # Configure auto-login for user loe
  services.displayManager.autoLogin = {
    enable = true;
    user = "loe";
  };

  # Enable PipeWire for audio
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;

    # Define a virtual sink for Sunshine to capture
    extraConfig.pipewire."99-virtual-sink" = {
      "context.objects" = [
        {
          factory = "adapter";
          args = {
            "factory.name" = "support.null-audio-sink";
            "node.name" = "Sunshine-Sink";
            "node.description" = "Sunshine Virtual Audio Sink";
            "media.class" = "Audio/Sink";
            "audio.position" = "FL,FR";
          };
        }
      ];
    };
  };

  # Fix cursor visibility in Sunshine streams on KDE Plasma Wayland
  # KWin uses hardware cursor rendering by default on Wayland, which isn't captured
  # by Sunshine's screen capture mechanism. These variables force software cursor
  # rendering and disable direct scanout to make the cursor visible in streams.
  environment.sessionVariables = {
    KWIN_FORCE_SW_CURSOR = "1";
    # KWIN_DRM_NO_DIRECT_SCANOUT = "1";
    # GTK OpenGL ES support for better Wayland compatibility
    GDK_GL = "gles";
  };

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    xwayland
  ];
}

