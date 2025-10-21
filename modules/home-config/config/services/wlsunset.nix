{
  flake-inputs,
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.wlsunset
  ];
  
  # Blue light filter
    services.wlsunset = {
      enable = true;
      latitude = 43.5;
      longitude = -81.7;

      temperature.night = 3300;
    };
}