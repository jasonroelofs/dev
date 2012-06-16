"""""""""""""""""""""""""""""
" Custom Ruby configuration "
"""""""""""""""""""""""""""""

" Run the current file with F5
noremap <F5> :only<CR>:w<CR>:!env NO_COLOR_OUTPUT='true' ruby -Iapp:lib:spec:test '%' 2>&1 \| tee ~/tmp/.rubyrun.out<CR>:sp ~/tmp/.rubyrun.out<CR><CR>

" Run syntax check on the current file
noremap <F4> :w<CR>:!ruby -c '%'<CR>

" Easy commenting / uncommenting
noremap z :s/^/#<CR><Down>
noremap Z :s/^\s*\(#\)//<CR><Down>

" Test::Unit macros
iabbr _ae assert_equal
iabbr _ane assert_not_equal
iabbr _aid assert_in_delta expect, actual, delta, ""
iabbr _ai assert_instance_of
iabbr _ak assert_kind_of
iabbr _am assert_match
iabbr _an assert_nil
iabbr _ann assert_not_nil
iabbr _as assert_same
iabbr _ans assert_not_same
iabbr _art assert_redirected_to

