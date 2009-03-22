" ----------------------------------------------------------------------------
" Put this in your ~/.vimrc to automatically run code for perl files
"au Syntax perl source $HOME/.vim/perl.vim


" ----------------------------------------------------------------------------
" Put this in ~/.vim/perl.vim (or change the above line...)
set autoindent nocindent nosmartindent

" Perl indenting rules, slightly modified for Atomicness ---------------------

" Vim indent file
" Language:	Perl
" Author:	Rafael Garcia-Suarez <rgarciasuarez@free.fr>
" URL:		http://rgarciasuarez.free.fr/vim/indent/perl.vim
" Last Change:	2002 Mar 20

" Suggestions and improvements by :
"   Aaron J. Sherman (use syntax for hints)
"   Artem Chuprina (play nice with folding)

" TODO things that are not or not properly indented (yet) :
" - Continued statements
"     print "foo",
"	"bar";
"     print "foo"
"	if bar();
" - Multiline regular expressions (m//x)
" (The following probably needs modifying the perl syntax file)
" - qw() lists
" - Heredocs with terminators that don't match \I\i*

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

" Is syntax highlighting active ?
let b:indent_use_syntax = has("syntax") && &syntax == "perl"

let s:cpo_save = &cpo
set cpo-=C

setlocal indentexpr=AtomicPerlIndent()
setlocal indentkeys+=0=,0),0=or,0=and
if !b:indent_use_syntax
  setlocal indentkeys+=0=EO
endif

" Only define the function once.
if exists("*AtomicPerlIndent")
  finish
endif

function AtomicPerlIndent()

  " Get the line to be indented
  let cline = getline(v:lnum)

  " Indent POD markers to column 0
  if cline =~ '^\s*=\L\@!'
    return 0
  endif

  " Get current syntax item at the line's first char
  let csynid = ''
  if b:indent_use_syntax
    let csynid = synIDattr(synID(v:lnum,1,0),"name")
  endif

  " Don't reindent POD and heredocs
  if csynid == "perlPOD" || csynid == "perlHereDoc" || csynid =~ "^pod"
    return indent(v:lnum)
  endif

  " Indent end-of-heredocs markers to column 0
  if b:indent_use_syntax
    " Assumes that an end-of-heredoc marker matches \I\i* to avoid
    " confusion with other types of strings
    if csynid == "perlStringStartEnd" && cline =~ '^\I\i*$'
      return 0
    endif
  else
    " Without syntax hints, assume that end-of-heredocs markers begin with EO
    if cline =~ '^\s*EO'
      return 0
    endif
  endif

  " Now get the indent of the previous perl line.

  " Find a non-blank line above the current line.
  let lnum = prevnonblank(v:lnum - 1)
  " Hit the start of the file, use zero indent.
  if lnum == 0
    return 0
  endif
  let line = getline(lnum)
  let ind = indent(lnum)
  " Skip heredocs, POD, and comments on 1st column
  if b:indent_use_syntax
    let skippin = 2
    while skippin
      let synid = synIDattr(synID(lnum,1,0),"name")
      if (synid == "perlStringStartEnd" && line =~ '^\I\i*$')
	    \ || (skippin != 2 && synid == "perlPOD")
	    \ || (skippin != 2 && synid == "perlHereDoc")
	    \ || synid =~ "^pod"
	let lnum = prevnonblank(lnum - 1)
	if lnum == 0
	  return 0
	endif
	let line = getline(lnum)
	let ind = indent(lnum)
	let skippin = 1
      else
	let skippin = 0
      endif
    endwhile
  else
    if line =~ "^EO"
      let lnum = search("<<[\"']\\=EO", "bW")
      let line = getline(lnum)
      let ind = indent(lnum)
    endif
  endif

  " Indent blocks enclosed by {} or ()
  if b:indent_use_syntax
    " Find a real opening brace
    let bracepos = match(line, '[(){}]', matchend(line, '^\s*[)}]'))
    while bracepos != -1
      let synid = synIDattr(synID(lnum, bracepos + 1, 0), "name")
      " If the brace is highlighted in one of those groups, indent it.
      " 'perlHereDoc' is here only to handle the case '&foo(<<EOF)'.
      if synid == ""
	    \ || synid == "perlMatchStartEnd"
	    \ || synid == "perlHereDoc"
	    \ || synid =~ "^perlFiledescStatement"
	    \ || synid =~ '^perl\(Sub\|BEGINEND\|If\)Fold'
	let brace = strpart(line, bracepos, 1)
	if brace == '(' || brace == '{'
	  let ind = ind + &sw
	else
	  let ind = ind - &sw
	endif
      endif
      let bracepos = match(line, '[(){}]', bracepos + 1)
    endwhile
    let bracepos = matchend(cline, '^\s*[)}]')
    if bracepos != -1
      let synid = synIDattr(synID(v:lnum, bracepos, 0), "name")
      if synid == ""
	    \ || synid == "perlMatchStartEnd"
	    \ || synid =~ '^perl\(Sub\|BEGINEND\|If\)Fold'
	let ind = ind - &sw
      endif
    endif
  else
    if line =~ '[{(]\s*\(#[^)}]*\)\=$'
      let ind = ind + &sw
    endif
    if cline =~ '^\s*[)}]'
      let ind = ind - &sw
    endif
  endif

  " Indent lines that begin with 'or' or 'and'
  if cline =~ '^\s*\(or\|and\)\>'
    if line !~ '^\s*\(or\|and\)\>'
      let ind = ind + &sw
    endif
  elseif line =~ '^\s*\(or\|and\)\>'
    let ind = ind - &sw
  endif
  
  return ind

endfunction

let &cpo = s:cpo_save
unlet s:cpo_save

:iabbr utest ### See that##sub test_something() {ok(0, "implement me");}<ESC>4<Up>A

:iabbr _ae is($exp, $got, "xxx");<esc>17<left>
:iabbr _at is($bool, 1, "xxx");<esc>17<left>
:iabbr _af is($bool, 0, "xxx");<esc>17<left>
:iabbr _fail ok(0, "xxx");<esc>17<left>

" Set tags
:set tags=$PROJ_HOME/tags
" Regenerate tags
:command PerlTags !ctags -f $PROJ_HOME/tags `find $PROJ_HOME -name "*.p?"`

:iabbr _ps ". ."<Left><Left><Left>

:iabbr fori for (my $i=0; $i < _something_; $i++) {}<Left><Up>	


:iabbr _bm _bogifyMethod<ESC>:.!~/.vim/tools/perl/perl_bogify_method.pl<CR>,i
:iabbr _bc _bogifyClass<ESC>:.!~/.vim/tools/perl/perl_bogify_class.pl<CR>,i
:iabbr _test _test<ESC>:.!~/.vim/tools/perl/perl_test_expand.pl<CR>
:iabbr _ntc _newTestClass<ESC>:.!~/.vim/tools/perl/perl_new_test_class.pl<CR>
:iabbr _pod <ESC>:r ~/.vim/tools/perl/pod_header.txt<CR>

" Compile-and-run:
:noremap <F5> :only<CR>:w<CR>:!perl % > ~/tmp/.perlrun.out 2>&1<CR>:sp ~/tmp/.perlrun.out<CR>G
" Jump into a scratch buffer:
:noremap <F3> :e ~/tmp/scratch.pl<CR>
" Comment-out
:noremap z :s/^/#<CR>
" Comment-in
:noremap Z :s/^\s*\(#\)//<CR>

" Generate a sub with "$self = shift" as the first line:
:noremap \ds :.!~/.vim/tools/perl/perl_expand_sub.pl<CR>

" Pod syntax checker
:command PodChecker !podchecker %
:noremap <F8> :PodChecker<CR>

"map ,t :e <C-R>=expand("%:p:h")<CR>/t/Test<C-R>=expand("%:p:t")<CR><CR>
"map ,T :!gvim -t Test<C-R>=expand("<cword>")<CR><CR><CR>
"map ,s :ta <C-R>=substitute(expand("<cword>"), "Test", "", "")<CR><CR>
"map gt :ta Test<C-R>=expand("<cword>")<CR><CR>
"map gT :!gvim -t Test<C-R>=expand("<cword>")<CR><CR><CR>
"map gs :ta <C-R>=substitute(expand("<cword>"), "Test", "", "")<CR><CR>

" vimts=8:sts=2:sw=2
