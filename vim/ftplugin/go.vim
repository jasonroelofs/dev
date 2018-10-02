" Easy commenting / uncommenting
map z :s/^/\/\/<CR><Down>
map Z :s/^\s*\(\/\/\)//<CR><Down>

map <leader>t :GoTest<CR>

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

