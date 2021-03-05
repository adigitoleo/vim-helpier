" Plugin: helpier
" Maintainer: adigitoleo <vim-helpier@adigitoleo.dissimulo.com>
" Homepage: https://github.com/adigitoleo/vim-helpier

if exists("g:loaded_helpier") || &compatible
    finish
endif
let g:loaded_helpier = 1

let s:opt_commands = get(g:, "helpier_create_commands", 1)
let s:opt_btmatches = get(g:, "helpier_buftype_matches", ["help"])
let s:opt_postcmd = get(g:, "helpier_post_command", "")


if has('nvim') && exists('*nvim_open_win')
    if s:opt_commands
        command! -nargs=? -complete=help H call helpier#FloatingHelp(<q-args>)
    endif
endif


function! s:Helpier() abort
    let l:curwin_id = win_getid()
    if exists("t:helpier_altwin_id")
        if win_id2win(t:helpier_altwin_id) == 0
            if exists("t:helpier_floatwin_id")
                        \ && win_id2win(t:helpier_floatwin_id) == 0
                call helpier#DestroyFloating()
            endif
            unlet t:helpier[t:helpier_altwin_id]
            unlet t:helpier_altwin_id
        elseif t:helpier_altwin_id == l:curwin_id && get(
                    \ t:helpier, t:helpier_altwin_id, "not_a_buftype"
                    \) !=# &buftype
            if exists("w:helpier_did_nolist") && w:helpier_did_nolist
                set list
                unlet w:helpier_did_nolist
            endif
            if winnr("$") > 1
                if exists("t:helpier_floatwin_id")
                            \ && t:helpier_floatwin_id == l:curwin_id
                    call helpier#DestroyFloating()
                else
                    exec "close"
                endif
            endif
            unlet t:helpier[t:helpier_altwin_id]
            unlet t:helpier_altwin_id
        endif
    elseif count(s:opt_btmatches, &buftype)
        let t:helpier[l:curwin_id] = &buftype
        let t:helpier_altwin_id = l:curwin_id
        if &list
            set nolist
            let w:helpier_did_nolist = 1
        endif
        if !empty(s:opt_postcmd) && (
                    \ !exists("t:helpier_floatwin_id")
                    \ || t:helpier_floatwin_id != l:curwin_id
                    \)
            exec s:opt_postcmd
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
