set shiftwidth=3
set tabstop=4
set foldmethod=marker
set expandtab
set smartindent

let g:word_count="<unknown>"
fun! WordCount()
    return g:word_count
endfun
fun! UpdateWordCount()
    let s = system("wc -w ".expand("%p"))
    let parts = split(s, ' ')
    if len(parts) > 1
        let g:word_count = parts[0]
    endif
endfun

augroup WordCounter
    au! CursorHold * call UpdateWordCount()
    au! CursorHoldI * call UpdateWordCount()
augroup END

" how eager are you? (default is 4000 ms)
set updatetime=500

" modify as you please...
set statusline=%{WordCount()}\ words

function RunTest()

    let cla = matchstr(expand("%:p"), '^.*[/\\]src[/\\]\(test\|java\)[/\\]\zs.*')
    "still need to replace /s with .s
    let class = "java org.junit.runner.JUnitCore " .  strpart(substitute(cla, "/", "\.", "g"), 0, strlen(cla) -5)

    if match(class, "Test") == -1
        let class = class . "Test"
    endif

    echo class
    echo system(class)
endfunction

map <F6> <Esc>:echo RunTest()<CR>
set spell
