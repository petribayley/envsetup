#!/bin/bash

VIM_CONFIG="/home/${USER}/.vimrc"
TMUX_CONFIG="/home/${USER}/.tmux.conf"

/bin/cat > $VIM_CONFIG << EOF
" Custom Configs
set number
set statusline+=%F

" Binds
nnoremap <C-E> :LspHover<CR>

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin()

" List your plugins here
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'

call plug#end()

if executable('rustup')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rust-analyzer',
        \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rust-analyzer']},
        \ 'allowlist': ['rust'],
        \ })
endif

if executable('pyls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ })
endif
EOF

/bin/cat > $TMUX_CONFIG << EOF
# Remap prefix to Ctrl-Space
unbind C-b
set-option -g prefix C-Space
bind C-Space send-prefix

# Remap split window
unbind '"'
unbind %
bind '\' split-window -h
bind - split-window -v

# Bind config reload
bind r source-file ~/.tmux.conf

# Enable mouse mode
set -g mouse on
EOF
