" tiara tricks
:noremap <F5> :only<CR>:w<CR>:!rake gs:test > ~/tmp/.javarun.tmp 2>&1<CR>:sp ~/tmp/.javarun.tmp<CR><CR>G

:setlocal ai
:setlocal cindent

"Commenting blocks in/out
:noremap z :s/\(^\)/\/\//<CR><Down>
:noremap Z :s/^\s*\(\/\/\)//<CR><Down>

" Java source code macros
:iabbr _ps "+ +"<Left><Left><Left>
:iabbr sout System.out.println("");<Left><Left><Left>
:iabbr serr System.err.println("");<Left><Left><Left>
:iabbr fori for (int i=0; i < _something_; i++) {
:iabbr tryb try {
:iabbr iter Iterator it = list.iterator();
:iabbr voidmain public static void main(String args[]) throws Exception {
:iabbr jdoc /**
:iabbr jdoc2 /**
:iabbr psf public static final String DEF = "";<Left>
:iabbr breader BufferedReader bread = new BufferedReader(new InputStreamReader(instream));

:iabbr utest /**
:iabbr uutest /**

:iabbr jimport import java.io.*;

" JUnit
:iabbr _an assertNull("not null", expect);<ESC>18<Left>i
:iabbr _ae assertEquals("wrong", expect, got);<ESC>15<Left>i
:iabbr _ann assertNotNull(" null", expect);<ESC>15<Left>i
:iabbr _as assertSame("wrong", expect, got);<ESC>15<Left>i
:iabbr _at assertTrue("", expect);<ESC>10<Left>i
:iabbr _af assertTrue("", !expect);<ESC>11<Left>i
:iabbr _ath try<cr>{<cr> <cr>fail("should have thrown");<cr>}<cr>catch (IllegalArgumentException ex)<cr>{<cr>}<up><cr>//ok<esc>6<up>
:iabbr _test public void testShouldDoSomething() throws Throwable<cr>{<cr><tab>fail("implement me");<cr>}<cr>


" JMock
:iabbr _mock Mock objMock;<cr>CLASS obj;<cr>objMock = mock(CLASS.class);<cr>obj = (CLASS)objMock.proxy();
:iabbr _ex Mock.expects(once()).method("METHOD").with(ARGS);<esc>0wi
:iabbr _er Mock.expects(once()).method("METHOD").with(ARGS).will(returnValue(RETURN));<esc>0wi
:iabbr _eth Mock.expects(once()).method("METHOD").with(ARGS)).will(throwException(error));<esc>0wi