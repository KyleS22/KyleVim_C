" Find undocumented functions
function! FindUndocumentedCFunctions()
	/\(^\n.\+ .\+(.*)\(.*{\|;\)\)\|\(^\nstruct .\+.*{\)\|\(^\nclass .\+.*{\)
	normal! j	
endfunction

