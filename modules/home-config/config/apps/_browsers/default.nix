{
  flake-inputs,
  ...
}:

{
  imports = [
    ./firefox
    ./tor-browser
  ];
}