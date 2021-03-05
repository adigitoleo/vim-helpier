" Plugin: helpier
" Maintainer: adigitoleo <vim-helpier@adigitoleo.dissimulo.com>
" Homepage: https://github.com/adigitoleo/vim-helpier


function! helpier#FloatingHelp( ... ) abort
    let l:opt_bdchars = get(g:, "helpier_border_chars",
                \ [ "=", "|", "=", "|", ":", ":", ":", ":" ])
    let l:opt_lasthelp = get(g:, "helpier_floatwin_lasthelp", 1)

    call helpier#CreateFloating('help', l:opt_bdchars)
    try
        if !a:0 || empty(a:1)
            if l:opt_lasthelp && exists("t:helpier_floatwin_lasthelp")
                exec "help " .. t:helpier_floatwin_lasthelp
            else
                exec "help"
            endif
        else
            if l:opt_lasthelp
                let t:helpier_floatwin_lasthelp = a:1
            endif
            exec "help " .. a:1
        endif
    catch /^Vim\%((\a\+)\)\=:E149/  " No help for a:arg
        call helpier#DestroyFloating()
        echoerr "Helpier: no help for " .. a:arg
    endtry
endfunction


function! helpier#CreateFloating( buftype, ... ) abort
    if exists("t:helpier_floatwin_id")
        call win_gotoid(t:helpier_floatwin_id)
        return
    endif
    let l:width = &columns > 80 ? 78 : &columns * 2/3
    let l:height = &lines * 2/3

    if a:0
        let l:bdwin = helpier#CreateFloatingCanvas(l:width + 2, l:height + 2, a:1)
    endif

    let l:buf = nvim_create_buf(v:false, v:true)
    let l:win = nvim_open_win(
                \ l:buf,
                \ 1,
                \ {
                \   'relative': 'editor',
                \   'width': l:width,
                \   'height': l:height,
                \   'row': (&lines - l:height) / 2,
                \   'col': (&columns - l:width) / 2,
                \   'style': 'minimal',
                \ }
                \)
    call nvim_win_set_option(l:win, 'winhl', 'NormalFloat:Normal')
    call nvim_tabpage_set_var(0, 'helpier_borderwin_id', l:bdwin)
    call nvim_tabpage_set_var(0, 'helpier_floatwin_id', l:win)
    call nvim_buf_set_option(l:buf, 'buftype', a:buftype)
endfunction


function! helpier#DestroyFloating() abort
    if exists("t:helpier_floatwin_id")
        if win_id2win(t:helpier_floatwin_id) > 0
            call nvim_win_close(t:helpier_floatwin_id, v:false)
        endif
        unlet t:helpier_floatwin_id
    endif
    if exists("t:helpier_borderwin_id")
        if win_id2win(t:helpier_borderwin_id) > 0
            call nvim_win_close(t:helpier_borderwin_id, v:false)
        endif
        unlet t:helpier_borderwin_id
    endif

    " Delete empty buffers that are not open in any window.
    " https://stackoverflow.com/a/10102604/12519962
    " let l:buffers = filter(range(1, bufnr('$')),
    "             \ 'empty(bufname(o :val)) &&
    "             \ bufwinnr(v:val)<0 && !getbufvar(v:val, "&mod")'
    "             \ )
    " if !empty(buffers)
    "     exec 'bw ' .. join(buffers, ' ')
    " endif
endfunction


function! helpier#CreateFloatingCanvas( width, height, bdchars ) abort
    let [l:top, l:right, l:bot, l:left, l:topl, l:topr, l:botr, l:botl] = a:bdchars
    let l:bdlines = [l:topl .. repeat(l:top, a:width - 2) .. l:topr]
    let l:bdlines += repeat([l:left .. repeat(' ', a:width - 2) .. l:right], a:height - 2)
    let l:bdlines += [l:botl .. repeat(l:bot, a:width - 2) .. l:botr]

    let l:bdbuf = nvim_create_buf(v:false, v:true)
    let l:bdwin = nvim_open_win(
                \ l:bdbuf,
                \ 0,
                \ {
                \   'relative': 'editor',
                \   'width': a:width,
                \   'height': a:height,
                \   'row': (&lines - a:height) / 2,
                \   'col': (&columns - a:width) / 2,
                \   'style': 'minimal',
                \ }
                \)
    call nvim_buf_set_option(l:bdbuf, 'modifiable', v:true)
    call nvim_buf_set_lines(l:bdbuf, 0, -1, v:false, l:bdlines)
    call nvim_buf_set_option(l:bdbuf, 'bufhidden', 'wipe')
    call nvim_buf_set_option(l:bdbuf, 'modifiable', v:false)
    call nvim_win_set_option(l:bdwin, 'winhl', 'NormalFloat:Normal')

    return l:bdwin
endfunction
