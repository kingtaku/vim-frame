"" Placeholder
if !has('nvim')
    finish 
endif 

if exists('g:loaded_vimframe')
    finish
endif 
let g:loaded_vimframe = 1


" Restore Session 
autocmd VimEnter * nested call <SID>EnterSetup() 
autocmd VimLeave * call <SID>LeaveSetup()

fu! s:EnterSetup()
    if (argc() == 0 && !exists("s:std_in"))
        let g:DIR_START = 1 
        if !s:RestoreSession()
            exe 'NERDTreeTabsToggle'
        endif 
    elseif argc() == 1 && isdirectory(argv()[0]) == 1 && !exists("s:std_in")
        let g:DIR_START = 1 
        exe 'cd ' . argv()[0]
        if !s:RestoreSession()
            exe 'NERDTreeTabsToggle' argv()[0] | wincmd p | ene 
        endif 
    else
        let g:DIR_START=0 
    endif 
endfu 

fu! s:RestoreSession()
    if filereadable(getcwd() . '/.Session.vim')
        exe 'so ' . getcwd() . '/.Session.vim'
        if bufexists(1)
            for l in range(1, bufnr('$'))
                if bufwinnr(l) == -1
                    exe 'sbuffer ' . l
                endif
            endfor
        endif
        exe 'NERDTreeTabsToggle' | wincmd p 
        return 1
    else 
        return 0 
    endif
endfu

fu! s:LeaveSetup()
    let currTab = tabpagenr()
    NERDTreeTabsClose 
    tabdo VTermClose 
    exe 'tabn ' . currTab 
    mksession! ./.Session.vim 
endfu 

