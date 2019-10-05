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

set number
if !exists("g:KyleVimC_Disable_NumberHl")
	set cursorline
	hi cursorline cterm=none ctermbg=none
endif

hi GutWarn ctermfg=11 ctermbg=none
sign define warn text=w texthl=GutWarn

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

nnoremap <F5> :call InsertIncludeGuard()<CR>
inoremap <F5> <ESC>:call InsertIncludeGuard()<CR>I
" 80 character column line
if !exists("g:KyleVimC_Disable_ColorCol") && exists('+colorcolumn')
	set colorcolumn=80
endif

" Check the syntax and errors of the current file
function! CheckCSyntax()
	
	if !filereadable(bufname("%"))
		return
	endif

	call clearmatches()
	cexpr []	
		

	if filereadable("Makefile")
		for name in BuffersList()
			if name != ""
				exe "sign unplace * file=" . name
			endif
		endfor 
	
		let report = systemlist("make")
	else
		let report = systemlist("gcc -o /dev/null -Wall -Wextra " . bufname("%"))
	endif 

	for msg in report
		
		" Add the message to the quickfix list
		caddexpr msg
		
		let parts = split(msg, ":")
		
		if len(parts) == 1
			continue
		endif
		
		let file_name = parts[0]
		let line_num = parts[1]
		

		try
			let type = parts[3]
		catch
			continue
		endtry

		if type =~ "error"
			exe ":sign place 2 line=" . line_num ." name=Vu_error file=" . file_name
		else
			exe ":sign place 2 line=" . line_num . " name=warn file=" . file_name
		endif
	endfor
endfunction

" Check Syntax when the file is opened or saved
autocmd BufWinEnter <buffer> call CheckCSyntax()
autocmd BufWritePost <buffer> call CheckCSyntax()

function! BuffersList()
  let all = range(0, bufnr('$'))
  let res = []
  for b in all
    if buflisted(b)
      call add(res, bufname(b))
    endif
  endfor
  return res

endfunction

" Auto insert include guards
function! InsertIncludeGuard()
	let lines = getbufline(bufnr("%"), 1, "$")
	let i = 0
	
	let include_name = toupper(expand("%:r")) . "_INCLUDE"
	

	for line in lines
		if line =~ "//"
			let i = i + 1
		else
			call append(i, "#ifndef " . include_name)
			call append(i + 1, "#define " . include_name)	
			break
		endif
	endfor	
	call append("$", "#endif // " . include_name)
endfunction
let g:KyleVim_C_plugin_loaded = 1
