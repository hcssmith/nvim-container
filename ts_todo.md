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
