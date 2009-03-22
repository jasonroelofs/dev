" -*- vim -*-
" $Id: svncommand.vim,v 1.1 2004/06/19 19:05:26 crosby Exp $
"
" Vim plugin to assist in working with SVN-controlled files.
"
" Last Change:   $Date: 2004/06/19 19:05:26 $
" Maintainer:    Bob Hiestand <bob@hiestandfamily.org>
" License:       This file is placed in the public domain.
"
" Provides functions to invoke various SVN commands on the current file.
" The output of the commands is captured in a new scratch window.  For
" convenience, if the functions are invoked on a SVN output window, the
" original file is used for the svn operation instead after the window is
" split.  This is primarily useful when running SVNCommit and you need to see
" the changes made, so that SVNDiff is usable and shows up in another window.
"
" These functions are exported into the global environment, meaning they are
" directly accessed without prepending '<PLUG>'.  This is because the author
" directly accesses several of them without using the mappings in order to
" pass parameters.
"
" Several of these act immediately, such as
"
" SVNAdd        Performs "svn add" on the current file.
"
" SVNAnnotate   Performs "svn annotate" on the current file.  If not given an
"               argument, uses the most recent version of the file on the current
"               branch.  Otherwise, the argument is used as a revision number.
"
" SVNCommit     This is a two-stage command.  The first step opens a buffer to
"               accept a log message.  When that buffer is written, it is
"               automatically closed and the file is committed using the
"               information from that log message.  If the file should not be
"               committed, just destroy the log message buffer without writing
"               it.
"
" SVNDiff       With no arguments, this performs "svn diff" on the current
"               file.  With one argument, "svn diff" is performed on the
"               current file against the specified revision.  With two
"               arguments, svn diff is performed between the specified
"               revisions of the current file.  This command uses the
"               'svndiffopt' variable to specify diff options.  If that
"               variable does not exist, then 'wbBc' is assumed.  If you wish
"               to have no options, then set it to the empty string.
"
" SVNLog        Performs "svn log" on the current file.
"
" SVNStatus     Performs "svn status" on the current file.
"
" SVNUpdate     Performs "svn update" on the current file.
"
" SVNReview     Retrieves a particular version of the current file.  If no
"               argument is given, the most recent version of the file on
"               the current branch is retrieved.  The specified revision is
"               retrieved into a new buffer.
"
" SVNVimDiff    With no arguments, this prompts the user for a revision and
"               then uses vimdiff to display the differences between the current
"               file and the specified revision.  If no revision is specified,
"               the most recent version of the file on the current branch is used.
"               With one argument, that argument is used as the revision as
"               above.  With two arguments, the differences between the two
"               revisions is displayed using vimdiff.
"
"               With either zero or one argument, the original buffer is used
"               to perform the vimdiff.  When the other buffer is closed, the
"               original buffer will be returned to normal mode.
"
" By default, a mapping is defined for each command.  User-provided mappings
" can be used instead by mapping to <Plug>CommandName, for instance:
"
" nnoremap ,ca <Plug>SVNAdd
"
" The default mappings are as follow:
"
"   <Leader>ca SVNAdd
"   <Leader>cn SVNAnnotate
"   <Leader>cc SVNCommit
"   <Leader>cd SVNDiff
"   <Leader>cl SVNLog
"   <Leader>cr SVNReview
"   <Leader>cs SVNStatus
"   <Leader>cu SVNUpdate
"   <Leader>cv SVNVimDiff
"
" Options:
"
" Several variables are checked by the script to determine behavior as follow:
"
" SVNCommandDeleteOnHide
"   This variable, if set, causes the temporary SVN result buffers to
"   automatically delete themselves when hidden.
"
" SVNCommandSplit
"   This variable controls the orientation of the buffer split when executing
"   the SVNVimDiff command.  If set to 'horizontal', the resulting buffers
"   will be on top of one another.

if exists("loaded_svncommand")
   finish
endif
let loaded_svncommand = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               Utility functions                            "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Go to the directory in which the current SVN-controlled file is located.
" If this is a SVN command buffer, first switch to the original file.

function! s:SVNChangeToCurrentFileDir()
  let oldCwd=getcwd()
  let newCwd=expand("%:h")
  if strlen(newCwd) > 0
    execute 'cd' escape(newCwd, ' ')
  endif
  return oldCwd
endfunction

" Creates a new scratch buffer and captures the output from execution of the
" given command.  The name of the scratch buffer is returned.

function! s:SVNCreateCommandBuffer(cmd, cmdname, filename)
  let origBuffNR=bufnr("%")
  let bufName='*' . a:cmdname . '*' . ' ' . a:filename
  let counter=0
  let currentBufName = bufName
  while buflisted(currentBufName)
    let counter=counter + 1
    let currentBufName=bufName . ' (' . counter . ')'
  endwhile
  let currentBufName = escape(currentBufName, ' *\')
  execute 'edit' currentBufName
  set buftype=nofile
  set noswapfile
  set filetype=
  if exists("g:SVNCommandDeleteOnHide")
    set bufhidden=delete
  endif
  let b:svnOrigBuffNR=origBuffNR
  silent execute a:cmd
  $d
  1
  return currentBufName
endfunction

" Attempts to locate the original file to which SVN operations were applied.

function! s:SVNBufferCheck()
  if exists("b:svnOrigBuffNR")
    if bufexists(b:svnOrigBuffNR)
      " Why is this failing?
      execute "sbuffer" . b:svnOrigBuffNR
      return 1
      "return b:svnOrigBuffNR
    else
      " Original buffer no longer exists.
      return -1 
    endif
  else
    " No original buffer
    return 0
  endif
endfunction

" Toggles on and off the delete-on-hide behavior of SVN buffers

function! s:SVNToggleDeleteOnHide()
  if exists("g:SVNCommandDeleteOnHide")
    unlet g:SVNCommandDeleteOnHide
  else
    let g:SVNCommandDeleteOnHide=1
  endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                 SVN functions                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:SVNCommit()
  let svnBufferCheck=s:SVNBufferCheck()
  if svnBufferCheck ==  -1
    echo "Original buffer no longer exists, aborting."
    return ""
  endif

  let originalBuffer=bufnr("%")
  let messageFileName = escape(tempname().'*log message*', ' ?*\')
  let newCwd=expand("%:h")
  let fileName=expand("%:t")

  execute 'au BufWritePost' messageFileName 'call s:SVNFinishCommit("' . messageFileName . '", "' . newCwd . '", "' . fileName . '") | au! * ' messageFileName
  execute 'au BufDelete' messageFileName 'au! * ' messageFileName

  execute 'edit' messageFileName
  let b:svnOrigBuffNR=originalBuffer
endfunction

function! s:SVNFinishCommit(messageFile, targetDir, targetFile)
  if filereadable(a:messageFile)
    let oldCwd=getcwd()
    if strlen(a:targetDir) > 0
      execute 'cd' escape(a:targetDir, ' ')
    endif
    let resultBufferName=s:SVNCreateCommandBuffer('0r!svn commit -F "' . a:messageFile . '" "'. a:targetFile . '"', 'svncommit', expand("%"))
    execute 'cd' escape(oldCwd, ' ')
    execute 'bw' escape(a:messageFile, ' *?\')
    silent execute '!rm' a:messageFile
    return resultBufferName
  else
    echo "Can't read message file; no commit is possible."
    return ""
  endif
endfunction

function! s:SVNUpdate()
  let svnBufferCheck=s:SVNBufferCheck()
  if svnBufferCheck == -1 
    echo "Original buffer no longer exists, aborting."
    return ""
  endif

  let oldCwd=s:SVNChangeToCurrentFileDir()
  let resultBufferName=s:SVNCreateCommandBuffer('0r!svn update "' . expand("%") . '"', 'svnupdate', expand("%"))
  execute 'cd' escape(oldCwd, ' ')
  return resultBufferName
endfunction

function! s:SVNDiff(...)
  let svnBufferCheck=s:SVNBufferCheck()
  if svnBufferCheck == -1 
    echo "Original buffer no longer exists, aborting."
    return ""
  endif

  if a:0 == 1
    let revOptions = '-r' . a:1
    let caption = 'svndiff ' . a:1 . ' -> current'
  elseif a:0 == 2
    let revOptions = '-r' . a:1 . ' -r' . a:2
    let caption = 'svndiff ' . a:1 . ' -> ' . a:2
  else
    let revOptions = ''
    let caption = 'svndiff'
  endif

  let diffoptionstring=''

  let svndiffopt="-1"
  if exists("g:svndiffopt")
    let svndiffopt=g:svndiffopt
  elseif exists("b:svndiffopn")
    let svndiffopt=b:svndiffopt
  elseif exists("w:svndiffopt")
    let svndiffopt=w:svndiffopt
  endif

  if svndiffopt != "-1"
    if svndiffopt == ""
      let diffoptionstring=""
    else
      let diffoptionstring=" -" . svndiffopt . " "
    endif
  endif

  let oldCwd=s:SVNChangeToCurrentFileDir()
  let resultBufferName=s:SVNCreateCommandBuffer('0r!svn diff ' . diffoptionstring . revOptions . ' "' . expand("%") . '"', caption, expand("%"))
  set ft=diff
  execute 'cd' escape(oldCwd, ' ')
  return resultBufferName
endfunction

function! s:SVNLog()
  let svnBufferCheck=s:SVNBufferCheck()
  if svnBufferCheck == -1 
    echo "Original buffer no longer exists, aborting."
    return ""
  endif

  let oldCwd=s:SVNChangeToCurrentFileDir()
  let resultBufferName=s:SVNCreateCommandBuffer('0r!svn log "' . expand("%") . '"', 'svnlog', expand("%"))
  execute 'cd' escape(oldCwd, ' ')
  return resultBufferName
endfunction

function! s:SVNAdd()
  let svnBufferCheck=s:SVNBufferCheck()
  if svnBufferCheck == -1 
    echo "Original buffer no longer exists, aborting."
    return ""
  endif

  let oldCwd=s:SVNChangeToCurrentFileDir()
  let resultBufferName=s:SVNCreateCommandBuffer('0r!svn add "' . expand("%") . '"', 'svnadd', expand("%"))
  execute 'cd' escape(oldCwd, ' ')
  return resultBufferName
endfunction

function! s:SVNAnnotate(...)
  let svnBufferCheck=s:SVNBufferCheck()
  if svnBufferCheck == -1 
    echo "Original buffer no longer exists, aborting."
    return ""
  endif

  let currentLine=line(".")
  let oldCwd=s:SVNChangeToCurrentFileDir()

  if a:0 == 0
    let revision=system("svn blame " . escape(expand("%"), " *?\\"))
    if(v:shell_error)
      echo "Unable to obtain status for " . expand("%")
      return
    endif
    let revision=substitute(revision, '^\_.*Working revision:\s*\(\d\+\%(\.\d\+\)\+\)\_.*$', '\1', "")
  else
    let revision=a:1
  endif

  "let resultBufferName=s:SVNCreateCommandBuffer('0r!svn -q blame -r ' . revision . ' "' . expand("%") . '"', 'svnannotate', expand("%"))
  let resultBufferName=s:SVNCreateCommandBuffer('0r!svn -q blame -r HEAD "' . expand("%") . '"', 'svnannotate', expand("%"))
  exec currentLine
  execute 'cd' escape(oldCwd, ' ')
  return resultBufferName
endfunction

function! s:SVNReview(...)
  let svnBufferCheck=s:SVNBufferCheck()
  if svnBufferCheck == -1
    echo "Original buffer no longer exists, aborting."
    return ""
  endif

  if a:0 == 0
    let versiontag="current"
    let versionOption=""
  else
    let versiontag=a:1
    let versionOption=" -r " . versiontag . " "
  endif

  let origFileType=&filetype
  let oldCwd=s:SVNChangeToCurrentFileDir()
  let resultBufferName=s:SVNCreateCommandBuffer('0r!svn -q update -p' . versionOption . ' "' . expand("%") . '"', 'svnreview -- ' . versiontag, expand("%"))
  execute 'cd' escape(oldCwd, ' ')
  let &filetype=origFileType
  return resultBufferName
endfunction

function! s:SVNStatus()
  let svnBufferCheck=s:SVNBufferCheck()
  if svnBufferCheck == -1 
    echo "Original buffer no longer exists, aborting."
    return ""
  endif

  let oldCwd=s:SVNChangeToCurrentFileDir()
  let resultBufferName=s:SVNCreateCommandBuffer('0r!svn status "' . expand("%") . '"', 'svnstatus', expand("%"))
  execute 'cd' escape(oldCwd, ' ')
  return resultBufferName
endfunction

function! s:SVNVimDiff(...)
  let svnBufferCheck=s:SVNBufferCheck()
  if svnBufferCheck == -1 
    echo "Original buffer no longer exists, aborting."
    return ""
  endif

  let originalBuffer=bufnr("%")

  let isUsingSource=1

  if(a:0 == 0)
    let resultBufferName=s:SVNReview()
  elseif(a:0 == 1)
    let resultBufferName=s:SVNReview(a:1)
  else
    let isUsingSource=0
    let resultBufferName=s:SVNReview(a:1)
    set buftype=
    w!
    execute "au BufDelete" resultBufferName "call delete(\"".resultBufferName ."\") | au! BufDelete" resultBufferName
    execute "buffer" originalBuffer
    let originalBuffer=bufnr(resultBufferName)
    let resultBufferName=s:SVNReview(a:2)
  endif

  if isUsingSource
    " Provide for restoring state of original buffer
    execute "au BufDelete" resultBufferName "call setbufvar(" b:svnOrigBuffNR ", \"&diff\", 0)"
    execute "au BufDelete" resultBufferName "call setbufvar(" b:svnOrigBuffNR ", \"&foldcolumn\", 0)"
    execute "au BufDelete" resultBufferName "au! BufDelete " escape(resultBufferName, ' *?\')
  endif

  let splitModifier="vertical"
  if exists("g:SVNCommandSplit")
    if g:SVNCommandSplit == "vertical"
      let splitModifier="vertical"
    elseif g:SVNCommandSplit == "horizontal"
      let splitModifier=""
    endif
  endif

  execute "silent leftabove" splitModifier "diffsplit" escape(bufname(originalBuffer), ' *?\')
  execute bufwinnr(originalBuffer) "wincmd w"
  return resultBufferName
endfunction

com! SVNCommit call s:SVNCommit()
com! SVNUpdate call s:SVNUpdate()
com! -nargs=* SVNDiff call s:SVNDiff(<f-args>)
com! SVNLog call s:SVNLog()
com! SVNAdd call s:SVNAdd()
com! -nargs=? SVNAnnotate call s:SVNAnnotate(<f-args>)
com! -nargs=? SVNReview call s:SVNReview(<f-args>)
com! SVNStatus call s:SVNStatus()
com! -nargs=* SVNVimDiff call s:SVNVimDiff(<f-args>)

nnoremap <unique> <Plug>SVNAdd :SVNAdd<CR>
nnoremap <unique> <Plug>SVNAnnotate :SVNAnnotate<CR>
nnoremap <unique> <Plug>SVNCommit :SVNCommit<CR>
nnoremap <unique> <Plug>SVNDiff :SVNDiff<CR>
nnoremap <unique> <Plug>SVNLog :SVNLog<CR>
nnoremap <unique> <Plug>SVNReview :SVNReview<CR>
nnoremap <unique> <Plug>SVNStatus :SVNStatus<CR>
nnoremap <unique> <Plug>SVNUpdate :SVNUpdate<CR>
nnoremap <unique> <Plug>SVNVimDiff :SVNVimDiff<CR>

if !hasmapto('<Plug>SVNAdd')
  nmap <unique> <Leader>sa <Plug>SVNAdd
endif
if !hasmapto('<Plug>SVNAnnotate')
  nmap <unique> <Leader>sn <Plug>SVNAnnotate
endif
if !hasmapto('<Plug>SVNCommit')
  nmap <unique> <Leader>sc <Plug>SVNCommit
endif
if !hasmapto('<Plug>SVNDiff')
  nmap <unique> <Leader>sd <Plug>SVNDiff
endif
if !hasmapto('<Plug>SVNLog')
  nmap <unique> <Leader>sl <Plug>SVNLog
endif
if !hasmapto('<Plug>SVNReview')
  nmap <unique> <Leader>sr <Plug>SVNReview
endif
if !hasmapto('<Plug>SVNStatus')
  nmap <unique> <Leader>ss <Plug>SVNStatus
endif
if !hasmapto('<Plug>SVNUpdate')
  nmap <unique> <Leader>su <Plug>SVNUpdate
endif
if !hasmapto('<Plug>SVNVimDiff')
  nmap <unique> <Leader>sv <Plug>SVNVimDiff
endif

amenu <silent> &Plugin.SVN.&Add      <Plug>SVNAdd
amenu <silent> &Plugin.SVN.A&nnotate <Plug>SVNAnnotate
amenu <silent> &Plugin.SVN.&Commit   <Plug>SVNCommit
amenu <silent> &Plugin.SVN.&Diff     <Plug>SVNDiff
amenu <silent> &Plugin.SVN.&Log      <Plug>SVNLog
amenu <silent> &Plugin.SVN.&Review   <Plug>SVNReview
amenu <silent> &Plugin.SVN.&Status   <Plug>SVNStatus
amenu <silent> &Plugin.SVN.&Update   <Plug>SVNUpdate
amenu <silent> &Plugin.SVN.&VimDiff  <Plug>SVNVimDiff
