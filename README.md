<h1 align="center">vim-githubinator</h1>
<p align="center">Quickly show selected text in vim on Github if a remote exists.</p>
<p align="center">
<img src="https://i.imgur.com/vNHTTcJ.gif" height="600">
</p>

## What?
This plugin helps you select some text in vim visually and then open it in Github with the selection highlighted. This was inspired from [Githubinator](https://github.com/ehamiter/GitHubinator) for sublime.

## Commands
```text
gho:      Open selected text on Github with the default
          browser using the `open` command if it is
          present, throws an error otherwise.
          
ghc:      Same as gho except it doesn't open the browser
          but rather copies the said URL to the clipboard
          using pbcopy if it is present, throws an error
          otherwise.
```

## Installation
Using [vim-zen](https://github.com/prakashdanish/vim-zen):
```vim
Plugin 'prakashdanish/vim-githubinator'
```

## Contributing
Do you want to make this better? Open an issue and/or a PR on Github. Thanks!

## License
MIT License

Copyright (c) 2018 [Danish Prakash](https://github.com/prakashdanish)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
