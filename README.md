<h1 align="center">vim-githubinator</h1>
<p align="center">Quickly show selected text in vim on Github if a remote exists.</p>
<p align="center">
<img src="https://i.imgur.com/vNHTTcJ.gif" height="600">
</p>

## What?
This plugin helps you select some text in vim visually and then open it in Github or other remote repository with the selection highlighted.
This was inspired from [Githubinator](https://github.com/ehamiter/GitHubinator) for sublime.

## Default commands
```text
gho
    Open selected text on git remote repository with the default
    browser using the `open` or `xdg-open` command if it is present,
    throws an error otherwise.

ghc
    Same as gho except it doesn't open the
    browser but rather copies the said URL to the clipboard using
    pbcopy if it is present, throws an error otherwise.
```

## Installation
Using [vim-zen](https://github.com/danishprakash/vim-zen):
```vim
Plugin 'danishprakash/vim-githubinator'
```

## Contributing
Do you want to make this better? Open an issue and/or a PR on Github. Thanks!

## License
MIT License

Copyright (c) 2018 [Danish Prakash](https://github.com/danishprakash)
