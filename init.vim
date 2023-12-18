" Vim Plug
call plug#begin()

Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-lualine/lualine.nvim'

call plug#end()

" Editor
syntax on

set number
set relativenumber

set nowrap

set tabstop=2
set shiftwidth=2

set autoindent

" Theme
set termguicolors

let g:dracula_italic=0

color dracula

" Core
set nocompatible

let mapleader=","

nmap <leader>t :NvimTreeToggle<CR>

" Source Lua
lua require('init')
