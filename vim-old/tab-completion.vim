
" Make the tab key act like ^N in insert mode, if the cursor is on a word.
" Otherwise, do the normal tab thing.
" (Probably not compatible with tab-indent.)

" Intelligent tab completion
inoremap <silent> <Tab> <C-r>=<SID>InsertTabWrapper(1)<CR>
inoremap <silent> <S-Tab> <C-r>=<SID>InsertTabWrapper(-1)<CR>

function! <SID>InsertTabWrapper(direction)
	let idx = col('.') - 1
	let str = getline('.')

	if a:direction > 0 && idx >= 2 && str[idx - 1] == ' '
			\&& str[idx - 2] =~? '[a-z]'
		if &softtabstop && idx % &softtabstop == 0
			return "\<BS>\<Tab>\<Tab>"
		else
			return "\<BS>\<Tab>"
		endif
	elseif idx == 0 || str[idx - 1] !~? '[a-z]'
		return "\<Tab>"
	elseif a:direction > 0
		return "\<C-p>"
	else
		return "\<C-n>"
	endif
endfunction
