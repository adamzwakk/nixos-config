{
  flake-inputs,
  ...
}:

{
  imports = [
    ./firefox
    ./chrome
    ./tor-browser
  ];
}