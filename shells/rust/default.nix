{
    lib,
    inputs,
    namespace,
    pkgs,
    mkShell,
    ...
}:

mkShell {
    # Create your shell
    packages = with pkgs; [
      (rust-bin.stable.latest.default.override {
        extensions = ["rust-src"];
      })
      rustup 
      gcc
    ];
}