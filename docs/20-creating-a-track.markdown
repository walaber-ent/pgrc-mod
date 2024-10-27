---
layout: page
title: "Creating a Track"
permalink: /track/
---

A Parking Garage Rally Circuit track consists of several parts. Each section below covers a specific element of a track in detail.
* [Getting started](#getting_started)
* [Heirarchy of a track scene](#heirarchy)
* [Creating the track environment / geometry](#track_model)
* [Placing the car spawn point](#spawn)
* [Placing checkpoints](#checkpoints)
* [Setting the track path / minimap](#track_path)
* [Placing barriers and guide objects](#barriers)
* [Placing spectator cars](#spectator_cars)
* [Setting up out-of-bounds areas](#oob)
* [Setting up reverb areas](#reverb)
* [Setting up broadcast cameras for replays](#cameras)


## <a name="getting_started"></a> Getting Started
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


## <a name="heirarchy"></a> Heirarchy of a track scene (required elements)
Here is what the template track scene looks like in the Godot "Scene" panel:

![Template Scene Heirarchy](../assets/images/heirarchy-01.jpg)

The top level node can be renamed if you like (to match your track name, for example), but it **must** have the ModTrack.gd script attached to it for your track to function.

There are also many nodes that are required for your track to function.  You can easily spot them because the have the "%" symbol to the right of their name, meaning they are a unique node name.  Essentially, these nodes **must exist** in the track scene, and their names must **not be changed**, because the main ModTrack script depends on their names to find them:

![Special Named Nodes](../assets/images/heirarchy-02.jpg)

Note that "ReverbTrigger" does not have the special "%".  This is because reverb triggers are not required, and you can also have as many reverb triggers as you want.  In the image above, "sample_track" is the custom track geometry (3D model) for this track, which of course you can delete / change however you want for your custom track.


## <a name="track_model"></a>Creating the track environment / geometry
This is the fun part!  You can create your track to be anything you want!  You can create your track in many different ways, such as:
* make the entire track in a single 3D model file using a program like Blender, and import it into Godot
* make many 3D model files of individual parts of your track, and import and compose them into a scene inside Godot
* make a track just using simple primitive shapes created entirely inside Godot
* etc etc etc :)

In general, it would be a good idea to take a look at the Godot documentation for [Importing 3D Scenes](https://docs.godotengine.org/en/4.1/tutorials/assets_pipeline/importing_scenes.html) and get familiar with how to create and import 3D models into Godot.

There are tons of tutorials and reference material online for creating and importing 3D models, so I won't go into much detail here. However, **if you want your level match the "Sega Saturn" look of PGRC** here are a few tips and tricks:

📝Make sure your textures are very low resolution! For example, here is the texture used parking garage in the "Mount Rushmore" track from the game, it's a single 256x256 texture that is carefully re-used and tiled:

![Mt Rushmore Texture](../assets/images/mtrush-garage-texture.jpg)

📝Use the provided "saturn lit" shader for your environment material.  Right-click in the FileSystem panel in Godot and choose "Create New" > "Resource". 

![Creating a resource](../assets/images/shader-create-resource.jpg)

Set the type to be "ShaderMaterial" and give it a name.  

![ShaderMaterial resource type](../assets/images/shader-shaderresource.jpg)

Select your new material in the FileSystem panel, and then look at the Inspector panel. Click the little ⬇️ to the right of the word "Shader" and select "Quick Load".  

![Quick Load Shader](../assets/images/shader-set-shader.jpg)

Choose "Shaders/saturn_lit.gdshader" ![Shader Path](../assets/images/shader-filename.jpg) and click "Open".  Now in the inspector, expand the "Shader Parameters".  At the bottom you will see "Main Texture".  Again, click the ⬇️, choose "Quick Load", and select the texture you want to use.  Congrats, you now have a material that will match the lighting, vertex wobble, and distance fade characteristics of all the built-in tracks from the game.

The shader has a few parameters that you can adjust:

![Shader Parameters](../assets/images/shader-parameters.jpg)

### Vertex color adjustment parameters:
all of the environment lighting in PGRC tracks is achieved with **vertex colors**.  Essentially each vertex (point) in the 3D model can be assigne a color, and that color can affect how the texture is colored at that spot in the level.  This is how all of the lighting and shadows are accomplished in the level.  There are several parameters to adjust how the vertex colors are applied in the shader:
* **Vert Color Gamma** this is essentially the "exposure" of the vertex colors.  Most tracks use a value between 0.6 and 1.5.
* **Vert Color Mult** a number to multiply the vertex colors with.  Generally controls the contrast. values < 1 will darken the colors, and values > 1 will increase the contrast of the colors.
* **Vert Color Gain** a number that is added to the vertex colors. values < 0 will darken, values > 1 will lighten.  Rarely used other than to slightly push the colors brighter or darker.
* **Vert Color Factor** a number between 0 and 1, which means "how much should the vertex colors be applied at all". 0 means ignore vertex colors, 1 meand fully incorporate them.
* **Vert Color Range** a way to simulate lower color depth.  If you set this number to 32, it means that Red, Green, and Blue can only have 32 unique levels of brightness, which will create "banding" and other artifacts that simulate older hardware.  The default of 64 is pretty good, but you can adjust if you want more or less banding / artifacts.

### Culling parameters:
In order to simulate how 3D graphics were drawn on a Sega Saturn, objects in PGRC intentionally "pop in" when they get close enough to the camera.  The distance at which objects pop-in follows the in-game "draw distance" setting.  Within this, there are essentially "near" and "far" objects.  "near" objects pop in much closer to the camera than "far" objects.  In PGRC levels, "prop" objects like spectator cars, arrow barriers, and railings are generally set to "near", while environment such as the track geometry are set the "far", but of course you can set things however you want! 

By default, the shader will cull an entire object as a whole, based on the distance from the origin of that object to the camera.  If you build your level out of many small individual meshes, this creates a really pleasing "Saturn-like" pop-in effect.  However, sometimes it is cumbersome to break up your level into many small individual objects (for example, if you have a large terrain object that is easier to edit as 1 piece).  For that scenario, the shader can also be set to a "grid culling" mode, where sections of the model are culled individually based on a world-aligned grid.

* **Cull Bias** this is an optional offset for the culling calculations. a positive number will make the object stay visible until a farther distance from the camera (based on this value, in meters)
* **Cull Near Far** set this to 0 to indicate this object is a "near" object and should be culled aggressively.  Set to 1 to indicate this object is a "far" object and shouldn't cull as much.
* **Cull Pop Factor** Set this to 0 and the object will fade out gradually as it gets farther away from the camera. Set to 1 and the object will "pop" visible / hidden without fading.

* **Grid Culling** turn this on to use the world-space grid culling mode (instead of the per-object culling mode)
* **Grid Size** the size (in meters) of the world-space grid when using Grid Culling mode.


## <a name="spawn"></a>Placing the car spawn point

## <a name="checkpoints"></a>Placing checkpoints

## <a name="track_path"></a>Setting the track path / minimap

## <a name="barriers"></a>Placing barriers and guide objects

## <a name = "spectator_cars"></a>Placing spectator cars

## <a name="oob"></a>Setting up out-of-bounds areas

## <a name="reverb"></a>Setting up reverb areas

## <a name="cameras"></a>Setting up broadcast cameras for replays

