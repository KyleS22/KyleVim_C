" Check the syntax and errors of the current file
function! CheckCSyntax()
	
	if !filereadable(bufname("%"))
		return
	endif

	call clearmatches()
	cexpr []	
		
    if exists("g:CurSyntaxCommand")
        for name in BuffersList()
            if name != ""
                exe "sign unplace * file=" . name
            endif
        endfor

        let report = systemlist(g:CurSyntaxCommand)
    
    elseif filereadable("Makefile")
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

" Get a list of all open buffers
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


