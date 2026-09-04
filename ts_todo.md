# Tree-sitter Parsers TODO

Verify org/availability for each parser and add to Dockerfile once confirmed.

## Need to verify correct org

| Parser | tree-sitter | tree-sitter-grammars | neovim | Other |
|--------|-------------|---------------------|--------|-------|
| cmake  | 404 | 404 | ? | ? |
| comment | 404 | 404 | ? | ? |
| go-mod | 404 | 404 | ? | ? |
| lua    | 404 | 200 | ? | ? |
| markdown | 404 | 404 | ? | ? |
| query  | 404 | 404 | ? | ? |
| vim    | 404 | 404 | ? | ? |
| yaml   | 404 | 404 | ? | ? |

## Confirmed working (under tree-sitter org)

- bash
- c
- cpp
- css
- go
- html
- java
- javascript
- json
- python
- regex
- rust
- toml
- typescript

## Confirmed working (other orgs)

- cmake → uyha/tree-sitter-cmake (has scanner)
- comment → stsewd/tree-sitter-comment (has scanner)
- go-mod → camdencheek/tree-sitter-go-mod (no scanner)
- lua → tree-sitter-grammars/tree-sitter-lua (has scanner)
- vimdoc → neovim/tree-sitter-vimdoc

## Still need to verify

- markdown
- query
- vim
- yaml

# Pinning & Rollback TODO

## Pin all `ADD` git URLs in the Dockerfile

Only neovim (`NVIM_VERSION=release-0.12`) and tree-sitter-postgres
(`#v1.2.4`) are pinned. Every other `ADD <git-url>` silently tracks the
default branch, which is what let the postgres parser break when upstream
added `scanner.c` (missing external scanner symbols → `postgres.so`
failed to dlopen). Pin the rest to an immutable tag or commit SHA, the
same way nvim is pinned, then bump them deliberately:

- [ ] Parser repos in the `parser-builder` stage: bash, c, cpp, css, cmake,
      comment, go-mod, lua, go, html, java, javascript, json, python,
      regex, rust, toml, typescript, vimdoc, markdown (+markdown_inline),
      vim, yaml
- [ ] `nvim-treesitter` (source of `runtime/queries` for all standard langs)
- [ ] Plugins in the final stage: plenary, telescope, tokyonight, lualine,
      nvim-web-devicons, zen-mode, nui, noice

## Image tagging for rollback

- [x] (2026-09-04) Makefile `build`/`debug` now tag every build with both
      `latest` and a `TIMESTAMP` (`YYYYmmdd-HHMMSS`), so a broken build can
      be rolled back by re-tagging the previous timestamp.
