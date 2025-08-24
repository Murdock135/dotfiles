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
