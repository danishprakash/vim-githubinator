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

" returns line numbers for selection
function! GetRangeDelimiters() range
    let l:beg = getpos("'<")[1]
    let l:end = getpos("'>")[1]

    return [l:beg, l:end]
endfunction 

" get remote URL from .git/config 
function! s:generate_url() range
    if !isdirectory('.git')
        echoerr "githubinator: No .git directory found"
        return
    endif

    let l:file_name = expand("%")
    let l:beg = GetRangeDelimiters()[0]
    let l:end = GetRangeDelimiters()[1]
    let l:branch = system("git branch 2> /dev/null | awk '{print $2}' | tr -d '\n'")
    let l:git_remote = system("cat .git/config | grep \"remote \\\"origin\\\"\" -A1 | grep \"url\" | sed \"s/url.*://g\" | awk '{print \"https://github.com/\", $0}' | tr -d '[:blank:]' | sed \"s/\.git$//g\" | tr -d '\n'")
    let l:final_url = l:git_remote . '/blob/' . l:branch . '/' . l:file_name . '#L' . l:beg . '-L' . l:end

    return l:final_url
endfunction 

function! GithubOpenURL() range
    let l:final_url = s:generate_url()

    if !executable('open')
        echoerr 'githubinator: `open` command not found. Try `ghc` to copy URL'
        return
    endif

    call system('open ' . l:final_url)
endfunction

function! GithubCopyURL() range
    let l:final_url = s:generate_url()

    if !executable('pbcopy')
        echoerr "githubinator: `pbcopy` command not found."
        return
    endif

    call system("echo " . l:final_url . " | pbcopy")
    echom "Githubinator: URL copied to clipboard."
endfunction

vnoremap gho :call GithubOpenURL()<CR>
vnoremap ghc :call GithubCopyURL()<CR>
