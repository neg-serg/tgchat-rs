# tgchat-rs

Telegram chat access for a person and a local agent, as one CLI: dialogs,
history, search, JSONL export and sending — over a
[grammers](https://github.com/Lonami/grammers) MTProto **user** session.

It replaces a retired Python/Telethon `tgchat`. A Telethon session file cannot
be read by another library, so this is a fresh session rather than a migration:
the first run is `tgchat-rs login`.

## Why a user session

The Bot API only sees chats a bot was added to. A user session sees the
account's own dialogs, which is what an agent needs in order to read or answer
a conversation that already exists.

## Usage

```
tgchat-rs login [--phone <number>] [--code <code>] [--password <2fa>]
tgchat-rs whoami [--json]
tgchat-rs dialogs [--limit 20] [--json]
tgchat-rs tail [<chat>] [-n 20] [--json]
tgchat-rs search <query> [--chat <chat>] [-n 20] [--json]
tgchat-rs export [--chat <chat>] [--out ~/telegram-export.jsonl]
                 [--dialogs 0] [--per-chat 0]
tgchat-rs send <chat> <text>... [--file <path>] [--reply-to <message-id>]
```

`<chat>` is a username, a phone number, a link or a numeric id. The omitted
arguments of `login` are prompted for, so a plain `tgchat-rs login` is enough.

`export` writes one JSON object per line (`chat`, `chat_id` plus the rendered
message). `--dialogs 0` walks every dialog and `--per-chat 0` takes every
message; both are caps, not defaults to scroll past.

Every read command takes `--json`; that is the form to feed to an agent or to
`jq`, and the only stable interface besides the exit code.

## Credentials and state

| what | source |
| --- | --- |
| `api_id` | gopass `api/telegram-telethon-id`, or `TELEGRAM_API_ID` |
| `api_hash` | gopass `api/telegram-telethon-hash`, or `TELEGRAM_API_HASH` |
| session | `~/.local/state/telegram-chat/session.sqlite`, dir from `TGCHAT_STATE` |
| proxy | `socks5://127.0.0.1:10808`, from `TELEGRAM_PROXY`; `TELEGRAM_PROXY=off` disables |

The environment wins over gopass. The session file is a credential: it grants
access to the account without a password, so keep it out of any repository and
out of backups that are not already encrypted.

The proxy default is not cosmetic: on networks where the MTProto endpoints are
unreachable directly, every command fails without it. Point `TELEGRAM_PROXY` at
whatever SOCKS5 listener the machine has, or set it to `off` where the direct
route works.

## Build and test

```sh
nix build .#default     # the CLI
nix develop             # cargo, rustc, rustfmt, clippy
cargo test
cargo fmt --check
```

## License

MIT — see [LICENSE](LICENSE).
