" ================================================================
" Name:         vim-githubinator: open highlighted text on Github
" Maintainer:   Danish Prakash
" HomePage:     https://github.com/danishprakash/vim-githubinator
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
function! s:get_range_delimiters()
    let l:beg = getpos("'<")[1]
    let l:end = getpos("'>")[1]

    return [l:beg, l:end]
endfunction

" get remote URL from .git/config
function! s:generate_url()
    let l:root_dir = system('git rev-parse --show-toplevel')
    if v:shell_error != 0
        echoerr printf('githubinator: %s is NOT managed by git', getcwd())
        return
    endif

    " In order to support relative filepath, convert full path and remove the git root path in it.
    let l:file_name = expand('%:p')[len(root_dir) : -1]
    let [l:beg, l:end] = s:get_range_delimiters()

    " Remove `tags/`.
    let l:branch = system('git name-rev --name-only HEAD')
    let l:branch = substitute(l:branch, '^tags//\|\n', '', '')

    " Change URL scheme to https.
    " Remove `.git` and newline.
    " Change `:` to `/` (in case of ssh remote).
    let l:remote = system('git config remote.origin.url')
    let l:remote = substitute(l:remote, 'git@\|git:', 'https://', 'g')
    let l:remote = substitute(l:remote, '\.git.$', '', '')
    echom string(l:remote)
    let l:remote = substitute(l:remote, ':\([^/]\)', '/\1', 'g')
    echom string(l:remote)

    " Build final URL.
    return printf('%s/blob/%s/%s#L%d-L%d', l:remote, l:branch, l:file_name, l:beg, l:end)
endfunction

function! s:github_open_url()
    let l:final_url = s:generate_url()

    if executable('xdg-open')
        call system('xdg-open ' . l:final_url)
    elseif executable('open')
        call system('open ' . l:final_url)
    else
        echoerr 'githubinator: no `open` or equivalent command found. Try `ghc` to copy URL'
    endif
endfunction

function! s:github_copy_url()
    let l:final_url = s:generate_url()

    if executable('pbcopy')
        call system('echo ' . l:final_url . ' | pbcopy')
    elseif executable('xsel')
        call system('echo ' . l:final_url . ' | xsel -b')
    else
        echoerr 'githubinator: no `copy-to-clipboard` command found.'
        return
    endif

    echom 'Githubinator: URL copied to clipboard.'
endfunction

vnoremap <silent> <Plug>(githubinator-open) :<C-U>call <SID>github_open_url()<CR>
vnoremap <silent> <Plug>(githubinator-copy) :<C-U>call <SID>github_copy_url()<CR>

if get(g:, 'githubinator_no_default_mapping', 0) == 0
    vmap <silent> gho <Plug>(githubinator-open)
    vmap <silent> ghc <Plug>(githubinator-copy)
endif
