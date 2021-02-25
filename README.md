# helpier


### Healthier :help for happier hacking

`Plug 'adigitoleo/vim-helpier'`


## Features

- Ensures `set nowrap` for helpfiles
- Ensures `set nolist` for helpfiles
- Automatically closes the help window any time you would jump to a normal
  buffer (e.g. with `:b #` or CTRL-O)
- Optionally extend the above behaviour to other buffer types (experimental)
- Command `:H {subject}` to open help in a floating window (neovim only)

Please read `:h helpier` after installing the plugin for more information on
options and usage.


## Installation

If you use a vim plugin manager (recommended),
consult the relevant documentation.
Here are some links to popular plugin managers:
- [Pathogen]
- [NeoBundle]
- [Vundle]
- [vim-plug]

Alternatively, for modern (neo)vim versions,
you can use the built-in package management.
Make sure `:echo has('packages')` returns `1` and
read `:help packages` for instructions.

[Pathogen]: https://github.com/tpope/vim-pathogen
[NeoBundle]: https://github.com/Shougo/neobundle.vim
[Vundle]: https://github.com/gmarik/vundle
[vim-plug]: https://github.com/junegunn/vim-plug


## Known Issues

- Doesn't close the quickfix window unless it has lost focus at least once
- Unlisted \[No Name\] buffer appears in `:ls!` after using the floating window
- The hl-NormalFloat highlight color occasionally won't be set for the
  floating window (usually fixed after restarting vim)
- Loading helpfiles from saved sessions is untested and probably won't work

## TODO

- improve support for quickfix and add support for :Man
- generic command for use in 'keywordprog' to open docs in floating window
