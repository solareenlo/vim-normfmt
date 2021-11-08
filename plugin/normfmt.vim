let g:normfmt_exec           = get(g:, 'normfmt_exec', 'normfmt')
let g:normfmt_set_equalprg   = get(g:, 'normfmt_set_equalprg', 0)
let g:normfmt_format_on_save = get(g:, 'normfmt_format_on_save', 0)

if !executable(g:normfmt_exec)
    echom 'Installing normfmt'
    !pip3 install --user normfmt
endif

function! s:Normfmt()
    normal! mq
    let l:equalprg_tmp = &equalprg
    let &equalprg = g:normfmt_exec
    silent normal! gg=G
    let &equalprg = l:equalprg_tmp
    normal! `q
    normal! zz
endfunction

if g:normfmt_set_equalprg
    let &l:equalprg = g:normfmt_exec
endif

augroup normfmt
    autocmd!
augroup END

if g:normfmt_format_on_save
    autocmd normfmt BufWritePre *.c,*.h :call s:Normfmt()
endif

autocmd normfmt FileType c,cpp command! Normfmt call s:Normfmt()

function! s:Norminette()
    let l:current_file = expand('%:p')

    belowright new
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
    call setline(1, 'Norminette result for ' . l:current_file)
    call setline(2, '')
    call setline(3, repeat('-', 80))
    execute '$read !'. 'norminette ' . l:current_file
    setlocal nomodifiable
    let l:split_height = line('$')
    if l:split_height > 30
        let l:split_height = 30
    endif
    if l:split_height < 10
        let l:split_height = 10
    endif
    silent execute 'resize ' . l:split_height
    silent normal! gg
    silent nnoremap <nowait> <buffer> q :q<CR>
endfunction

autocmd normfmt FileType c,cpp command! Norminette call s:Norminette()
