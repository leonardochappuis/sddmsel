<h2 align="center"> SDDM SEL</h2>

<p align=center>
A SEL inspired theme for the <a href="https://github.com/sddm/sddm">SDDM Login Manager</a>
</p>

<h2 align=center>Preview</h2>



https://github.com/leonardochappuis/sddmsel/assets/40621126/6ec86e78-692d-4a24-b456-1f052c97dd99




## Install
### From sources
> _Assumes that you've installed and configured SDDM correctly_ (if not [read more](https://wiki.archlinux.org/title/SDDM))

>  Please make sure you have the following dependencies installed:
>  `qt5-quickcontrols2`, `qt5-graphicaleffects`, `qt5-svg`, `qt5-multimedia`, `gst-libav`, `gst-plugins-good`, `gst-plugin-openh264`

1. Open terminal, and clone the repository with:

   ```sh
   git clone https://github.com/leonardochappuis/sddmsel.git ~/sddm-sel
   ```

2. Test versions:

   ```sh
   sddm-greeter --test-mode --theme ~/sddm-sel/sel-shaders
   ```
   ```sh
   sddm-greeter --test-mode --theme ~/sddm-sel/sel-basic
   ```

3. Them move the wanted version as follows:

With Shaders
```sh
sudo mv ~/sddm-sel/sel-shaders /usr/share/sddm/themes/
```
Without Shaders
```sh
sudo mv ~/sddm-sel/sel-basic /usr/share/sddm/themes/
```

4. Remove the folder if you'd like

```sh
rm -rf ~/sddm-sel
```


## Configure

Edit the `/etc/sddm.conf` (with any text editor with **raised** privileges), so that it looks like this:

```sh
sudo nano /etc/sddm.conf  # use any text editor with raised privileges
---
[Theme]
Current=sddm-sel
   ```

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
