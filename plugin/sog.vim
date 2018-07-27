" returns line numbers for selection
function! GetRangeDelimiters() range
    let l:beg = getpos("'<")[1]
    let l:end = getpos("'>")[1]

    return [l:beg, l:end]
endfunction 

" get remote URL from .git/config 
function! s:generate_url() range
    if !isdirectory('.git')
        echohl ErrorMsg
        echo "Githubinator: No .git directory found"
        echohl None
        return
    endif

    let l:file_name = expand("%")
    let l:beg = GetRangeDelimiters()[0]
    let l:end = GetRangeDelimiters()[1]
    let l:branch = system("git branch 2> /dev/null | awk '{print $2}' | tr -d '\n'")
    let l:git_remote = system("cat .git/config | grep \"url\" | sed \"s/url.*://g\" | awk '{print \"https://github.com/\", $0}' | tr -d '[:blank:]' | sed \"s/\.git$//g\" | tr -d '\n'")
    let l:final_url = l:git_remote . '/blob/' . l:branch . '/' . l:file_name . '#L' . l:beg . '-L' . l:end

    return l:final_url
endfunction 

function! GithubOpenURL() range
    let l:final_url = s:generate_url()

    call system('open ' . l:final_url)
endfunction

function! GithubCopyURL() range
    let l:final_url = s:generate_url()

    call system("echo " . l:final_url . " | pbcopy")
    echo "Githubinator: URL copied to clipboard."
endfunction

vnoremap gho :call GithubOpenURL()<CR>
vnoremap ghc :call GithubCopyURL()<CR>
