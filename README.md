# gitignore

A Swift CLI for listing, searching, and generating `.gitignore` templates using the [Toptal gitignore API](https://www.toptal.com/developers/gitignore/api/list).

## Installation

```sh
brew install kantacky/tap/gitignore
```

## Usage

```sh
gitignore list
gitignore search swift
gitignore dump macos,swift,xcode
gitignore dump macos,swift,xcode > .gitignore
```

- `list`: List available templates alphabetically, one per line.
- `search <keyword>`: Search template names using a case-insensitive substring match. No matches produce empty output and a successful exit.
- `dump <items>`: Write the generated content for comma-separated templates directly to standard output.
- `--help` / `-h`: Show usage information.

An internet connection is required. Errors are written to standard error with exit code 1.

## License

[MIT](LICENSE)
