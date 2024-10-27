---
layout: page
title: "Creating a Track"
permalink: /track/
---

A Parking Garage Rally Circuit track consists of several parts. Each section below covers a specific element of a track in detail.
* [Getting started](#getting_started)
* [Heirarchy of a track scene](#heirarchy)
* [Creating the track environment / geometry](#track_model)
* [Sega Saturn" materials and shaders](#saturn_shaders)
* [Placing the car spawn point](#spawn)
* [Placing checkpoints](#checkpoints)
* [Setting the track path / minimap](#track_path)
* [Placing barriers and guide objects](#barriers)
* [Placing spectator cars](#spectator_cars)
* [Setting up out-of-bounds areas](#oob)
* [Setting up reverb areas](#reverb)
* [Setting up broadcast cameras for replays](#cameras)
* [Setting lap counts](#lap_counts)
* [Track skybox](#skybox)
* [Track preview](#track_preview)


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
          (...as many tracks as you want)
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

There are tons of tutorials and reference material online for creating and importing 3D models, so I won't go into much detail here. 

## <a name="saturn_shaders"></a>"Sega Saturn" materials and shaders
You can use whatever materials, shaders you want in your track!  However, **if you want your level match the "Sega Saturn" look of PGRC** here are a few tips and tricks:

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
all of the environment lighting in PGRC tracks is achieved with **vertex colors**.  Essentially each vertex (point) in the 3D model can be assigned a color, and that color can affect how the texture is colored at that spot in the level.  This is how all of the lighting and shadows are accomplished in the level.  There are several parameters to adjust how the vertex colors are applied in the shader:
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
This part is pretty simple.  In the Scene tab you can see a node called "CarSpawn".  This node decides where the car will spawn at the start of the race, and which direction it will be facing.  You can move and rotate this object however you want.  Generally you will want to place it a short distance behind the first checkpoint (the start/finish line), and slightly above the ground.
![Car Spawn](../assets/images/car-spawn.jpg)

## <a name="checkpoints"></a>Placing checkpoints
Checkpoints are also pretty simple to set up.  In the Scene tab, expand the "Checkpoints" node so you can see it's child nodes.  Each child node is a checkpoint, and they should be placed around the track in order from first child to last child.  In other words, the first checkpoint under "Checkpoints" is the start/finish line, and then each checkpoint after that proceeds around in sequence.
You can add more checkpoints by duplicating an existing checkpoint, or you can add a checkpoint from the FileSystem tab, the checkpoint scene (prefab) is in `res://Mods/Placeholders/mod_checkpoint.tscn`.
![Checkpoint Scene](../assets/images/checkpoint-scene.jpg)

Each checkpoint has an orientation, you can see the little red arrow to indicate the "forward" direction players are expected to pass through the checkpoint.  This affects which side has the white arrows on it, and also where the car is placed when they reset to this checkpoint.
You can adjust the width and height of the checkpoint by changing the "size" values in the inspector.  If this checkpoint is near a big jump, it's a good idea to make the checkpoint Y size tall enough that players jumping through the checkpoint in the air will still trigger it.
![Checkpoint Details](../assets/images/checkpoint-editing.jpg)

## <a name="track_path"></a>Setting the track path / minimap
The track path is a very important object in each track.  Although it is not visible direclty in-game, it is till very important.  You will want to make the track path match the path players will drive through your track as closely as possible.  This is because the track path is used for:
* Determining if players are "off track" (shows the reset prompt)
* Determining if players are driving backwards (shows the reset prompt)
* Determining which players are ahead of other players (in multiplayer)
* Creating the mini-map object
* Deciding which [track cameras](#cameras) to activate during replays

Expand the "TrackPath" node in the Scene tab, and you will see that there are a bunch of "track_path_point" child nodes.  The track path becomes a smoothed curve that travels through all of the these child nodes, in order.  select a node and move / rotate it in the 3D view and you will see the track path update in realtime.  You can "trace" the driving patch of your track by duplicating and placing nodes along the route.
![Track path node](../assets/images/track-path-node.jpg)

Usually you can just duplicate existing nodes to expand your track, but you can also find the "path point" scene (prefab) in `res://Mods/Placeholders/mod_track_path_point.tscn` and drag that into the Scene tab as a child of TrackPath to add a point manually.
You can adjust some high-level settings about the track path by adjusting parameters on the TrackPath parent node:
* **Bezier Handle Length** this controls the path smoothing.  A value of 0 has no smoothing (sharp corners between each point), larger values are "smoother".  2.5 is a good starting point for most tracks.
* **Track Width** width of teh track, this will affect how thick the track looks as a mini-map. 6 is the default used for in-game tracks.
* **Vert Spacing** how often should the track path be subdivided? smaller numbers are smoother but use more polygons, higer numbers are less smooth but use less polygons.

A few **important notes** about the Track path:
* The first node needs to be placed right at the first checkpoint (the start of a lap)
* The final node needs to also be pladed right at the first checkpoint (the end of a lap)

## <a name="barriers"></a>Placing barriers and guide objects
If you want your track to use the built-in guide / barrier objects from the game, you can put placeholder objects as children of the "Barriers" node and they will be replaced with the official in-game models.
There are two types of barriers.  Each type has a special placeholder scene (prefab), and a drop-down to choose the variant of that object:

| Arrow Block |  |
| ---- | ----------- | 
| Image | ![Arrow Barrier](../assets/images/arrow-barrier.jpg) |
| Scene | `res://Mods/Placeholders/mod_barrier_arrow_block.tscn` |
| Variants | ![Arrow Types](../assets/images/arrow-types.jpg) |

| Railing Barrier |  |
| ---- | ----------- | 
| Image | ![Railing Barrier](../assets/images/railing-barrier.jpg) |
| Scene | `res://Mods/Placeholders/mod_barrier_railing.tscn` |
| Variants | ![Railing Types](../assets/images/railing-types.jpg) |

## <a name = "spectator_cars"></a>Placing spectator cars
Similar to barriers, there is a placeholder object in the template project that will be replaced with the in-game spectator cars (randomized just like the official tracks).  if you place these placeholder scenes (prefabs) as a child of the special "SpectatorCars" node, they will be properly detected and replaced in-game.
You can duplicate the existing nodes in the template project and place them wherever you want!  It's a good idea to place them slightly above the ground, because they are physics objects, and will fall and "settle" on the ground when the track is started.

![Spectator Car](../assets/images/spectator-car.jpg)

If for some reason you need to find the placeholder scene (prefab) manually, it can be found in `res://Mods/Placeholders/mod_spectator_car.tscn`.

## <a name="oob"></a>Setting up out-of-bounds areas
If the player find their way out of the track, it's important to reset them back!  You do this by setting up "out of bounds" areas: when the car enters these areas, it will automatically be reset to the last checkpoint.
In the Scene tab you will see a special node called "OutOfBounds".  This node can have 1 or more child nodes, each one describing a box shape area that is an out-of-bounds zone.  You can place as many or as few of these as you need for your track design.

At the very least, it's good to have a very large "fall trigger" to catch if players are able to fall out of their map, so they won't fall forever and have to reset manually.

Make sure that you use the "Size" parameter in the inspector to set the size of the trigger instead of scaling the node itself.

![OOB Trigger](../assets/images/oob-trigger.jpg)

## <a name="reverb"></a>Setting up reverb areas
Reverb areas are for making the game sounds have more echo when you are in certain areas of the track.  In the in-game tracks, the reverb is increased when you are indoors / areas with ceilings, and there is no reverb when you are outdoors / on the roof of a parking garage.

Reverb areas are essentially the same as out-of-bounds triggers, with 2 differences:
* On the main "ReverbTrigger" node, you can set the strength of the reverb for *that specific* trigger / area.
* You can have more than 1 ReverbTrigger in the scene (if you need areas with different reverb settings), whereas you can only have 1 out of bounds area.

There is 1 ReverbTrigger set up in the template project as an example.

## <a name="cameras"></a>Setting up broadcast cameras for replays
Although not critical for normal gameplay, it's fun to set up various cameras around your track that will be used in the post-race replays.  Similar to the other topics above, this consists of placing special placeholder scenes (prefabs) as children of the special "TrackCameras" node.
The position of each child node is the position of that camera, and there are a variety of settings in the Inspector for each camera node that controls how it operates.  These allow you to decide if the camera follows it's target (or is stationary), and how much it zooms in and out, etc.

The order of the nodes is important, they should be in order of proceeding around the track sequentially.  There is an important parameter called *Starting Track Interp* that decides when this camera is active.  This is a value between 0 and 1, and prepresents a percentage of completion around the track.

### Previewing the track cameras
It can be a bit confusing to know what all those parameters do, so there is a built-in way to preview the cameras in the template project.  Select the "TrackCameraPreviewer" Node and look at the Inspector.  There is a parameter called "Preview Car Interp" with a little slider.  Drag the slider, and a dark preview car will animate around your track path.  As it animates, a red wireframe preview will update showing which camera is active, and how it will frame the action.

## <a name="lap_counts"></a> Setting lap counts

## <a name="skybox"></a>Track skybox

## <a name="track_preview"></a>Track preview