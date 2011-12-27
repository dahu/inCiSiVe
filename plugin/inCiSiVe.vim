function! AddHalf()
  let line = getline('.')
  let col = col('.')
  if (v:char =~ '\d') && (line[col-2] == v:char)
    let v:char = ".5"
  endif
endfunction

function! CleanupLine()
  let line = getline('.')
  if line =~ '[^,], *$'
    call setline('.', substitute(line, ', *$', '', ''))
  endif
endfunction

function! ChangeCell()
  let line = getline('.')
  let col = col('.')
  " check for no , from cursor onwards
  if search(',', 'cnW') != line('.')
    return "F,wC"
  elseif search(',', 'bcnW') != line('.')
    return "^ct,"
  else
    return "F,wct,"
  endif
endfunction

function! DEMaps()
  inoremap <buffer> <space> ,<space>
  inoremap <buffer> <enter> <esc>:call CleanupLine()<cr>o
  nnoremap <buffer> A A,<space>
  nnoremap <buffer> <expr> cc ChangeCell()

  " navigation
  nnoremap <buffer> <up> <up>
  nnoremap <buffer> <down> <down>
  inoremap <buffer> <enter> <esc>jA,<space>
  nnoremap <buffer> <left> B
  nnoremap <buffer> <right> W
endfunction

augroup DataEntry
  au!
  au InsertCharPre       *.csv call AddHalf()
  au InsertLeave         *.csv call CleanupLine()
  au BufNewFile,BufRead  *.csv call DEMaps()
augroup END
