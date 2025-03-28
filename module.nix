{ config, lib, pkgs, ... }: {
  options.services.x11vnc = {
    # I have no use for it without socket activation.
    # If you do have one, then please make an issue/PR.
    socketActivation = lib.mkEnableOption "";

    display = lib.mkOption {
      default = ":0";
      example = ":1";
      description = "Diplay ID to be used with x11vnc";
    };

    listenAddress = lib.mkOption {
      default = "127.0.0.1:5900";
      example = "%h/.vnc";
      description = "Socket address to bind to. File paths should work.";
    };

    logFile = lib.mkOption {
      default = "/dev/null";
      description =
        "File to write x11vnc output to. The service runs as your user, not as root, so ensure you have write access to this file.";
    };
  };

  config = let cfg = config.services.x11vnc;
  in lib.mkIf config.services.x11vnc.socketActivation {
    systemd.user.services."x11vnc@" = {
      requires = [ "x11vnc.socket" ];
      serviceConfig = {
        ExecStart =
          "${pkgs.x11vnc}/bin/x11vnc -display ${cfg.display} -inetd -o ${cfg.logFile}";
        StandardInput = "socket";
      };
    };

    systemd.user.sockets.x11vnc = {
      enable = cfg.socketActivation;
      wantedBy = [ "default.target" ];
      socketConfig = {
        ListenStream = cfg.listenAddress;
        Accept = true;
      };
    };
  };
}
