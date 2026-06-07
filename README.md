<h2 align="center"> SDDM SEL</h2>

<p align=center>
A SEL inspired theme for the <a href="https://github.com/sddm/sddm">SDDM Login Manager</a>
</p>

<h2 align=center>Preview</h2>



https://github.com/leonardochappuis/sddmsel/assets/40621126/6ec86e78-692d-4a24-b456-1f052c97dd99




## Install
### From sources
> _Assumes that you've installed and configured SDDM correctly_ (if not [read more](https://wiki.archlinux.org/title/SDDM))

> **This theme targets Qt 6** (SDDM 0.20 or newer, built against Qt 6). For the
> older Qt 5 build of SDDM, check out a commit from before the Qt 6 migration.
> The included `metadata.desktop` declares `QtVersion=6` so SDDM starts
> `sddm-greeter-qt6` instead of the Qt 5 greeter.
> Do not replace or symlink `/usr/bin/sddm-greeter`; SDDM 0.21 and newer
> selects the correct greeter from the theme metadata.

>  Please make sure you have the following dependencies installed:
>  `qt6-declarative`, `qt6-5compat`, `qt6-svg`, `qt6-multimedia`
>
>  Video/audio playback also needs a Qt Multimedia backend:
>  - `qt6-multimedia-ffmpeg` (recommended — decodes the H.264 clip on its own), **or**
>  - `qt6-multimedia-gstreamer` together with `gst-libav`, `gst-plugins-good` and `gst-plugin-openh264`
>
>  Optional: `qt6-virtualkeyboard` for the on-screen keyboard.

1. Open terminal, and clone the repository with:

   ```sh
   git clone https://github.com/leonardochappuis/sddmsel.git ~/sddm-sel
   ```

2. Test versions:

   ```sh
   sddm-greeter-qt6 --test-mode --theme ~/sddm-sel/sel-shaders
   ```
   ```sh
   sddm-greeter-qt6 --test-mode --theme ~/sddm-sel/sel-basic
   ```
   > On a Qt 6 SDDM install the greeter binary is `sddm-greeter-qt6`.
   > Press `F1`/`Esc` or just close the window to exit test mode.

3. Then copy the wanted version as follows:

With Shaders
```sh
sudo cp -r ~/sddm-sel/sel-shaders /usr/share/sddm/themes/
```
Without Shaders
```sh
sudo cp -r ~/sddm-sel/sel-basic /usr/share/sddm/themes/
```

4. Remove the folder if you'd like

```sh
rm -rf ~/sddm-sel
```


## Configure

Create or edit `/etc/sddm.conf.d/10-theme.conf` with raised privileges:

```sh
sudo nano /etc/sddm.conf.d/10-theme.conf
```

```ini
[Theme]
Current=sel-shaders
```

Use `Current=sel-basic` instead if you installed the version without shaders.

### Updating an existing installation

If the theme was installed before `QtVersion=6` was added, update its metadata:

```sh
sudo install -Dm644 ~/sddm-sel/sel-shaders/metadata.desktop \
  /usr/share/sddm/themes/sel-shaders/metadata.desktop
```

Adjust the checkout path and use `sel-basic` in both paths if needed. The next
login screen will use the Qt 6 greeter. You can confirm after boot with:

```sh
journalctl -u sddm -b | grep 'Starting .*sddm-greeter'
```

The command should contain `/usr/bin/sddm-greeter-qt6`.

If test mode reports `module "QtQuick.VirtualKeyboard" is not installed`,
install `qt6-virtualkeyboard`, or set `ForceHideVirtualKeyboardButton="true"`
in the installed theme's `theme.conf`.

# FAQ

1. Sometimes SDDM might play no audio on the login screen if pipewire is initialized after it

Here's a possible solution.
Change the `sddm.service` file:

```bash
sudo systemctl edit sddm.service
```

In the editor that opens, paste the following lines:
```
[Unit]
After=pipewire.service pipewire.socket
Wants=pipewire.service pipewire.socket
```
Save and close the file.

Then run this command to apply the changes:
```bash
sudo systemctl daemon-reexec
```
(credits to [`Epixardo`](https://github.com/Epixardo) for reporting this one)

## Credits

- Original Video by [`Skorsen`](https://www.youtube.com/watch?v=zMLNTgomRNk)
- Based on the theme [`Tokyo Night SDDM`](https://github.com/rototrash/tokyo-night-sddm.git) which in turn
is:
- Based on the theme [`Sugar Dark for SDDM`](https://github.com/MarianArlt/sddm-sugar-dark) by [**MarianArlt**](https://github.com/MarianArlt).

## License

[GNU Lesser General Public License v3.0](LICENSE)
