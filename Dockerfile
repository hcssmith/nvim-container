FROM alpine:latest AS builder

RUN apk add --no-cache \
    git \
    build-base \
    linux-headers \
    cmake \
    gettext-dev \
    unzip \
    curl \
    ninja

ARG NVIM_VERSION=release-0.12

ADD --keep-git-dir=true https://github.com/neovim/neovim.git#${NVIM_VERSION} /neovim
WORKDIR /neovim
RUN --mount=type=cache,target=/neovim/.deps \
    --mount=type=cache,target=/neovim/build \
    make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=/opt/nvim install

FROM alpine:latest AS parser-builder

RUN apk add --no-cache build-base git git-lfs
RUN mkdir -p /out
RUN git lfs install

ADD https://github.com/tree-sitter/tree-sitter-bash.git /tmp/bash
RUN cd /tmp/bash/src && cc -shared -fPIC -O2 -o /out/bash.so parser.c scanner.c -I.

ADD https://github.com/tree-sitter/tree-sitter-c.git /tmp/c
RUN cd /tmp/c/src && cc -shared -fPIC -O2 -o /out/c.so parser.c -I.

ADD https://github.com/tree-sitter/tree-sitter-cpp.git /tmp/cpp
RUN cd /tmp/cpp/src && cc -shared -fPIC -O2 -o /out/cpp.so parser.c scanner.c -I.

ADD https://github.com/tree-sitter/tree-sitter-css.git /tmp/css
RUN cd /tmp/css/src && cc -shared -fPIC -O2 -o /out/css.so parser.c scanner.c -I.

ADD https://github.com/uyha/tree-sitter-cmake.git /tmp/cmake
RUN cd /tmp/cmake/src && cc -shared -fPIC -O2 -o /out/cmake.so parser.c scanner.c -I.

ADD https://github.com/stsewd/tree-sitter-comment.git /tmp/comment
RUN cd /tmp/comment/src && cc -shared -fPIC -O2 -o /out/comment.so parser.c scanner.c -I.

ADD https://github.com/camdencheek/tree-sitter-go-mod.git /tmp/gomod
RUN cd /tmp/gomod/src && cc -shared -fPIC -O2 -o /out/gomod.so parser.c -I.

ADD https://github.com/tree-sitter-grammars/tree-sitter-lua.git /tmp/lua
RUN cd /tmp/lua/src && cc -shared -fPIC -O2 -o /out/lua.so parser.c scanner.c -I.

ADD https://github.com/tree-sitter/tree-sitter-go.git /tmp/go
RUN cd /tmp/go/src && cc -shared -fPIC -O2 -o /out/go.so parser.c -I.

ADD https://github.com/tree-sitter/tree-sitter-html.git /tmp/html
RUN cd /tmp/html/src && cc -shared -fPIC -O2 -o /out/html.so parser.c scanner.c -I.

ADD https://github.com/tree-sitter/tree-sitter-java.git /tmp/java
RUN cd /tmp/java/src && cc -shared -fPIC -O2 -o /out/java.so parser.c -I.

ADD https://github.com/tree-sitter/tree-sitter-javascript.git /tmp/javascript
RUN cd /tmp/javascript/src && cc -shared -fPIC -O2 -o /out/javascript.so parser.c scanner.c -I.

ADD https://github.com/tree-sitter/tree-sitter-json.git /tmp/json
RUN cd /tmp/json/src && cc -shared -fPIC -O2 -o /out/json.so parser.c -I.

ADD https://github.com/tree-sitter/tree-sitter-python.git /tmp/python
RUN cd /tmp/python/src && cc -shared -fPIC -O2 -o /out/python.so parser.c scanner.c -I.

ADD https://github.com/tree-sitter/tree-sitter-regex.git /tmp/regex
RUN cd /tmp/regex/src && cc -shared -fPIC -O2 -o /out/regex.so parser.c -I.

ADD https://github.com/tree-sitter/tree-sitter-rust.git /tmp/rust
RUN cd /tmp/rust/src && cc -shared -fPIC -O2 -o /out/rust.so parser.c scanner.c -I.

ADD https://github.com/tree-sitter/tree-sitter-toml.git /tmp/toml
RUN cd /tmp/toml/src && cc -shared -fPIC -O2 -o /out/toml.so parser.c scanner.c -I.

ADD https://github.com/tree-sitter/tree-sitter-typescript.git /tmp/typescript
RUN cd /tmp/typescript/typescript/src && cc -shared -fPIC -O2 -o /out/typescript.so parser.c scanner.c -I.

ADD https://github.com/neovim/tree-sitter-vimdoc.git /tmp/vimdoc
RUN cd /tmp/vimdoc/src && cc -shared -fPIC -O2 -o /out/vimdoc.so parser.c -I.

ADD https://github.com/tree-sitter-grammars/tree-sitter-markdown.git /tmp/markdown
RUN cd /tmp/markdown/tree-sitter-markdown/src && cc -shared -fPIC -O2 -o /out/markdown.so parser.c scanner.c -I. && \
    cd /tmp/markdown/tree-sitter-markdown-inline/src && cc -shared -fPIC -O2 -o /out/markdown_inline.so parser.c scanner.c -I.

ADD https://github.com/tree-sitter-grammars/tree-sitter-vim.git /tmp/vim
RUN cd /tmp/vim/src && cc -shared -fPIC -O2 -o /out/vim.so parser.c scanner.c -I.

ADD --keep-git-dir=true https://github.com/gmr/tree-sitter-postgres.git#v1.2.4 /tmp/postgres
RUN cd /tmp/postgres && git lfs pull && \
    cd /tmp/postgres/postgres/src && cc -shared -fPIC -O2 -o /out/postgres.so parser.c scanner.c -I. && \
    cd /tmp/postgres/plpgsql/src && cc -shared -fPIC -O2 -o /out/plpgsql.so parser.c scanner.c -I.

ADD https://github.com/tree-sitter-grammars/tree-sitter-yaml.git /tmp/yaml
RUN cd /tmp/yaml/src && cc -shared -fPIC -O2 -o /out/yaml.so parser.c scanner.c schema.core.c schema.json.c schema.legacy.c -I.

ADD https://github.com/nvim-treesitter/nvim-treesitter.git /tmp/nvim-treesitter
# tree-sitter-postgres queries use PCRE-style (?i), but Neovim's #match?
# compiles patterns as very-magic Vim regex, where (?i) is invalid
# (E866: Misplaced ?). Rewrite to Vim's case flag "\c". The scm file needs
# "\\c" (two chars) because tree-sitter query strings unescape "\\" first.
# Additionally, dollar_quoted_string is a single leaf token INCLUDING the
# "$$" delimiters, which the plpgsql grammar cannot parse, so the injected
# region is offset by 2 columns on each side to strip them. (Assumes bare
# $$ quoting; $tag$ bodies will not highlight.) Fail the build if the
# rewrites do not cover every predicate.
RUN cp -r /tmp/nvim-treesitter/runtime/queries /out/queries && rm -rf /tmp/nvim-treesitter && rm -rf /out/queries/query && \
    mkdir -p /out/queries/postgres && cp -r /tmp/postgres/postgres/queries/* /out/queries/postgres/ && \
    mkdir -p /out/queries/plpgsql && cp -r /tmp/postgres/plpgsql/queries/* /out/queries/plpgsql/ && \
    sed -i 's|(?i)|\\\\c|g' /out/queries/postgres/*.scm /out/queries/plpgsql/*.scm && \
    sed -i 's|(#set! injection.language|\n(#offset! @injection.content 0 2 0 -2)\n(#set! injection.language|g' /out/queries/postgres/injections.scm && \
    ! grep -rn '(?i)' /out/queries/postgres /out/queries/plpgsql && \
    test "$(grep -c '(#offset!' /out/queries/postgres/injections.scm)" -eq "$(grep -c '(#set! injection.language' /out/queries/postgres/injections.scm)"

FROM alpine:latest

RUN apk add --no-cache libintl libgcc xclip curl git ripgrep xdg-utils

COPY --from=builder /opt/nvim /usr/local
COPY --from=parser-builder /out/*.so /usr/local/lib/nvim/parser/
COPY --from=parser-builder /out/queries /usr/local/share/nvim/site/queries

RUN adduser --disabled-password --gecos "" nvim
RUN mkdir /workspace && chown nvim:users /workspace

USER nvim
WORKDIR /workspace

ARG ppath=/home/nvim/.local/share/nvim/site/pack

RUN mkdir -p ${ppath}

ADD https://github.com/nvim-lua/plenary.nvim.git ${ppath}/plenary.nvim/start/plenary.nvim
ADD https://github.com/nvim-telescope/telescope.nvim.git ${ppath}/telescope.nvim/start/telescope.nvim
ADD https://github.com/folke/tokyonight.nvim.git ${ppath}/tokyonight.nvim/start/tokyonight.nvim
ADD https://github.com/nvim-lualine/lualine.nvim.git ${ppath}/lualine.nvim/start/lualine.nvim
ADD https://github.com/nvim-tree/nvim-web-devicons.git ${ppath}/nvim-web-devicons/start/nvim-web-devicons
ADD https://github.com/folke/zen-mode.nvim.git ${ppath}/zen-mode.nvim/start/zen-mode.nvim
ADD https://github.com/MunifTanjim/nui.nvim.git ${ppath}/nui.nvim/start/nui.nvim
ADD https://github.com/folke/noice.nvim.git ${ppath}/noice.nvim/start/noice.nvim

COPY init.lua /home/nvim/.config/nvim/
COPY ./lua /home/nvim/.config/nvim/lua

CMD ["nvim"]
