# How I use my Version of this...

I store my settings in OneDrive, typically this results in this path:-

C:\Users\daves\OneDrive\zzz_windowsSetup\Machines\DESKTOP-4790K\dotfiles-windows

The zzz_windows setup folders are created by the choco-windows-sync scripts, which creates a different packages.config file for each machine, so I can have different programs, this script is a work in progress and I've not tried this for multiple machines, but I'm thinking of branching this repo for that purpose. Sorry if this don't make sense, will rewrite this later when I have more time.

I've added Shortscuts to BAT files, which trigger ps1 files, this overcomes the Windows ExecutionPolicy settings on your machine, on a per script basis.

At this time, it seems like the ps1 files in your Documents/WindowsPowerShell/ need to be run manually.

It's possible I might write my own deployment script, as the work flow I want needs reverse updates, so I can save a Windows Profile to github or a private repo.

More to come when I get time...

# David Hazeldens dotfiles for Windows

A collection of PowerShell files for Windows, including common application installation through `Chocolatey` and `npm`, and developer-minded Windows configuration defaults.

Are you a Mac user? Check out my [dotfiles](https://DavidHazeldenUK/dotfiles-windows/dotfiles) repository.

## Installation

### Using Git and the bootstrap script

You can clone the repository wherever you want. (I like to keep it in `~\Projects\dotfiles-windows`.) The bootstrapper script will copy the files to your PowerShell Profile folder.

From PowerShell:
```posh
git clone https://DavidHazeldenUK/dotfiles-windows/dotfiles-windows.git; cd dotfiles-windows; . .\bootstrap.ps1
```

To update your settings, `cd` into your local `dotfiles-windows` repository within PowerShell and then:

```posh
. .\bootstrap.ps1
```

Note: You must have your execution policy set to unrestricted (or at least in bypass) for this to work: `Set-ExecutionPolicy Unrestricted`.

### Git-free install

> **Note:** You must have your execution policy set to unrestricted (or at least in bypass) for this to work. To set this, run `Set-ExecutionPolicy Unrestricted` from a PowerShell running as Administrator.

To install these dotfiles from PowerShell without Git:

```bash
iex ((new-object net.webclient).DownloadString('https://raw.DavidHazeldenUK/dotfiles-windows/dotfiles-windows/master/setup/install.ps1'))
```

To update later on, just run that command again.

### Add custom commands without creating a new fork

If `.\extra.ps1` exists, it will be sourced along with the other files. You can use this to add a few custom commands without the need to fork this entire repository, or to add commands you don't want to commit to a public repository.

My `.\extra.ps1` looks something like this:

```posh
# Hg credentials
# Not in the repository, to prevent people from accidentally committing under my name
Set-Environment "EMAIL" "David Hazelden <davidhazeldenuk@gmail.com>"

# Git credentials
# Not in the repository, to prevent people from accidentally committing under my name
Set-Environment "GIT_AUTHOR_NAME" "David Hazelden","DavidHazeldenUK"
Set-Environment "GIT_COMMITTER_NAME" $env:GIT_AUTHOR_NAME
git config --global user.name $env:GIT_AUTHOR_NAME
Set-Environment "GIT_AUTHOR_EMAIL" "davidhazeldenuk@gmail.com"
Set-Environment "GIT_COMMITTER_EMAIL" $env:GIT_AUTHOR_EMAIL
git config --global user.email $env:GIT_AUTHOR_EMAIL
```

Extras is designed to augment the existing settings and configuration. You could also use `./extra.ps1` to override settings, functions and aliases from my dotfiles repository, but it is probably better to [fork this repository](#forking-your-own-version).

### Sensible Windows defaults

When setting up a new Windows PC, you may want to set some Windows defaults and features, such as showing hidden files in Windows Explorer and installing IIS. This will also set your machine name and full user name, so you may want to modify this file before executing.

```post
.\windows.ps1
```

### Install dependencies and packages

When setting up a new Windows box, you may want to install some common packages, utilities, and dependencies. These could include node.js packages via [NPM](https://www.npmjs.org), [Chocolatey](http://chocolatey.org/) packages, Windows Features and Tools via [Web Platform Installer](https://www.microsoft.com/web/downloads/platform.aspx), and Visual Studio Extensions from the [Visual Studio Gallery](http://visualstudiogallery.msdn.microsoft.com/).

```posh
.\deps.ps1
```

> The scripts will install Chocolatey, node.js, and WebPI if necessary.

> **Visual Studio Extensions**  
> Extensions will be installed into your most current version of Visual Studio. You can also install additional plugins at any time via `Install-VSExtension $url`. The Url can be found on the gallery; it's the extension's `Download` link url.



## Forking your own version

This repository is built around how I use Windows, which is predominantly in a VM hosted on OS X. As such, things like VNC, FileZilla, or Skype are not installed, as they are available to me on the OS X side, installed by my [OS X dotfiles](https://DavidHazeldenUK/dotfiles-windows/dotfiles). If you are using Windows as your primary OS, you may want a different configuration that reflects that, and I recommend you [fork this repository](https://DavidHazeldenUK/dotfiles-windows/dotfiles-windows/fork).

If you do fork for your own custom configuration, you will need to touch a few files to reference your own repository, instead of mine.

Within `/setup/install.ps1`, modify the Repository variables.
```posh
$account = "DavidHazeldenUKs"
$repo    = "dotfiles-windows"
$branch  = "master"
```

Within the Windows Defaults file, `/windows.ps1`, modify the Machine
name on the first line.
```posh
(Get-WmiObject Win32_ComputerSystem).Rename("MyMachineName") | Out-Null
```

Finally, be sure to reference your own repository in the git-free installation command.
```bash
iex ((new-object net.webclient).DownloadString('https://raw.github.com/$account/$repo/$branch/setup/install.ps1'))
```

## Feedback

Suggestions/improvements are
[welcome and encouraged](https://DavidHazeldenUK/dotfiles-windows/dotfiles-windows/issues)!

## Author

| [![twitter/jayharris](http://gravatar.com/avatar/1318668b99b2d5a3900f3f7758763a69?s=70)](http://twitter.com/jayharris "Follow @jayharris on Twitter") |
|---|
| [Jay Harris](http://twitter.com/jayharris/) |

## Mods By

| [![twitter/dpehazelden](https://www.gravatar.com/avatar/78c2bdf9b745744a28c728ec9163e128?s=70)](http://twitter.com/dpehazelden "Follow @dpehazelden on Twitter") |
|---|
| [David Hazelden](http://twitter.com/dpehazelden/) |
## Thanks to…

* @[Mathias Bynens](http://mathiasbynens.be/) for his [OS X dotfiles](http://mths.be/dotfiles), which this repository is modeled after.
