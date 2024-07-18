# dotfiles

**Based on <https://github.com/mathiasbynens/dotfiles>**

![Screenshot of my shell prompt](https://i.imgur.com/EkEtphC.png)

> Shell prompt based on the Solarized Dark theme.  
Screenshot: <http://i.imgur.com/EkEtphC.png>  
Heavily inspired by @necolas’s prompt: <https://github.com/necolas/dotfiles>  
iTerm → Profiles → Text → use 13pt Monaco with 1.1 vertical spacing.

## Installation

### Using Git and the bootstrap script

You can clone the repository wherever you want.

```bash
git clone https://github.com/mathiasbynens/dotfiles.git && cd dotfiles && source bootstrap.sh
```

To update, `cd` into your local `dotfiles` repository and then:

```bash
git pull && source bootstrap.sh
```

### Git-free install

To install these dotfiles without Git:

```bash
cd; curl -#L https://github.com/mathiasbynens/dotfiles/tarball/main | tar -xzv --strip-components 1 --exclude={README.md,bootstrap.sh,.osx,LICENSE-MIT.txt}
```

To update later on, just run that command again.

### Specify the `$PATH`

If `~/.path` exists, it will be sourced along with the other files, before any feature testing (such as [detecting which version of `ls` is being used](https://github.com/ioiooi/dotfiles/blob/67f86947e4989fabb7681005523ce50977d356f0/.aliases#L12-L17)) takes place.

Here’s an example `~/.path` file that adds `/usr/local/bin` to the `$PATH`:

```bash
export PATH="/usr/local/bin:$PATH"
```

### Add custom commands

If `~/.extra` exists, it will be sourced along with the other files. You can use this to add a few custom commands you don’t want to commit to a public repository.
