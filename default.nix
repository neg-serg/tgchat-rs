# tgchat-rs — Telegram chat access over a grammers MTProto user session.
#
# Packaging only. The commands, the credential sources, the session location
# and the proxy handling are documented in README.md and src/main.rs.
{
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "tgchat-rs";
  version = (lib.importTOML ./Cargo.toml).package.version;

  # Keep the build output, the flake and the docs out of the store copy.
  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./Cargo.toml
      ./Cargo.lock
      ./src
    ];
  };

  cargoLock.lockFile = ./Cargo.lock;

  meta = {
    description = "Telegram chat access on a grammers MTProto user session";
    homepage = "https://github.com/neg-serg/tgchat-rs";
    license = lib.licenses.mit;
    mainProgram = "tgchat-rs";
    platforms = lib.platforms.unix;
  };
}
