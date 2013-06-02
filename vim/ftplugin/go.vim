" Run the current file with F5
map <F5> :only<CR>:w<CR>:!go run '%' 2>&1 \| tee ~/tmp/.go-lang.out<CR>:sp ~/tmp/.go-lang.out<CR><CR>

" Run a syntax check and display errors only
map <F4> :w<CR>:!gofmt -e '%' 1>/dev/null<CR>

" Reformat the current file using gofmt
map <leader>f :Fmt<CR>

" Go back to using real tabs, it's the Go Way
set noexpandtab

" Easy commenting / uncommenting
map z :s/^/\/\/<CR><Down>
map Z :s/^\s*\(\/\/\)//<CR><Down>

" Test generation macros
iabbr _test func Test_(t *testing.T) {<ESC>16<LEFT>s

" Testify macros
iabbr _ae assert.Equal(t,
iabbr _ane assert.NotEqual(t,
iabbr _an assert.Nil(t,
iabbr _ann assert.NotNil(t,
iabbr _at assert.True(t,
iabbr _af assert.False(t,
iabbr _ac assert.Contains(t,
iabbr _anc assert.NotContains(t,

