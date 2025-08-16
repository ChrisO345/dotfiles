# dotfiles

A curated collection of configuration files and scripts for my Arch Linux development environment.

This current config using gnu `stow` in order to symlink files into the home directory. These stow commands can be run from the jotfile.

---

## Installation

1. Clone the repository to your preferred directory:

```bash
git clone https://github.com/chriso345/dotfiles ~/personal/dotfiles
```

2. Using `jot` and `stow`, files can then be symlinked.

```bash
cd ~/personal/dotfiles
jot all
```

Alternatively, the `stow` commands can be run manually:

```bash
cd ~/personal/dotfiles
stow -t ~ home            # Symlink ~ files
stow -t ~/.config config  # Symlink ~/.config files
...
```

Note that there is currently no command to copy/symlink `scripts/` to a bin directory.

---

## License

This project is licensed under the MIT License. For more information, please refer to the [LICENSE](LICENSE) file.
