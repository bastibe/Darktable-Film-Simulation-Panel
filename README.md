# Darktable Film Simulation Panel

A graphical panel in darktable's lighttable and darkroom for applying presets.

![Screenshot](screenshot.png)

This darktable extension consists of

- a Lua script that adds a "Film Simulations" panel to the darkroom and lighttable
- a number of styles, which the buttons apply

The supplied styles are:
- Fuji/Provia
- Fuji/Astia
- Fuji/Velvia
- Fuji/Classic Chrome
- Fuji/Pro Neg High
- Fuji/Pro Neg Std
- Fuji/Eterna
- Fuji/Bleach Bypass
- Fuji/Classic Neg
- Fuji/Nostalgic Neg
- Fuji/Reala Ace
- Ricoh/Ricoh Standard
- Ricoh/Positive Film
- Ricoh/Negative Film
- Ricoh/Vivid
- Ricoh/Retro
- Ricoh/Bleach Bypass (not included in panel)
- Ricoh/Cross Processing (not included in panel)
- 4 × Shadows (simple tone curve RGB adjustments)
- 4 × Exposure (simple exposure adjustments)
- DR100, DR200, DR400 (tone equalizer presets for raising shadows/midtones by 0/1/2 EV)

The Fuji and Ricoh styles were created using `darktable-chart` and a color checker photo. Darktable-chart can create darktable styles for emulating the look of rendered JPEG. In this case, I took a picture of a color checker, and converted it in my Fuji and Ricoh camera to the various film simulations. The darktable source render uses Sigmoid with preserve hue at 50%.

Adding a new button to the Film Simulations panel involves:
- adding the button in *FilmSimPanel.lua* using `darktable.new_widget`, and giving it a `apply_style_to_selection("yourstylename")` and `image`.
- adding a style with a matching name
- adding an icon that matches the `image`

## Installation

Copy the contents of the repository (excluding *README.md* and *screenshot.png* and *styles_source*, although they won't hurt) to your darktable configuration directory (e.g. *~/.config/darktable* or *~/.var/app/org.darktable.Darktable/config/darktable*).

Start darktable and use import action of the styles panel in the lighttable view, then select all files in the *styles* directory of this repository for import. After that, the styles should be already applicable. Close darktable (or make sure you restart the application at the end of installation).

The directories *icons* and *lua* must be copied to darktable configuration directory (e.g. *~/.config/darktable*, *~/.var/app/org.darktable.Darktable/config/darktable* or *C:\Users\\\<username>\AppData\Local\darktable*).

You may still need to create *luarc* in the configuration directory.

Finally, activate the FilmSimPanel lua script by adding this to *luarc*:

    > require "contrib/FilmSimPanel"

(This description should work for darktable 4, but at the time of writing has only been tested with darktable 4.4.2 on the current Linux Arch OS.)

## Usage

The styles are meant to be applied after Sigmoid with 1.5 Contrast, 0 skew, per-color processing with 50% preserve hue (as tested in darktable 4.8).

## Background

The styles were compiled using *darktable-chart*:

- edit your *darktablerc* and set `allow_lab_output=TRUE`
- export each of the JPEGs in *style_source* as PFM, with profile Lab (only available with the above edit)
- export the two RAF/DNG as PFM as well, make sure that white balance and exposure matches the JPEGs, and that the input profile is in its default state, and that only a bare minimum of modules is active
- run `darktable-chart` or `flatpak run --command=darktable-chart org.darktable.Darktable`
- select the exported RAF/DNG and the supplied *color_checker.cht* in the first tab (and adjust boundaries to match image, increase scale if necessary)
- select the exported JPEG in the second tab (also adjust boundaries)
- calculate and export in the third tab. If the difference is inf, check the masks in the first and second tab. I like to export only tone curve and color lookup table. Don't forget to set a style name.
- Restart darktable-chart, as it won't work correctly if you export more than once

The supplied target images were shot in sideways midday sunlight, white-balanced on a sheet of white paper. They were processed in-camera to the various film simulations.

When exporting the RAF/DNG target PFM, set up darktable to your preferred baseline. In my case, I want the style to apply after Sigmoid, so I include Sigmoid with my default settings in the RAF/DNG. As a fun diversion, you can mix and match source and target files as you please, for example, you can readily create a style for replicating Ricoh's "Positive Film" simulation from a Fuji camera.
