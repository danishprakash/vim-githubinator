" returns line numbers for selection
function! GetRangeDelimiters() range
    let l:beg = getpos("'<")[1]
    let l:end = getpos("'>")[1]

    echo string([l:beg, l:end]) 
endfunction 

function! RepoConfig()
endfunction 

