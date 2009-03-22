" Vim filetype plugin
" Language:		Ruby
" Maintainer:		Gavin Sinclair <gsinclair at gmail.com>
" Info:			$Id: ruby.vim,v 1.39 2007/05/06 16:38:40 tpope Exp $
" URL:			http://vim-ruby.rubyforge.org
" Anon CVS:		See above site
" Release Coordinator:  Doug Kearns <dougkearns@gmail.com>
" ----------------------------------------------------------------------------
"
" Original matchit support thanks to Ned Konz.  See his ftplugin/ruby.vim at
"   http://bike-nomad.com/vim/ruby.vim.
" ----------------------------------------------------------------------------

" Only do this when not done yet for this buffer
if (exists("b:did_ftplugin"))
  finish
endif
let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

if has("gui_running") && !has("gui_win32")
  setlocal keywordprg=ri\ -T
else
  setlocal keywordprg=ri
endif

" Matchit support
if exists("loaded_matchit") && !exists("b:match_words")
  let b:match_ignorecase = 0

  let b:match_words =
	\ '\<\%(if\|unless\|case\|while\|until\|for\|do\|class\|module\|def\|begin\)\>=\@!' .
	\ ':' .
	\ '\<\%(else\|elsif\|ensure\|when\|rescue\|break\|redo\|next\|retry\)\>' .
	\ ':' .
	\ '\<end\>' .
	\ ',{:},\[:\],(:)'

  let b:match_skip =
	\ "synIDattr(synID(line('.'),col('.'),0),'name') =~ '" .
	\ "\\<ruby\\%(String\\|StringDelimiter\\|ASCIICode\\|Escape\\|" .
	\ "Interpolation\\|NoInterpolation\\|Comment\\|Documentation\\|" .
	\ "ConditionalModifier\\|RepeatModifier\\|OptionalDo\\|" .
	\ "Function\\|BlockArgument\\|KeywordAsMethod\\|ClassVariable\\|" .
	\ "InstanceVariable\\|GlobalVariable\\|Symbol\\)\\>'"
endif

setlocal formatoptions-=t formatoptions+=croql

setlocal include=^\\s*\\<\\(load\\\|\w*require\\)\\>
setlocal includeexpr=substitute(substitute(v:fname,'::','/','g'),'$','.rb','')
setlocal suffixesadd=.rb

if exists("&ofu") && has("ruby")
  setlocal omnifunc=rubycomplete#Complete
endif

" To activate, :set ballooneval
if has('balloon_eval') && exists('+balloonexpr')
  setlocal balloonexpr=RubyBalloonexpr()
endif


" TODO:
"setlocal define=^\\s*def

setlocal comments=:#
setlocal commentstring=#\ %s

if !exists("s:rubypath")
  if has("ruby") && has("win32")
    ruby VIM::command( 'let s:rubypath = "%s"' % ($: + begin; require %q{rubygems}; Gem.all_load_paths.sort.uniq; rescue LoadError; []; end).join(%q{,}) )
    let s:rubypath = '.,' . substitute(s:rubypath, '\%(^\|,\)\.\%(,\|$\)', ',,', '')
  elseif executable("ruby")
    let s:code = "print ($: + begin; require %q{rubygems}; Gem.all_load_paths.sort.uniq; rescue LoadError; []; end).join(%q{,})"
    if &shellxquote == "'"
      let s:rubypath = system('ruby -e "' . s:code . '"')
    else
      let s:rubypath = system("ruby -e '" . s:code . "'")
    endif
    let s:rubypath = '.,' . substitute(s:rubypath, '\%(^\|,\)\.\%(,\|$\)', ',,', '')
  else
    " If we can't call ruby to get its path, just default to using the
    " current directory and the directory of the current file.
    let s:rubypath = ".,,"
  endif
endif

let &l:path = s:rubypath

if has("gui_win32") && !exists("b:browsefilter")
  let b:browsefilter = "Ruby Source Files (*.rb)\t*.rb\n" .
                     \ "All Files (*.*)\t*.*\n"
endif

let b:undo_ftplugin = "setl fo< inc< inex< sua< def< com< cms< path< kp<"
      \."| unlet! b:browsefilter b:match_ignorecase b:match_words b:match_skip"
      \."| if exists('&ofu') && has('ruby') | setl ofu< | endif"
      \."| if has('balloon_eval') && exists('+bexpr') | setl bexpr< | endif"

if !exists("g:no_plugin_maps") && !exists("g:no_ruby_maps")

  noremap <silent> <buffer> [m :<C-U>call <SID>searchsyn('\<def\>','rubyDefine','b')<CR>
  noremap <silent> <buffer> ]m :<C-U>call <SID>searchsyn('\<def\>','rubyDefine','')<CR>
  noremap <silent> <buffer> [M :<C-U>call <SID>searchsyn('\<end\>','rubyDefine','b')<CR>
  noremap <silent> <buffer> ]M :<C-U>call <SID>searchsyn('\<end\>','rubyDefine','')<CR>

  noremap <silent> <buffer> [[ :<C-U>call <SID>searchsyn('\<\%(class\<Bar>module\)\>','rubyModule\<Bar>rubyClass','b')<CR>
  noremap <silent> <buffer> ]] :<C-U>call <SID>searchsyn('\<\%(class\<Bar>module\)\>','rubyModule\<Bar>rubyClass','')<CR>
  noremap <silent> <buffer> [] :<C-U>call <SID>searchsyn('\<end\>','rubyModule\<Bar>rubyClass','b')<CR>
  noremap <silent> <buffer> ][ :<C-U>call <SID>searchsyn('\<end\>','rubyModule\<Bar>rubyClass','')<CR>

  let b:undo_ftplugin = b:undo_ftplugin
        \."| sil! exe 'unmap <buffer> [[' | sil! exe 'unmap <buffer> ]]' | sil! exe 'unmap <buffer> []' | sil! exe 'unmap <buffer> ]['"
        \."| sil! exe 'unmap <buffer> [m' | sil! exe 'unmap <buffer> ]m' | sil! exe 'unmap <buffer> [M' | sil! exe 'unmap <buffer> ]M'"
endif

let &cpo = s:cpo_save
unlet s:cpo_save

if exists("g:did_ruby_ftplugin_functions")
  finish
endif
let g:did_ruby_ftplugin_functions = 1

function! RubyBalloonexpr()
  if !exists('s:ri_found')
    let s:ri_found = executable('ri')
  endif
  if s:ri_found
    let line = getline(v:beval_lnum)
    let b = matchstr(strpart(line,0,v:beval_col),'\%(\w\|[:.]\)*$')
    let a = substitute(matchstr(strpart(line,v:beval_col),'^\w*\%([?!]\|\s*=\)\?'),'\s\+','','g')
    let str = b.a
    let before = strpart(line,0,v:beval_col-strlen(b))
    let after  = strpart(line,v:beval_col+strlen(a))
    if str =~ '^\.'
      let str = substitute(str,'^\.','#','g')
      if before =~ '\]\s*$'
        let str = 'Array'.str
      elseif before =~ '}\s*$'
        " False positives from blocks here
        let str = 'Hash'.str
      elseif before =~ "[\"'`]\\s*$" || before =~ '\$\d\+\s*$'
        let str = 'String'.str
      elseif before =~ '\$\d\+\.\d\+\s*$'
        let str = 'Float'.str
      elseif before =~ '\$\d\+\s*$'
        let str = 'Integer'.str
      elseif before =~ '/\s*$'
        let str = 'Regexp'.str
      else
        let str = substitute(str,'^#','.','')
      endif
    endif
    let str = substitute(str,'.*\.\s*to_f\s*\.\s*','Float#','')
    let str = substitute(str,'.*\.\s*to_i\%(nt\)\=\s*\.\s*','Integer#','')
    let str = substitute(str,'.*\.\s*to_s\%(tr\)\=\s*\.\s*','String#','')
    let str = substitute(str,'.*\.\s*to_sym\s*\.\s*','Symbol#','')
    let str = substitute(str,'.*\.\s*to_a\%(ry\)\=\s*\.\s*','Array#','')
    let str = substitute(str,'.*\.\s*to_proc\s*\.\s*','Proc#','')
    if str !~ '^\w'
      return ''
    endif
    silent! let res = substitute(system("ri -f simple -T \"".str.'"'),'\n$','','')
    if res =~ '^Nothing known about' || res =~ '^Bad argument:' || res =~ '^More than one method'
      return ''
    endif
    return res
  else
    return ""
  endif
endfunction

function! s:searchsyn(pattern,syn,flags)
    norm! m'
    let i = 0
    let cnt = v:count ? v:count : 1
    while i < cnt
        let i = i + 1
        let line = line('.')
        let col  = col('.')
        let pos = search(a:pattern,'W'.a:flags)
        while pos != 0 && s:synname() !~# a:syn
            let pos = search(a:pattern,'W'.a:flags)
        endwhile
        if pos == 0
            call cursor(line,col)
            return
        endif
    endwhile
endfunction

function! s:synname()
    return synIDattr(synID(line('.'),col('.'),0),'name')
endfunction

"
" Instructions for enabling "matchit" support:
"
" 1. Look for the latest "matchit" plugin at
"
"         http://www.vim.org/scripts/script.php?script_id=39
"
"    It is also packaged with Vim, in the $VIMRUNTIME/macros directory.
"
" 2. Copy "matchit.txt" into a "doc" directory (e.g. $HOME/.vim/doc).
"
" 3. Copy "matchit.vim" into a "plugin" directory (e.g. $HOME/.vim/plugin).
"
" 4. Ensure this file (ftplugin/ruby.vim) is installed.
"
" 5. Ensure you have this line in your $HOME/.vimrc:
"         filetype plugin on
"
" 6. Restart Vim and create the matchit documentation:
"
"         :helptags ~/.vim/doc
"
"    Now you can do ":help matchit", and you should be able to use "%" on Ruby
"    keywords.  Try ":echo b:match_words" to be sure.
"
" Thanks to Mark J. Reed for the instructions.  See ":help vimrc" for the
" locations of plugin directories, etc., as there are several options, and it
" differs on Windows.  Email gsinclair@soyabean.com.au if you need help.
"

:cabbr rr :w:!ruby %
:cabbr rR :w:!ruby % \| more

if has("unix")
	noremap <F5> :only<CR>:w<CR>:!ruby -Itest '%' 2>&1 \| tee ~/tmp/.rubyrun.out<CR>:sp ~/tmp/.rubyrun.out<CR><CR>
else
	noremap <F5> :only<CR>:w<CR>:!ruby -Itest '%' > "<C-R>=expand($HOME)<CR>/tmp/.rubyrun.out"<CR>:sp ~/tmp/.rubyrun.out<CR><CR>
endif

noremap <F6> :only<CR>:w<CR>:!ruby -Itest '%'<CR>

" Ruby syntax check
:noremap <F4> :w<CR>:!ruby -c '%'<CR>

" Jump to scratch buffer
:noremap <F3> :e ~/tmp/scratch.rb<CR>

" Comment-in and -out lines of ruby code
:noremap z :s/^/#<CR><Down>
:noremap Z :s/^\s*\(#\)//<CR><Down>

" Generate tags
"set tags=<C-R>=system('ruby ~/.vim/tools/find_tags.rb ' . expand("%:p"))
:let &tags = system("ruby ~/.vim/tools/find_tags.rb " . expand("%:p:h"))
:cabbr rtags !ctags -f $PROJ_HOME/tags `find $PROJ_HOME -name "*.rb"`

" Source code navigation tricksies
let SourceNavigation='ruby ~/.vim/tools/ruby/source_navigation.rb'
map \t :e <C-R>=system(SourceNavigation . ' test ' . expand("%:p"))<CR><CR>
"map \k :e <C-R>=system(SourceNavigation . ' test ' . expand("%:p"))<CR><CR>
map \s :e <C-R>=system(SourceNavigation . ' source ' . expand("%:p"))<CR><CR>
map go :e <C-R>=system(SourceNavigation . ' object_def ' . expand("%:p") . ' ' . expand("<cword>"))<CR><CR><CR>
map gy :e <C-R>=system(SourceNavigation . ' objects ' . expand("%:p"))<CR><CR>
" Execute the tests for the current source file
map <F7> <F2>\t<F5>\sG

" Code coverage
noremap <F8> :!rcov % --text-report<CR>

iabbr _bp require 'breakpoint'; breakpoint

" Unit test macros
iabbr _sh should "work"<ESC>?work<CR>cw
iabbr _ab assert_block
iabbr _ae assert_equal
iabbr _ane assert_not_equal
iabbr _aid assert_in_delta expect, actual, delta, ""
iabbr _ai assert_instance_of
iabbr _ak assert_kind_of
iabbr _am assert_match
iabbr _anm assert_match
iabbr _an assert_nil
iabbr _ann assert_not_nil
iabbr _ab assert_block
iabbr _as assert_same
iabbr _asu assert_response :success
iabbr _ans assert_not_same
iabbr _ar err = assert_raise RuntimeError doendassert_match(//i, err.message)
iabbr _art assert_redirected_to
iabbr _anr assert_nothing_raised RuntimeError  doend
iabbr _at assert_tag :tag => ''OD
iabbr _ant assert_nothing_thrown RuntimeError  doend
iabbr _asl assert_select

iabbr _er expect_and_return :mock, method, return, args<ESC>26<LEFT>
iabbr _ex expect :mock, method, args<ESC>18<LEFT>
iabbr _era expect_and_raise :mock, method, error, args<ESC>30<LEFT>

" mock abbreviations
iabbr _v verify_mocks

iabbr _setup def setup<CR><CR>end<Up>
iabbr _su def setup<CR><CR>end<Up><Tab>
iabbr _teardown def teardown<CR><CR>end<Up><Tab>
iabbr _td def teardown<CR><CR>end<Up><Tab>

iabbr hhh #<CR> HELPERS<CR><CR><BS><BS><BS>
iabbr ttt #<CR> TESTS<CR><CR><BS><BS><BS>

" Expand the words on the selected lines into unit test case stubs
noremap \ut :!ruby ~/.vim/tools/ruby/expand_test_cases.rb<CR>

" Generate rdoc and open links browser on them
noremap \rd :w<CR>:!rdoc<CR>:!links -g doc/index.html<CR>

command! Systerize %s/[()_\.]/ /g

" Stub out the beginnings of a ruby shell script
:iabbr _rubyscript #!/usr/bin/rubyrequire 'fileutils'include FileUtils$here = File.expand_path(File.dirname(__FILE__))


" Quick-fixers for converting old helpers_for_mock test code into CMock-style
" expectations.
map ex :s/expect\s*:\([^,]*\),\s*:\([^,]*\),\?\s*\(.*\)/@\1.expect.\2(\3)/<CR>
map er :s/expect_and_return\s*:\([^,]*\),\s*:\([^,]*\),\s*\([^,]*\),\?\s*\(.*\)/@\1.expect.\2(\4).returns(\3)/<CR>
map et :s/expect_and_raise\s*:\([^,]*\),\s*:\([^,]*\),\s*\([^,]*\),\?\s*\(.*\)/@\1.expect.\2(\4).raises(\3)/<CR>
iabbr _here File.expand_path(File.dirname(__FILE__))

" ERB Stuff
iabbr _t <% %><Left><Left><Left>
iabbr _et <%= %><Left><Left><Left>
map ,r i<%= %><ESC>


" vim: nowrap sw=2 sts=2 ts=8 ff=unix:
