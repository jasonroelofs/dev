function s:Softwrap()
  set formatoptions=1
  set linebreak
  set wrap
  set nolist
  set breakat=\ |@-+;:,./?^I
  set lazyredraw
  nnoremap j gj
  nnoremap k gk
  vnoremap j gj
  vnoremap k gk
endfunction

if !exists(":Softwrap")
  command -nargs=0 Softwrap :call s:Softwrap()
endif
