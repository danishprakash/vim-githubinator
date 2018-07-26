" returns line numbers for selection
function! GetRangeDelimiters() range
    let l:beg = getpos("'<")[1]
    let l:end = getpos("'>")[1]

    echo string([l:beg, l:end]) 
    return [l:beg, l:end]
endfunction 

" get remote URL from .git/config 
function! RepoConfig()
    if !isdirectory('.git')
        echo "No .git directory found"
        return
    endif

    let l:git_remote = system("cat .git/config | grep \"url\" | sed \"s/url.*://g\" | awk '{print \"https://github.com/\", $0}' | tr -d '[:blank:]' | tr -d '\n'")
    let l:beg, l:end = call GetRangeDelimiters()
    echo string(l:beg)
    echo string(l:end)
endfunction 

