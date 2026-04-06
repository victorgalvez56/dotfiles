# dotfiles

Personal development environment for macOS.

**Philosophy:** nvim is the viewer/navigator. Claude Code is the editor. Terminal-only — no VS Code, no Cursor.

```
┌─────────────────────────────────────────────────────────┐
│                        Ghostty                           │
│                                                          │
│   Tab 1: project-a         Tab 2: project-b              │
│                                                          │
│   ┌──────────────────────┬───────────────────────────┐   │
│   │                      │                           │   │
│   │        nvim          │        claude             │   │
│   │   (view / navigate)  │   (edit / commit)         │   │
│   │                      │                           │   │
│   └──────────────────────┴───────────────────────────┘   │
│          Cmd+D = split          Cmd+Opt+← → = navigate   │
└─────────────────────────────────────────────────────────┘
```

---

## Stack

| Tool | Version / Config |
|------|-----------------|
| Terminal | [Ghostty](https://ghostty.org) — JetBrainsMono Nerd Font 14px, Japanese wave background |
| Editor | [Neovim](https://neovim.io) 0.11 — lazy.nvim, 35 plugins |
| AI | [Claude Code](https://claude.ai/code) CLI (Opus 4.6) |
| Git TUI | [lazygit](https://github.com/jesseduffield/lazygit) |

---

## Install

```bash
git clone https://github.com/victorgalvez56/dotfiles.git
cd dotfiles
bash install.sh
```

The script installs everything from scratch on any macOS machine. Existing configs are backed up before overwriting.

### What gets installed

- **Homebrew** — package manager
- **Neovim** — editor (0.11+)
- **lazygit** — git TUI
- **Node.js** — runtime for TypeScript LSP and Claude Code CLI
- **Python** — runtime for Pyright and Black
- **ripgrep, fd, fzf** — fast search tools used by Telescope
- **stylua** — Lua formatter
- **JetBrainsMono Nerd Font** — terminal font
- **Ghostty** — terminal emulator
- **Claude Code CLI** — AI coding assistant

### One manual step

The Ghostty background (Japanese waves / Hokusai) is a PNG you need to provide:

```bash
cp /path/to/your/hokusai.png ~/Pictures/ghostty-bg.png
```

Everything else is automated.

---

## Repo structure

```
dotfiles/
├── install.sh                    # One-command setup
├── ghostty/
│   └── config                    # Terminal config
├── nvim/
│   ├── init.lua                  # Options, keymaps, lazy.nvim bootstrap
│   └── lua/plugins/
│       ├── ui.lua                # Theme, statusline, bufferline, noice
│       ├── navigation.lua        # Telescope, mini.files
│       ├── git.lua               # Gitsigns, diffview, lazygit
│       ├── lsp.lua               # Mason, LSP servers, nvim-cmp, conform
│       ├── dap.lua               # Debug adapter (JS/TS, Node, Jest)
│       └── markdown.lua          # Treesitter, render-markdown
└── claude/
    └── CLAUDE.md                 # Global Claude Code instructions
```

---

## Daily workflow

```bash
cd my-project

# Open nvim on the left
nvim .

# Cmd+D — split right, then:
claude

# Describe the task to Claude → Claude edits files → nvim auto-reloads
# Review changes with ]h (hunks) or <space>dv (full diff)
# Claude runs /commit when everything looks good
```

### Parallel work without conflicts

```bash
# Terminal 1 — main feature
claude --worktree auth-fix "fix the login bug"

# Terminal 2 — separate task
claude --worktree api-docs "update API documentation"

# Each worktree is an isolated git branch
```

---

## Keyboard shortcuts

### Ghostty

| Shortcut | Action |
|----------|--------|
| `Cmd+D` | Split right (nvim \| claude) |
| `Cmd+Shift+D` | Split down |
| `Cmd+Opt+← → ↑ ↓` | Navigate splits |
| `Cmd+Opt+Shift+← →` | Resize splits |
| `Cmd+T` | New tab |
| `Cmd+W` | Close split/tab |

### Nvim — Files

| Shortcut | Action |
|----------|--------|
| `<space>f` | Find files (Telescope) |
| `<space>g` | Grep project |
| `<space>b` | Open buffers |
| `<space>o` | Recent files |
| `-` | File explorer (mini.files) |
| `<space>e` | File explorer from project root |
| `Shift+H` / `Shift+L` | Previous / next buffer |
| `Ctrl+H/J/K/L` | Navigate windows |

### Nvim — Git

| Shortcut | Action |
|----------|--------|
| `]h` / `[h` | Next / prev hunk |
| `<space>hp` | Preview hunk inline |
| `<space>hb` | Blame line |
| `<space>hd` | Diff current file vs HEAD |
| `<space>hs` / `<space>hr` | Stage / reset hunk |
| `<space>dv` | Full diff view (working tree) |
| `<space>dh` | File history |
| `<space>dl` | Branch history |
| `<space>dc` | Close diff view |
| `<space>lg` | Open lazygit |

### Nvim — LSP

| Shortcut | Action |
|----------|--------|
| `gd` | Go to definition |
| `gr` | References |
| `K` | Hover docs |
| `<space>lr` | Rename symbol |
| `<space>la` | Code action |
| `<space>lf` | Format file |
| `<space>ld` | Line diagnostics |
| `]d` / `[d` | Next / prev diagnostic |

### Nvim — Debug (DAP)

| Shortcut | Action |
|----------|--------|
| `<space>Db` | Toggle breakpoint |
| `<space>DB` | Conditional breakpoint |
| `<space>Dc` | Start / continue |
| `<space>Dn` / `<space>Di` / `<space>Do` | Step over / into / out |
| `<space>Dq` | Terminate |
| `<space>Du` | Toggle debug UI |
| `<space>De` | Evaluate expression |

---

## Plugins (35 total)

### UI
`catppuccin` · `lualine` · `bufferline` · `indent-blankline` · `nvim-colorizer` · `neoscroll` · `which-key` · `noice` · `todo-comments`

### Navigation
`telescope` · `telescope-fzf-native` · `mini.files`

### Git
`gitsigns` · `diffview` · `lazygit`

### LSP + Completion
`mason` · `mason-lspconfig` · `mason-tool-installer` · `nvim-lspconfig` · `nvim-cmp` · `cmp-nvim-lsp` · `cmp-buffer` · `cmp-path` · `LuaSnip` · `cmp_luasnip` · `conform`

### Debug (DAP)
`nvim-dap` · `nvim-dap-ui` · `nvim-nio` · `mason-nvim-dap`

### Syntax / Markdown
`nvim-treesitter` · `render-markdown`

---

## LSP servers

| Server | Language | Installation |
|--------|----------|-------------|
| `ts_ls` | TypeScript / JavaScript | Mason (automatic) |
| `lua_ls` | Lua | Mason (automatic) |
| `pyright` | Python | Mason (automatic) |
| `sourcekit` | Swift / Obj-C | Xcode (bundled) |

Formatters auto-installed by Mason: **prettier** (JS/TS/HTML/CSS/JSON/YAML), **black** (Python), **stylua** (Lua).

---

## Claude Code commands

| Command | Action |
|---------|--------|
| `/commit` | Commit with descriptive message based on diff |
| `/compact` | Free context in long conversations |
| `/resume` | Pick a previous conversation |
| `--continue` | Continue the last conversation |
| `--worktree name` | Isolated branch for a parallel task |
| `/cost` | Session cost |
| `/model` | Switch between Opus / Sonnet / Haiku |

---

## Re-running the installer

The script is idempotent. On subsequent runs it skips already-installed tools and backs up any changed config before overwriting.

```bash
cd dotfiles && git pull && bash install.sh
```
