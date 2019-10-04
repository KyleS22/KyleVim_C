" Make sure this plugin is runnable


if !has("python3")
	echo "Vim must be compiled with +python3 to use KyleVim"
	finish
endif

if exists('g:KyleVim_C_plugin_loaded')
	finish
endif


let s:plugin_root_dir = fnamemodify(resolve(expand('<sfile>p')), ':h')

filetype plugin on

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

" Auto comment headers
" Insert an auto populated docstring at lineNum
function! InsertCHeader(lineNum)
    python3 sys.argv = [vim.eval('a:lineNum')]
    python3 auto_func.insert_header_comment(sys.argv[0])

endfunction

command! -nargs=1 InsertCHeader call InsertCHeader(<f-args>)

nnoremap <C-b> :call InsertCHeader(line("."))<CR>
inoremap <C-b> <ESC>:call InsertCHeader(line("."))<CR>I

" 80 character column line
if !exists("g:KyleVimC_Disable_ColorCol") && exists('+colorcolumn')
	set colorcolumn=80
endif

let g:KyleVim_C_plugin_loaded = 1
