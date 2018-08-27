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
    let l:git_root = system("git rev-parse --show-toplevel | tr -d '\n'")
    if !isdirectory(l:git_root)
        echoerr "githubinator: No .git directory found"
        return
    endif

    let l:file_name = expand("%:t")
    let l:file_path = substitute(globpath(l:git_root, '**/' . l:file_name), l:git_root . '/', '', '')

    let l:beg = GetRangeDelimiters()[0]
    let l:end = GetRangeDelimiters()[1]

    let l:branch = system("git rev-parse --abbrev-ref HEAD 2> /dev/null | tr -d '\n'")
    let l:git_remote = fnamemodify(system("git config --get remote.origin.url | tr -d '\n'"), ':r')

    let l:final_url = l:git_remote . '/blob/' . l:branch . '/' . l:file_path . '#L' . l:beg . '-L' . l:end

    return l:final_url
endfunction

function! GithubOpenURL() range
    let l:final_url = s:generate_url()

    if executable('xdg-open')
        call system('xdg-open ' . l:final_url)
    elseif executable('open')
        call system('open ' . l:final_url)
    else
        echoerr 'githubinator: no `open` or equivalent command found. Try `ghc` to copy URL'
    endif
endfunction

function! GithubCopyURL() range
    let l:final_url = s:generate_url()

    if executable('pbcopy')
        call system("echo " . l:final_url . " | pbcopy")
    elseif executable('xsel')
        call system("echo " . l:final_url . " | xsel -b")
    else
        echoerr "githubinator: no `copy-to-clipboard` command found."
        return
    endif

    echom "Githubinator: URL copied to clipboard."
endfunction

vnoremap <silent> <Plug>(githubinator-open) :<C-U>call GithubOpenURL()<CR>
vnoremap <silent> <Plug>(githubinator-copy) :<C-U>call GithubCopyURL()<CR>

if get(g:, 'githubinator_no_default_mapping', 0) == 0
    vmap <silent> gho <Plug>(githubinator-open)
    vmap <silent> ghc <Plug>(githubinator-copy)
endif
