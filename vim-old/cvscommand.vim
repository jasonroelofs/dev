" -*- vim -*-
" $Id: cvscommand.vim,v 1.1 2004/06/19 19:05:26 crosby Exp $
"
" Vim plugin to assist in working with CVS-controlled files.
"
" Last Change:   $Date: 2004/06/19 19:05:26 $
" Maintainer:    Bob Hiestand <bob@hiestandfamily.org>
" License:       This file is placed in the public domain.
"
" Provides functions to invoke various CVS commands on the current file.
" The output of the commands is captured in a new scratch window.  For
" convenience, if the functions are invoked on a CVS output window, the
" original file is used for the cvs operation instead after the window is
" split.  This is primarily useful when running CVSCommit and you need to see
" the changes made, so that CVSDiff is usable and shows up in another window.
"
" These functions are exported into the global environment, meaning they are
" directly accessed without prepending '<PLUG>'.  This is because the author
" directly accesses several of them without using the mappings in order to
" pass parameters.
"
" Several of these act immediately, such as
"
" CVSAdd        Performs "cvs add" on the current file.
"
" CVSAnnotate   Performs "cvs annotate" on the current file.  If not given an
"               argument, uses the most recent version of the file on the current
"               branch.  Otherwise, the argument is used as a revision number.
"
" CVSCommit     This is a two-stage command.  The first step opens a buffer to
"               accept a log message.  When that buffer is written, it is
"               automatically closed and the file is committed using the
"               information from that log message.  If the file should not be
"               committed, just destroy the log message buffer without writing
"               it.
"
" CVSDiff       With no arguments, this performs "cvs diff" on the current
"               file.  With one argument, "cvs diff" is performed on the
"               current file against the specified revision.  With two
"               arguments, cvs diff is performed between the specified
"               revisions of the current file.  This command uses the
"               'cvsdiffopt' variable to specify diff options.  If that
"               variable does not exist, then 'wbBc' is assumed.  If you wish
"               to have no options, then set it to the empty string.
"
" CVSLog        Performs "cvs log" on the current file.
"
" CVSStatus     Performs "cvs status" on the current file.
"
" CVSUpdate     Performs "cvs update" on the current file.
"
" CVSReview     Retrieves a particular version of the current file.  If no
"               argument is given, the most recent version of the file on
"               the current branch is retrieved.  The specified revision is
"               retrieved into a new buffer.
"
" CVSVimDiff    With no arguments, this prompts the user for a revision and
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
" nnoremap ,ca <Plug>CVSAdd
"
" The default mappings are as follow:
"
"   <Leader>ca CVSAdd
"   <Leader>cn CVSAnnotate
"   <Leader>cc CVSCommit
"   <Leader>cd CVSDiff
"   <Leader>cl CVSLog
"   <Leader>cr CVSReview
"   <Leader>cs CVSStatus
"   <Leader>cu CVSUpdate
"   <Leader>cv CVSVimDiff
"
" Options:
"
" Several variables are checked by the script to determine behavior as follow:
"
" CVSCommandDeleteOnHide
"   This variable, if set, causes the temporary CVS result buffers to
"   automatically delete themselves when hidden.
"
" CVSCommandSplit
"   This variable controls the orientation of the buffer split when executing
"   the CVSVimDiff command.  If set to 'horizontal', the resulting buffers
"   will be on top of one another.

if exists("loaded_cvscommand")
   finish
endif
let loaded_cvscommand = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               Utility functions                            "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Go to the directory in which the current CVS-controlled file is located.
" If this is a CVS command buffer, first switch to the original file.

function! s:CVSChangeToCurrentFileDir()
  let oldCwd=getcwd()
  let newCwd=expand("%:h")
  if strlen(newCwd) > 0
    execute 'cd' escape(newCwd, ' ')
  endif
  return oldCwd
endfunction

" Creates a new scratch buffer and captures the output from execution of the
" given command.  The name of the scratch buffer is returned.

function! s:CVSCreateCommandBuffer(cmd, cmdname, filename)
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
  if exists("g:CVSCommandDeleteOnHide")
    set bufhidden=delete
  endif
  let b:cvsOrigBuffNR=origBuffNR
  silent execute a:cmd
  $d
  1
  return currentBufName
endfunction

" Attempts to locate the original file to which CVS operations were applied.

function! s:CVSBufferCheck()
  if exists("b:cvsOrigBuffNR")
    if bufexists(b:cvsOrigBuffNR)
      " Why is this failing?
      execute "sbuffer" . b:cvsOrigBuffNR
      return 1
      "return b:cvsOrigBuffNR
    else
      " Original buffer no longer exists.
      return -1 
    endif
  else
    " No original buffer
    return 0
  endif
endfunction

" Toggles on and off the delete-on-hide behavior of CVS buffers

function! s:CVSToggleDeleteOnHide()
  if exists("g:CVSCommandDeleteOnHide")
    unlet g:CVSCommandDeleteOnHide
  else
    let g:CVSCommandDeleteOnHide=1
  endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                 CVS functions                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:CVSCommit()
  let cvsBufferCheck=s:CVSBufferCheck()
  if cvsBufferCheck ==  -1
    echo "Original buffer no longer exists, aborting."
    return ""
  endif

  let originalBuffer=bufnr("%")
  let messageFileName = escape(tempname().'*log message*', ' ?*\')
  let newCwd=expand("%:h")
  let fileName=expand("%:t")

  execute 'au BufWritePost' messageFileName 'call s:CVSFinishCommit("' . messageFileName . '", "' . newCwd . '", "' . fileName . '") | au! * ' messageFileName
  execute 'au BufDelete' messageFileName 'au! * ' messageFileName

  execute 'edit' messageFileName
  let b:cvsOrigBuffNR=originalBuffer
endfunction

function! s:CVSFinishCommit(messageFile, targetDir, targetFile)
  if filereadable(a:messageFile)
    let oldCwd=getcwd()
    if strlen(a:targetDir) > 0
      execute 'cd' escape(a:targetDir, ' ')
    endif
    let resultBufferName=s:CVSCreateCommandBuffer('0r!cvs commit -F "' . a:messageFile . '" "'. a:targetFile . '"', 'cvscommit', expand("%"))
    execute 'cd' escape(oldCwd, ' ')
    execute 'bw' escape(a:messageFile, ' *?\')
    silent execute '!rm' a:messageFile
    return resultBufferName
  else
    echo "Can't read message file; no commit is possible."
    return ""
  endif
endfunction

function! s:CVSUpdate()
  let cvsBufferCheck=s:CVSBufferCheck()
  if cvsBufferCheck == -1 
    echo "Original buffer no longer exists, aborting."
    return ""
  endif

  let oldCwd=s:CVSChangeToCurrentFileDir()
  let resultBufferName=s:CVSCreateCommandBuffer('0r!cvs update "' . expand("%") . '"', 'cvsupdate', expand("%"))
  execute 'cd' escape(oldCwd, ' ')
  return resultBufferName
endfunction

function! s:CVSDiff(...)
  let cvsBufferCheck=s:CVSBufferCheck()
  if cvsBufferCheck == -1 
    echo "Original buffer no longer exists, aborting."
    return ""
  endif

  if a:0 == 1
    let revOptions = '-r' . a:1
    let caption = 'cvsdiff ' . a:1 . ' -> current'
  elseif a:0 == 2
    let revOptions = '-r' . a:1 . ' -r' . a:2
    let caption = 'cvsdiff ' . a:1 . ' -> ' . a:2
  else
    let revOptions = ''
    let caption = 'cvsdiff'
  endif

  let diffoptionstring=' -wbBc '

  let cvsdiffopt="-1"
  if exists("g:cvsdiffopt")
    let cvsdiffopt=g:cvsdiffopt
  elseif exists("b:cvsdiffopn")
    let cvsdiffopt=b:cvsdiffopt
  elseif exists("w:cvsdiffopt")
    let cvsdiffopt=w:cvsdiffopt
  endif

  if cvsdiffopt != "-1"
    if cvsdiffopt == ""
      let diffoptionstring=""
    else
      let diffoptionstring=" -" . cvsdiffopt . " "
    endif
  endif

  let oldCwd=s:CVSChangeToCurrentFileDir()
  let resultBufferName=s:CVSCreateCommandBuffer('0r!cvs diff ' . diffoptionstring . revOptions . ' "' . expand("%") . '"', caption, expand("%"))
  set ft=diff
  execute 'cd' escape(oldCwd, ' ')
  return resultBufferName
endfunction

function! s:CVSLog()
  let cvsBufferCheck=s:CVSBufferCheck()
  if cvsBufferCheck == -1 
    echo "Original buffer no longer exists, aborting."
    return ""
  endif

  let oldCwd=s:CVSChangeToCurrentFileDir()
  let resultBufferName=s:CVSCreateCommandBuffer('0r!cvs log "' . expand("%") . '"', 'cvslog', expand("%"))
  execute 'cd' escape(oldCwd, ' ')
  return resultBufferName
endfunction

function! s:CVSAdd()
  let cvsBufferCheck=s:CVSBufferCheck()
  if cvsBufferCheck == -1 
    echo "Original buffer no longer exists, aborting."
    return ""
  endif

  let oldCwd=s:CVSChangeToCurrentFileDir()
  let resultBufferName=s:CVSCreateCommandBuffer('0r!cvs add "' . expand("%") . '"', 'cvsadd', expand("%"))
  execute 'cd' escape(oldCwd, ' ')
  return resultBufferName
endfunction

function! s:CVSAnnotate(...)
  let cvsBufferCheck=s:CVSBufferCheck()
  if cvsBufferCheck == -1 
    echo "Original buffer no longer exists, aborting."
    return ""
  endif

  let currentLine=line(".")
  let oldCwd=s:CVSChangeToCurrentFileDir()

  if a:0 == 0
    let revision=system("cvs status " . escape(expand("%"), " *?\\"))
    if(v:shell_error)
      echo "Unable to obtain status for " . expand("%")
      return
    endif
    let revision=substitute(revision, '^\_.*Working revision:\s*\(\d\+\%(\.\d\+\)\+\)\_.*$', '\1', "")
  else
    let revision=a:1
  endif

  let resultBufferName=s:CVSCreateCommandBuffer('0r!cvs -q annotate -r ' . revision . ' "' . expand("%") . '"', 'cvsannotate', expand("%"))
  exec currentLine
  execute 'cd' escape(oldCwd, ' ')
  return resultBufferName
endfunction

function! s:CVSReview(...)
  let cvsBufferCheck=s:CVSBufferCheck()
  if cvsBufferCheck == -1
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
  let oldCwd=s:CVSChangeToCurrentFileDir()
  let resultBufferName=s:CVSCreateCommandBuffer('0r!cvs -q update -p' . versionOption . ' "' . expand("%") . '"', 'cvsreview -- ' . versiontag, expand("%"))
  execute 'cd' escape(oldCwd, ' ')
  let &filetype=origFileType
  return resultBufferName
endfunction

function! s:CVSStatus()
  let cvsBufferCheck=s:CVSBufferCheck()
  if cvsBufferCheck == -1 
    echo "Original buffer no longer exists, aborting."
    return ""
  endif

  let oldCwd=s:CVSChangeToCurrentFileDir()
  let resultBufferName=s:CVSCreateCommandBuffer('0r!cvs status "' . expand("%") . '"', 'cvsstatus', expand("%"))
  execute 'cd' escape(oldCwd, ' ')
  return resultBufferName
endfunction

function! s:CVSVimDiff(...)
  let cvsBufferCheck=s:CVSBufferCheck()
  if cvsBufferCheck == -1 
    echo "Original buffer no longer exists, aborting."
    return ""
  endif

  let originalBuffer=bufnr("%")

  let isUsingSource=1

  if(a:0 == 0)
    let resultBufferName=s:CVSReview()
  elseif(a:0 == 1)
    let resultBufferName=s:CVSReview(a:1)
  else
    let isUsingSource=0
    let resultBufferName=s:CVSReview(a:1)
    set buftype=
    w!
    execute "au BufDelete" resultBufferName "call delete(\"".resultBufferName ."\") | au! BufDelete" resultBufferName
    execute "buffer" originalBuffer
    let originalBuffer=bufnr(resultBufferName)
    let resultBufferName=s:CVSReview(a:2)
  endif

  if isUsingSource
    " Provide for restoring state of original buffer
    execute "au BufDelete" resultBufferName "call setbufvar(" b:cvsOrigBuffNR ", \"&diff\", 0)"
    execute "au BufDelete" resultBufferName "call setbufvar(" b:cvsOrigBuffNR ", \"&foldcolumn\", 0)"
    execute "au BufDelete" resultBufferName "au! BufDelete " escape(resultBufferName, ' *?\')
  endif

  let splitModifier="vertical"
  if exists("g:CVSCommandSplit")
    if g:CVSCommandSplit == "vertical"
      let splitModifier="vertical"
    elseif g:CVSCommandSplit == "horizontal"
      let splitModifier=""
    endif
  endif

  execute "silent leftabove" splitModifier "diffsplit" escape(bufname(originalBuffer), ' *?\')
  execute bufwinnr(originalBuffer) "wincmd w"
  return resultBufferName
endfunction

com! CVSCommit call s:CVSCommit()
com! CVSUpdate call s:CVSUpdate()
com! -nargs=* CVSDiff call s:CVSDiff(<f-args>)
com! CVSLog call s:CVSLog()
com! CVSAdd call s:CVSAdd()
com! -nargs=? CVSAnnotate call s:CVSAnnotate(<f-args>)
com! -nargs=? CVSReview call s:CVSReview(<f-args>)
com! CVSStatus call s:CVSStatus()
com! -nargs=* CVSVimDiff call s:CVSVimDiff(<f-args>)

nnoremap <unique> <Plug>CVSAdd :CVSAdd<CR>
nnoremap <unique> <Plug>CVSAnnotate :CVSAnnotate<CR>
nnoremap <unique> <Plug>CVSCommit :CVSCommit<CR>
nnoremap <unique> <Plug>CVSDiff :CVSDiff<CR>
nnoremap <unique> <Plug>CVSLog :CVSLog<CR>
nnoremap <unique> <Plug>CVSReview :CVSReview<CR>
nnoremap <unique> <Plug>CVSStatus :CVSStatus<CR>
nnoremap <unique> <Plug>CVSUpdate :CVSUpdate<CR>
nnoremap <unique> <Plug>CVSVimDiff :CVSVimDiff<CR>

if !hasmapto('<Plug>CVSAdd')
  nmap <unique> <Leader>ca <Plug>CVSAdd
endif
if !hasmapto('<Plug>CVSAnnotate')
  nmap <unique> <Leader>cn <Plug>CVSAnnotate
endif
if !hasmapto('<Plug>CVSCommit')
  nmap <unique> <Leader>cc <Plug>CVSCommit
endif
if !hasmapto('<Plug>CVSDiff')
  nmap <unique> <Leader>cd <Plug>CVSDiff
endif
if !hasmapto('<Plug>CVSLog')
  nmap <unique> <Leader>cl <Plug>CVSLog
endif
if !hasmapto('<Plug>CVSReview')
  nmap <unique> <Leader>cr <Plug>CVSReview
endif
if !hasmapto('<Plug>CVSStatus')
  nmap <unique> <Leader>cs <Plug>CVSStatus
endif
if !hasmapto('<Plug>CVSUpdate')
  nmap <unique> <Leader>cu <Plug>CVSUpdate
endif
if !hasmapto('<Plug>CVSVimDiff')
  nmap <unique> <Leader>cv <Plug>CVSVimDiff
endif

amenu <silent> &Plugin.CVS.&Add      <Plug>CVSAdd
amenu <silent> &Plugin.CVS.A&nnotate <Plug>CVSAnnotate
amenu <silent> &Plugin.CVS.&Commit   <Plug>CVSCommit
amenu <silent> &Plugin.CVS.&Diff     <Plug>CVSDiff
amenu <silent> &Plugin.CVS.&Log      <Plug>CVSLog
amenu <silent> &Plugin.CVS.&Review   <Plug>CVSReview
amenu <silent> &Plugin.CVS.&Status   <Plug>CVSStatus
amenu <silent> &Plugin.CVS.&Update   <Plug>CVSUpdate
amenu <silent> &Plugin.CVS.&VimDiff  <Plug>CVSVimDiff
