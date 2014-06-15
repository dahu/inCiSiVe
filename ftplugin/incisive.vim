" Data Manipulation Functions

" Rotate a data range so that
"   one, two
"   1  , 2
"   A  , B
"   C  , D
"
"   becomes
"
"  one, 1, A, C
"  two, 2, B, D
"
" Either specify the line numbers manually:
"   :13,9 call Rotate()
" OR visually select the range and type:
"   :'<,'>call Rotate()
"
function! Rotate() range
  let columns = split(getline(a:firstline), ',\s*')
  let data = map(getline(a:firstline + 1, a:lastline), 'split(v:val, ",\\s*")')
  let newdata = map(columns, '[v:val]')
  for line in data
    for cnt in range(len(newdata))
      call add(newdata[cnt], line[cnt])
    endfor
  endfor
  exe a:firstline . ',' . a:lastline . 'delete'
  call append(a:firstline - 1, map(newdata, 'join(v:val, ", ")'))
endfunction

" Navigation and Data Entry Functions

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
  " no , in front of the cursor?
  if search(',', 'cnW') != line('.')
    return "F,wC"
  " no cursor behind us?
  elseif search(',', 'bcnW') != line('.')
    return "^ct,"
  " we're in the middle of a   , CELL,
  else
    return "F,wct,"
  endif
endfunction

function! DEMaps()
  " insert mode
  inoremap <buffer> <space> ,<space>
  inoremap <buffer> <enter> <esc>jA,<space>

  " entering insert mode
  nnoremap <buffer> A A,<space>
  nnoremap <buffer> <expr> cc ChangeCell()

  " navigation
  nnoremap <buffer> <up> <up>
  nnoremap <buffer> <down> <down>
  nnoremap <buffer> <left> B
  nnoremap <buffer> <right> W
endfunction

call DEMaps()

augroup DataEntry
  au!
  au InsertCharPre <buffer> call AddHalf()
  au InsertLeave   <buffer> call CleanupLine()
augroup END
