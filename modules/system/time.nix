{

  flake.modules.nixos.time = _: {
    # Set your time zone.
    time.hardwareClockInLocalTime = true;
    time.timeZone = "America/New_York";
  };

}
