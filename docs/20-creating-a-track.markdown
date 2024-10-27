---
layout: page
title: "Creating a Track"
permalink: /track/
---

## Getting Started
At this point, you should have a copy of the template project on your computer.  Launch the Godot 4.2 Editor, and choose the **"Import"** button to tell Godot where your project is located on your computer.
![Editor Import Step](../assets/images/editor-import.jpg)

Select the template project folder and then click the **"Select Current Folder"** button.  Then choose the **"Import & Edit"** button to open the project in the Godot Editor.
![Editor Import Step](../assets/images/editor-open.jpg)

### Renaming folders (IMPORTANT)
PGRC Expects mods to have a certain folder structure that looks like this:
```
res://
 ┗ Mods
    ┣ Placeholders (helpful track pieces are in here)
    ┃
    ┣ Scripts (built-in scripts for mods are in here)
    ┃
    ┗ [your_mod_name]
       ┣ Cars (not supported yet)
       ┃  ┣ [car_1_name]
       ┃  ┗ [car_2_name]
       ┃  (...as many cars as you want)
       ┃
       ┗ Tracks
          ┣ [track_1_name]
          ┗ [track_2_name]
          (...as many track as you want)
```

Because of the way mods are loaded into the game, it's important to make sure that all of your mod content is placed in a folder with a unique name (that doesn't overlap with any other mods).  You can see this structure in the template project, where the mode name is "walaber_sample", and the single track included in this mod is named "sample_track"
![Editor folders](../assets/images/editor-folders.jpg)


So, the first thing to do is to decide on a unique name for your mod, and then:

✅**Rename the "walaber_sample" folder to the name of your mod.**

It is recommended to only use lower-case letters, and underscores instead of spaces.  For example, if you want to call your mod "The Greatest Of Mods", name the folder "the_greatest_of_mods".  Also, Godot greatly prefers if you do file operations from within the Godot editor (rather than just manipulating the files yourself using your File Explorer, etc), so please do these operations from within the Godot Editor!

OK, so at this point you have renamed the main mod folder from "walaber_sample" to your mod name.

As you can see, the template project comes with 1 example track, called "sample_track".  Same as before, decide a name for your track (this name doesn't have to be unique, it can overlap with other mods and it's OK, because it's within your mod name folder).  

✅**Rename the "sample_track" folder to the name of your track.**

The mod system also expects that the mod "scene" (the actual godot file that contains your entire track) will also have the same name as it's folder, with a file extension of ".tscn".

✅**Rename the sample_track.tscn" file to the name of your track.**

you are now ready to start making your track!  It's a good practice to put any new assets for your track into the same folder as your track (such as 3D models, textures, materials, scripts, etc).  You can make sub-folders inside your track folder if you want to keep things organized. You can see that the sample track has 2 additional files in the track folder:

![Sample Track Files](../assets/images/sample-track-files.jpg)

* **sample_track.glb** this is a 3D model with the main track geometry
* **sample_track_diffuse** this is a Godot material which is used on the track geometry

## Creating Your Track

A Parking Garage Rally Circuit track consists of several parts. Each section below covers a specific element of a track in detail.
* [Heirarchy of a track scene](#heirarchy)
* [Creating the track environment / geometry](#track_model)
* [Setting the track path / minimap](#track_path)
* [Placing the car spawn point](#spawn)
* [Placing checkpoints](#checkpoints)
* [Placing barriers and guide objects](#barriers)
* [Placing spectator cars](#spectator_cars)
* [Setting up out-of-bounds areas](#oob)
* [Setting up reverb areas](#reverb)
* [Setting up broadcast cameras for replays](#cameras)

# <a name="heirarchy"></a> Heirarchy of a track scene (required elements)

# <a name="track_model"></a>Creating the track environment / geometry

# <a name="track_path"></a>Setting the track path / minimap

# <a name="spawn"></a>Placing the car spawn point

# <a name="checkpoints"></a>Placing checkpoints

# <a name="barriers"></a>Placing barriers and guide objects

# <a name = "spectator_cars"></a>Placing spectator cars

# <a name="oob"></a>Setting up out-of-bounds areas

# <a name="reverb"></a>Setting up reverb areas

# <a name="cameras"></a>Setting up broadcast cameras for replays

