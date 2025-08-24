# Usage

1. Clone the repo with `git clone https://github.com/Murdock135/mydotfiles.git`
2. Move into the directory with `cd mydotfiles`
3. Stow the packages.

```
stow shell
stow hypr
stow git
```

> > [!NOTE]
> If stow warns you that the same files already exist in your machine (predesigned configs), you have to make a choice between (1) using your configs (2) using the machine's configs (3) make a 'balancing act' and using some from yours and some from the machine's. (1) is easiest. Simply delete the predesigned configs and use the stow command again. I personally had to do this because I am using [Omarchy](https://omarchy.org/), which ships with its own `keymaps.lua` and `options.lua`. 

4. Load aliases and functions
```
~/.config/shell/load.sh
```

# Enabling more packages from `install/optional/`
To enable any package, simply run 

```
cd ~/mydotfiles
bash install/optional/<package>/enable.sh
```

To disable the package (to not use them), run

```
bash install/optional/<package>/disable.sh
```

Optionally, if you also want to unstow them you can use the `--unstow` flag, like so

```
bash install/optional/<package>/disable.sh --unstow
```

Optionally, if you want to fully purge the config (deletes the config files from ~/.config/<package>/)

```
bash install/optional/<package>/disable.sh --unstow --purge
```
