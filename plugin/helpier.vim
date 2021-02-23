" Name: Helpier
" Maintainer: adigitoleo <adigitoleo@protonmail.com>
" Homepage: https://github.com/adigitoleo/vim-helpier

if exists("g:loaded_helpier") || &compatible
    finish
endif
let g:loaded_helpier = 1

" TODO:
" - remember last helptag (for this session) and reopen on next bare :help
" - allow configurable post-:help command e.g. wincmd L or wincmd J
" - extend autoclose routines to support 'nofile', e.g. :Man, and 'qf'
" - generic command for use in 'keywordprog' to open docs in floating window

" let g:helpier_buftype_matches = ["help", "quickfix", "nofile"]

let s:opt_autoclose = get(g:, "helpier_autoclose", 1)
let s:opt_btmatches = get(g:, "helpier_buftype_matches", ["help"])


if has('nvim') && exists('*nvim_open_win')
    command! -nargs=? -complete=help H call helpier#FloatingHelp(<q-args>)
endif


function! s:Helpier() abort
    let l:curwin_id = win_getid()
    if count(s:opt_btmatches, &buftype)
        let t:helpier[l:curwin_id] = [&buftype]
        let t:helpier_altwin_id = l:curwin_id
        if &list
            set nolist
            let w:helpier_did_nolist = 1
        endif
    elseif exists("t:helpier_altwin_id")
        if t:helpier_altwin_id == l:curwin_id
            if exists("w:helpier_did_nolist") && w:helpier_did_nolist
                set list
                unlet w:helpier_did_nolist
            endif
            if s:opt_autoclose && winnr("$") > 1
                if exists("t:helpier_floatwin_id")
                            \ && t:helpier_floatwin_id == l:curwin_id
                    call helpier#DestroyFloating()
                else
                    exec "close"
                endif
            endif
        endif
        if t:helpier_altwin_id == l:curwin_id || win_id2win(t:helpier_altwin_id) == 0
            if exists("t:helpier_floatwin_id") && win_id2win(t:helpier_floatwin_id) == 0
                call helpier#DestroyFloating()
            endif
            unlet t:helpier[t:helpier_altwin_id][:]
            unlet t:helpier[t:helpier_altwin_id]
            unlet t:helpier_altwin_id
        endif
    endif
endfunction


augroup helpier
    autocmd!
    autocmd VimEnter * let t:helpier = {}
    autocmd TabNew * let t:helpier = {}
    autocmd FileType help set nowrap
    autocmd BufEnter * call s:Helpier()
augroup END
