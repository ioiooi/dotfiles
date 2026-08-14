# dotfiles

**Based on <https://github.com/mathiasbynens/dotfiles>**

![Screenshot of my shell prompt](https://i.imgur.com/EkEtphC.png)

> Shell prompt based on the Solarized Dark theme.
> Heavily inspired by @necolas's prompt: <https://github.com/necolas/dotfiles>
> Set the terminal font to a Nerd Font (`install_nerd_fonts.sh` installs one).

Bash configuration for macOS and Ubuntu, plus one-shot setup scripts for a
fresh machine.

## Layout

| Path | What it is |
| --- | --- |
| `.bashrc`, `.bash_profile` | Entry points. `.bash_profile` sources everything else. |
| `.bash_prompt` | Solarized Dark prompt with git branch and dirty-state markers. |
| `.aliases`, `.exports`, `.functions` | Shortcuts, environment variables, shell functions. |
| `git/.gitconfig` | Git aliases and settings. Carries no identity, see below. |
| `git/.gitignore` | Global ignore list, deployed to `~/.gitignore`. |
| `git/.git-templates/` | Hooks installed into every new repo via `init.templatedir`. |
| `ubuntu/`, `mac/` | Per-OS setup scripts and desktop configuration. |
| `bootstrap.sh` | Copies the above into `$HOME`. |

## Installation

Clone the repository and run the bootstrap script:

```sh
git clone git@github.com:ioiooi/dotfiles.git && cd dotfiles
./bootstrap.sh
```

Run it, do not `source` it. The script sets strict shell options and exits on
failure, both of which would leak into an interactive shell.

Then create `~/.gitconfig.local` with your git identity (see below) and open a
new shell to pick up the changes.

Bootstrap **copies** files rather than symlinking them, so editing `~/.aliases`
does not change the copy in this repository. Edit the repository and run
`./bootstrap.sh` again.

## Git identity

`git/.gitconfig` deliberately contains no `[user]` name or email, because this
repository is public. It sets `user.useConfigOnly`, so git refuses to commit
rather than guessing an identity, and includes `~/.gitconfig.local` for the
real values.

Create that file on each machine:

```ini
[user]

	name = Your Name
	email = you@example.com
```

For a different identity per directory, add a conditional include. Two things
to get right: `includeIf` accepts only a `path`, never inline keys (they are
silently ignored), so the override needs a file of its own; and it has to come
*after* the `[user]` block, because the last value read wins.

```ini
[user]

	name = Your Name
	email = work@example.com

# After [user], so the personal address wins under ~/Projects/private.
[includeIf "gitdir:~/Projects/private/"]

	path = ~/.gitconfig.private
```

```ini
# ~/.gitconfig.private
[user]

	email = you@personal.example
```

The included file can live anywhere. Keeping it in `$HOME` next to
`~/.gitconfig.local` means one glob (`~/.gitconfig*`) covers both when you back
them up.

If `~/.gitconfig.local` is missing, git fails with `Author identity unknown`
instead of committing under a wrong address.

## Machine-local files

These live in `$HOME`, are never copied or overwritten by `bootstrap.sh`, and
are not in this repository:

| File | Purpose |
| --- | --- |
| `~/.path` | Additions to `$PATH`. |
| `~/.extra` | Anything machine-specific: tool paths, work aliases, secrets. |
| `~/.gitconfig.local` | Git identity and any private credential helpers. |
| `~/.gitconfig.private` | Per-directory identity override, if you use one. |

`bootstrap.sh` overwrites `~/.bash_profile`, so put machine-specific shell
setup in `~/.extra` instead. Installers that append to `~/.bash_profile`
(JetBrains Toolbox, for one) lose their changes on the next bootstrap run.

Nothing backs these files up. Keep a copy somewhere off this machine.

## Setting up a new machine

Runnable from anywhere in the repository:

```sh
./ubuntu/setup.sh   # apt repositories, packages, applications, snaps, fonts
./mac/setup.sh      # Homebrew, packages, casks, fonts
```

Desktop configuration (keyboard layout, workspace shortcuts) is part of
`ubuntu/setup.sh` and runs once, not on every shell start.

## Notable commands

| Command | What it does |
| --- | --- |
| `mkd <dir>` | Create a directory and enter it. |
| `fs [path…]` | Human-readable size of files and directories. |
| `tre [path…]` | `tree` with hidden files, ignoring `.git` and friends, piped to `less`. |
| `wdiff <a> <b>` | Word-level coloured diff via `git diff --no-index`. |
| `myip` / `localip` | Public and local IP address. |
| `gcm <message>` | `git commit -m`. |
| `git_amend_to_commit <ref>` | Fold staged changes into an earlier commit. |
| `dexec <container> [cmd…]` | Run a command (or a shell) in a Docker container. |
| `docker-stop` | Stop all running containers. |
| `docker-purge` | Remove all Docker data. Asks first. |

## Customization

Add aliases to `.aliases`, environment variables to `.exports`, and functions to
`.functions`, then run `./bootstrap.sh` again.

## Backup

`bootstrap.sh` backs up every file it is about to overwrite into a timestamped
directory under `~/.dotfiles_backup/`, for example
`~/.dotfiles_backup/20260814_134251/`. Files it does not deploy, including the
three machine-local ones above, are never backed up.
