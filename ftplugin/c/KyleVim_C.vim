" Make sure this plugin is runnable


if !has("python3")
	echo "Vim must be compiled with +python3 to use KyleVim"
	finish
endif

if exists('g:KyleVim_C_plugin_loaded')
	finish
endif


let s:plugin_root_dir = fnamemodify(resolve(expand('<sfile>p')), ':h')

"======================================================================
" Environment Setup
"=====================================================================
filetype plugin on

" Turn on line numbers
set number

" Highlight line number of current line
if !exists("g:KyleVimC_Disable_NumberHl")
	set cursorline
	hi cursorline cterm=none ctermbg=none
endif

" 80 character column line
if !exists("g:KyleVimC_Disable_ColorCol") && exists('+colorcolumn')
	set colorcolumn=80
endif


" Set up highlights and signs for gcc warnings
hi GutWarn ctermfg=11 ctermbg=none
sign define warn text=w texthl=GutWarn

"==================================================================
" Mappings
"==================================================================

" Insert Include Guards
nnoremap <F5> :call InsertIncludeGuard()<CR>
inoremap <F5> <ESC>:call InsertIncludeGuard()<CR>I

" Insert Comments
nnoremap <C-b> :call InsertCHeader(line("."))<CR>
inoremap <C-b> <ESC>:call InsertCHeader(line("."))<CR>I



"===================================================================
" Autocommands
"==================================================================
" Check Syntax when the file is opened or saved
autocmd BufWinEnter <buffer> call CheckCSyntax()
autocmd BufWritePost <buffer> call CheckCSyntax()



"==================================================================

" Load the python modules
python3 << EOF

import sys
from os.path import normpath, join
import vim

plugin_root_dir = vim.eval('s:plugin_root_dir')
python_root_dir = normpath(join(plugin_root_dir, '../..', 'python'))
sys.path.insert(0, python_root_dir)

import auto_function_headers as auto_func
EOF
"=====================================================================
"
let g:KyleVim_C_plugin_loaded = 1
