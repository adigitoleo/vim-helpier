# Helpier


### Healthier :help for happier hacking

`Plug 'adigitoleo/vim-helpier'`


## Features

- Ensures `set nowrap` for helpfiles
- Ensures `set nolist` for helpfiles
- Automatically closes the help window any time you would jump to a normal
  buffer
- Command `:H {subject}` to open help in a floating window (neovim only)

The plugin isn't completely robust yet and
there are a few more features in development.
See below for known issues.


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

- Any commands which move the help window to a different tab will break
  everything; BAD: `:help|wincmd T`, GOOD: `:tabe|help`
- NoName buffer appears in the buffer list after using the floating window
- Loading helpfiles from saved sessions is not supported
