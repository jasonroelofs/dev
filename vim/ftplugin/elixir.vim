"""""""""""""""""""""""""""""
" Custom Ruby configuration "
"""""""""""""""""""""""""""""

" Easy commenting / uncommenting
noremap z :s/^/#<CR><Down>
noremap Z :s/^\s*\(#\)//<CR><Down>

" ERB helpers
iabbr _rv <%= %><Esc>2<Left>i
iabbr _rc <% %><Esc>2<Left>i
