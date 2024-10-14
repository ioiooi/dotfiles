# dotfiles

**Based on <https://github.com/mathiasbynens/dotfiles>**

![Screenshot of my shell prompt](https://i.imgur.com/EkEtphC.png)

> Shell prompt based on the Solarized Dark theme.  
Screenshot: <http://i.imgur.com/EkEtphC.png>  
Heavily inspired by @necolas’s prompt: <https://github.com/necolas/dotfiles>  
iTerm → Profiles → Text → use 13pt Monaco with 1.1 vertical spacing.

## Features

- **Aliases**: Shortcuts for easier navigation and common commands.
- **Bash Profile**: Sets up useful shell options like case-insensitive globbing, history appending, and autocorrect for `cd`.
- **Exports and Functions**: Environment variable exports and useful shell functions for tasks like git automation and Docker.
- **Cross-Platform**: Includes platform-specific configurations for macOS and Linux.

## Installation

1. Clone the repository to your home directory:

```sh
git clone git@github.com:ioiooi/dotfiles.git && cd dotfiles
```

2. Run the bootstrap script to copy the configuration files:

```sh
source bootstrap.sh
```

## Customization

- **Aliases**: Modify .aliases to add or change shortcuts.
- **Exports**: Use .exports to define environment variables.
- **Functions**: Extend functionality by adding custom functions in .functions.

To add machine-specific settings **without committing to the repository**, create the following files in your home directory:

- `~/.path`: For custom `$PATH` settings.
- `~/.extra`: For any other settings or commands.

## Backup

Before overwriting any existing configuration files, the `bootstrap.sh` script creates backups in `~/.dotfiles_backup`.
