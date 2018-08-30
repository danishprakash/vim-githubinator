" ================================================================
" Name:         vim-githubinator: open highlighted text on Github
" Maintainer:   Danish Prakash
" HomePage:     https://github.com/prakashdanish/vim-githubinator
" License:      MIT
" ================================================================

" MIT License

" Copyright (c) 2018 Danish Prakash

" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:

" The above copyright notice and this permission notice shall be included in all
" copies or substantial portions of the Software.

" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
" SOFTWARE.


" get remote URL 
function! s:generate_url(beg, end) range
    let l:file_name = expand("%")
    let l:branch = system("git branch 2> /dev/null | awk '{print $2}' | tr -d '\n'")
    if l:branch == ''
        echohl Error | echom 'Not a git repository' | echohl None
        return ''
    endif
    " get the path relative to git repo
    let l:relative_path = system("git rev-parse --show-prefix | tr -d '\n'")
    " get remote url
    let l:git_remote = system("git remote -v | head -n 1 | awk '{print $2}' | tr -d '\n'")
    if l:git_remote == ''
        echohl Error | echom 'No remote address' | echohl None
        return ''
    endif
    " translate git protocal to https protocal
    let l:git_remote = substitute(l:git_remote, '^git@github\.com:\(.*\)$', 'https://github.com/\1', '')
    " remove .git
    let l:git_remote = substitute(l:git_remote, '.git$', '', '')
    let l:final_url = l:git_remote . '/blob/' . l:branch . '/' . l:relative_path . l:file_name . '#L' . a:beg
    if a:beg != a:end
        let l:final_url .= '-L' . a:end
    endif

    return l:final_url
endfunction

function! GithubOpenURL(beg, end) range
    let l:final_url = s:generate_url(a:beg, a:end)
    if l:final_url == ''
    endif

    if executable('xdg-open')
        call system('xdg-open ' . l:final_url)
    elseif executable('open')
        call system('open ' . l:final_url)
    else
        echoerr 'githubinator: no `open` or equivalent command found. Try `ghc` to copy URL'
    endif
endfunction

function! GithubCopyURL(beg, end) range
    let l:final_url = s:generate_url(a:beg, a:end)

    if executable('pbcopy')
        call system("echo " . l:final_url . " | pbcopy")
    elseif executable('xsel')
        call system("echo " . l:final_url . " | xsel -b")
    else
        echoerr "githubinator: no `copy-to-clipboard` command found."
        return
    endif

    echom "URL copied: " . l:final_url
endfunction

command! -range -nargs=0 GHO call GithubOpenURL(<line1>, <line2>)
command! -range -nargs=0 GHC call GithubCopyURL(<line1>, <line2>)

vnoremap <silent> <Plug>(githubinator-open) :<C-U>call GithubOpenURL(getpos("'<")[1], getpos("'>")[1])<CR>
vnoremap <silent> <Plug>(githubinator-copy) :<C-U>call GithubCopyURL(getpos("'<")[1], getpos("'>")[1])<CR>
nnoremap <silent> <Plug>(githubinator-open) :<C-U>call GithubOpenURL(line('.'), line('.')+v:count1-1)<CR>
nnoremap <silent> <Plug>(githubinator-copy) :<C-U>call GithubCopyURL(line('.'), line('.')+v:count1-1)<CR>

if !hasmapto('<Plug>(githubinator-open)', 'v')
    vmap <silent> gho <Plug>(githubinator-open)
endif
if !hasmapto('<Plug>(githubinator-copy)', 'v')
    vmap <silent> ghc <Plug>(githubinator-copy)
endif
if !hasmapto('<Plug>(githubinator-open)', 'n')
    nmap <silent> gho <Plug>(githubinator-open)
endif
if !hasmapto('<Plug>(githubinator-copy)', 'n')
    nmap <silent> ghc <Plug>(githubinator-copy)
endif
