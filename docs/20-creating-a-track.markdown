---
layout: page
title: "Creating a Track"
permalink: /track/
---

A Parking Garage Rally Circuit track consists of several parts. Each section below covers a specific element of a track in detail.
* [Getting started](#getting_started)
* [Filling out info.cfg](#info)
* [Heirarchy of a track scene](#heirarchy)
* [Creating the track environment / geometry](#track_model)
* [Setting up collision geometry](#colliders)
* [Applying materials in Godot](#materials)
* [Sega Saturn" materials and shaders](#saturn_shaders)
* [Placing the car spawn point](#spawn)
* [Placing checkpoints](#checkpoints)
* [Setting the track path / minimap](#track_path)
* [Placing barriers and guide objects](#barriers)
* [Placing spectator cars](#spectator_cars)
* [Setting up out-of-bounds areas](#oob)
* [Setting up reverb areas](#reverb)
* [Setting up broadcast cameras for replays](#cameras)
* [Setting up the track intro camera](#intro-camera)
* [Setting lap counts](#lap_counts)
* [Track skybox](#skybox)
* [Track music](#music)
* [Track preview](#track_preview)
* [Exporting and testing](#exporting_and_testing)
* [Gold trophy ghosts](#trophy-ghosts)
* [Uploading to Steam Workshop](#uploading)

# Advanced Topics
* [Point-to-point tracks](#point-to-point)
* [Branching paths / checkpoints](#branching-paths)
* [Skybox triggers](#skybox-triggers)

# Help and Troubleshooting
* [Troubleshooting](#troubleshooting)




## <a name="getting_started"></a> Getting Started
At this point, you should have a copy of the template project on your computer. Launch the Godot 4.2 Editor, and choose the **"Import"** button to tell Godot where your project is located on your computer.
![Editor Import Step](../assets/images/editor-import.jpg)

Select the template project folder and then click the **"Select Current Folder"** button. Then choose the **"Import & Edit"** button to open the project in the Godot Editor.
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

Because of the way mods are loaded into the game, it's important to make sure that all of your mod content is placed in a folder with a unique name (that doesn't overlap with any other mods). You can see this structure in the template project, where the mode name is "walaber_sample", and the single track included in this mod is named "sample_track"
![Editor folders](../assets/images/editor-folders.jpg)


So, the first thing to do is to decide on a unique name for your mod, and then:

✅**Rename the "walaber_sample" folder to the name of your mod.**

It is recommended to only use lower-case letters, and underscores instead of spaces. For example, if you want to call your mod "The Greatest Of Mods", name the folder "the_greatest_of_mods". Also, Godot greatly prefers if you do file operations from within the Godot editor (rather than just manipulating the files yourself using your File Explorer, etc), so please do these operations from within the Godot Editor!

OK, so at this point you have renamed the main mod folder from "walaber_sample" to your mod name.

As you can see, the template project comes with 1 example track, called "sample_track". Same as before, decide a name for your track (this name doesn't have to be unique, it can overlap with other mods and it's OK, because it's within your mod name folder).  

✅**Rename the "sample_track" folder to the name of your track.**

The mod system also expects that the mod "scene" (the actual godot file that contains your entire track) will also have the same name as it's folder, with a file extension of ".tscn".  It also expects a thumbnail scene (the preview of the track shown in the track select menu in-game) with the same name as the track folder, with "_thumbnail.tscn" appended to the end.

✅**Rename the sample_track.tscn" file to the name of your track.**

✅**Rename the sample_track_thumbnail.tscn file to the name of your track (keep the _thumbnail part).**

you are now ready to start making your track! It's a good practice to put any new assets for your track into the same folder as your track (such as 3D models, textures, materials, scripts, etc). You can make sub-folders inside your track folder if you want to keep things organized. You can see that the sample track has 2 additional files in the track folder:

![Sample Track Files](../assets/images/sample-track-files.jpg)

* **sample_track.glb** this is a 3D model with the main track geometry
* **sample_track_diffuse** this is a Godot material which is used on the track geometry

## <a name="info"></a>Filling out info.cfg
PGRC relies on your mod containing a file names `info.cfg` in the root of the mod project.  This file contains some important information about the mod.

Find `info.cfg` in the FileSystem tab, and double-click it to open it in the code editor.  If you don't have an `info.cfg` file in your project, you can create one.  Right-click on `res://` in the FileSystem tab, and select **"Create New..."** and then **"Text File"**, and make sure to name it `info.cfg`.

![Info.cfg location](../assets/images/info-cfg-location.jpg)

Here is a look at the contents of the `info.cfg` file:

![Info.cfg details](../assets/images/info-cfg-details.jpg)

Make sure that the `track_file` entry matches the track folder name you chose in the previous step.  To be super clear, to make sure your track loads properly:

- You have chosen a unique name for your mod, and renamed the main folder to match.
- You have chosen a name for your track, and renamed the track folder to match.
- You have renamed the main .tscn and the _thumbnail.tscn files to match your track folder name.

![Naming overview](../assets/images/matching-names.jpg)

Also make sure that the `track_version` entry exists and is a valid number (1 is a good default).  If you ever update your track and want to make sure that old best times are ignored and must be reset, you can increment this version number value.  **Note** this is an integer value, not a string (text) value, so it shouldn't have quotes around it.  It should look like this:

![Info.cfg track version](../assets/images/info-cfg-version.jpg)

### What if my mod has multiple tracks?

If you want your mod to have multiple tracks contained inside it, you just need to make an entry for each track in the info.cfg file.  Make a copy of the main content in the "tracks" and fill in the "track_name", "track_file", and "track_version".  Don't forget to add a comma to separate the entries.  Here is an example of what am info.cfg with two tracks might look like:

![Info.cfg with multiple tracks](../assets/images/info-cfg-multiple-tracks.png)

## <a name="heirarchy"></a> Heirarchy of a track scene (required elements)
Here is what the template track scene looks like in the Godot "Scene" panel:

![Template Scene Heirarchy](../assets/images/heirarchy-01.jpg)

The top level node can be renamed if you like (to match your track name, for example), but it **must** have the ModTrack.gd script attached to it for your track to function.

There are also many nodes that are required for your track to function. You can easily spot them because the have the "%" symbol to the right of their name, meaning they are a unique node name. Essentially, these nodes **must exist** in the track scene, and their names must **not be changed**, because the main ModTrack script depends on their names to find them:

![Special Named Nodes](../assets/images/heirarchy-02.jpg)

Note that "ReverbTrigger" does not have the special "%". This is because reverb triggers are not required, and you can also have as many reverb triggers as you want. In the image above, "sample_track" is the custom track geometry (3D model) for this track, which of course you can delete / change however you want for your custom track.


## <a name="track_model"></a>Creating the track environment / geometry
This is the fun part! You can create your track to be anything you want! You can create your track in many different ways, such as:
* make the entire track in a single 3D model file using a program like Blender, and import it into Godot
* make many 3D model files of individual parts of your track, and import and compose them into a scene inside Godot
* make a track just using simple primitive shapes created entirely inside Godot
* etc etc etc :)

In general, it would be a good idea to take a look at the Godot documentation for [Importing 3D Scenes](https://docs.godotengine.org/en/4.1/tutorials/assets_pipeline/importing_scenes.html) and get familiar with how to create and import 3D models into Godot.

There are tons of tutorials and reference material online for creating and importing 3D models, so I won't go into much detail here. 

## <a name="colliders"></a>Setting up collision geometry
If you just import a 3D model into the scene, and then play your track, you might find that the car falls right through the ground as though it's not even there!

This is because game engines treat visuals and collisions separately. You must indicate to the game engine what surfaces are collidable, and also what types of objects can collide with each other. PGRC for example has a collision "layer" called **ground** which is used for most scenery objects in a track, such as the ground itself, and also things like the arrow barriers, etc. There is also a collision layer called **car** reserved for the cars.

Anyway, there are a few ways to set up collision information for your track.

### Auto-generate Mesh Colliders
The simplest option, is to simply tell Godot to create a collider from your visual mesh itself. There is a shortcut for this that uses [import hints](https://docs.godotengine.org/en/4.1/tutorials/assets_pipeline/importing_scenes.html#import-hints), basically if you add some special suffix to the name of the objects in your 3D model file, Godot will automatically generate associated collision data for you. The key hint is `-col` which will create a "mesh collider" from the mesh in the 3D file. Most PGRC tracks actually use this method, because the track is very-low poly, and having the collision match the visuals is acceptible and performant.

### Custom collision meshes
Another common method is to create a simplified mesh that mostly matches the visual mesh, but is better suited for collision detection. The "pirate cove" example track uses this method. As you can see, the wood plank sections are actually modeled as individual wooden planks with small gaps between them.  This geometry would be troublesome if used as-is for collision detection, both because it's overly complex (has a performance cost), and also because the raycast-based vehicle system will mean that the car tires would "fall through" the ground sometimes when the raycast lines up with a gap in the planks.

![Pirate Cove Visual Mesh Example](../assets/images/collision-pirate-cove-01.jpg)

The solution is to have a simpler mesh that is used only for collision, like you can see below. There is another import hint `-colonly` which indicates a mesh should only be used to generate a collider, and not actually appear visually in-game.

![Pirate Cove Collision Mesh](../assets/images/collision-pirate-cove-02.jpg)

### Using Godot CollisionShapes
You can also just make the collision inside the Godot editor itself! This can be time consuming if you have complex geometry, but can work great for quickly adding in simple collision shapes without opening up a 3D modelling program. 

![Godot collider example](../assets/images/godot-collider-box.jpg)

You will want to create a **StaticBody3D** node, and then give it 1 or more **CollisionShape3D** child nodes. 

![Godot collider node setup](../assets/images/godot-collider-nodes.jpg)

Each CollisionShape3D node has a **shape** property where you can create colliders from various primitive shapes like boxes, spheres, capsules, etc.

![Godot collider shapes](../assets/images/godot-collider-shape.jpg)

### A Note on Layers

Godot lets you define "layers" that help identify categories of objects in your game, and control what things can collide with each other, what things pass through each other without collision, etc.  PGRC has a bunch of layers already set up that you will need to use in order for things to work properly.

Here is a look at the layers in PGRC:

![Physics layers in PGRC](../assets/images/pgrc-layers.png)

| # | Name | Description |
| -- | ---- | ----------- |
| 1 | Ground | Use this for all "normal" objects that you want the car to collide with |
| 2 | Car | This layer is reserved for the car.  If you want to make a custom Area3D that will react to the car entering, make sure the mask is set to this layer! |
| 3 | OutOfBounds | This layer is used for Out Of Bounds Area3D triggers |
| 4 | CarTriggers | This layer is used for other multi-purpose Area3D triggers that react to the cars |
| 5 | PaintGlob | Unused, was for a prototype game mechanic that was never finished |
| 6 | Dirt | This is ground, but the traction is a bit different and dirt particles are created when driving on it |
| 7 | TireRayOnly | Special layer if you want some collision that the tires will collide with, but the car body will not |
| 8 | Grass | This is ground, but slows down the car and creates grass particles when driving on it |
| 9 | DeepSnow | This is ground, but has lower traction and created snow particles when driving on it |
| 10 | LightSnow | This is ground, with different drift particles |
| 11 | Roof | This is ground, but with a different controller rumble pattern |

Feel free to use these layers in your tracks.  The mod template project has these layers set up, so you can see their names.  Select a physics object, and look at the "Collision" section:

![Collision inspector view](../assets/images/collision-inspector.png)

If you hover the mouse over a box, you can see the name, or click the three dot menu and you can see the layers with their names:

![Collision inspector view with names](../assets/images/collision-inspector-names.png)


## <a name="materials"></a>Applying materials in Godot
When you import 3D models into Godot, you will likely want to customize the materials on that model, especially if you want to use the PGRC shaders to give your track the "Sega Saturn" look ([see below](#sega-saturn-materials-and-shaders) for info on these)

Let's say you have a 3D model that you found online, or created in a program like Blender.  As an exmaple, let's pretend we have a .gltf model file like this one:

![FileSystem view showing a .gltf model file](../assets/images/model-import-gltf.png)

It comes with the model itself, along with many texture maps.  If you double-click on the .gltf file, an "advanced import window" will pop up that lets you examine the model, and set various settings that affect how it is imported into Godot. 

![Advanced Import Settings Window](../assets/images/model-import-settings.png)

The most relevant feature for PGRC tracks is the ability to set up each material in the model to use a Godot material that you have created.  If you click on the "materials" tab of the import window, You can see a list on the left of all of the materials that the model file expects.

![Using External Materials](../assets/images/model-external-materials.png)

If you select one of these materials, you will see an option on the right called "Use External".  Check this box, and then click the folder icon to browse and select the Godot material asset (a .tres file) that you would like to map to that material in the model.

In this example, I created "Sega Saturn" materials for all of the materials that this model expected (quite a few!), and set them to use external as indicated above.  Before doing this step, the model looked like this in the 3D view:

![Model before mapping materials](../assets/images/model-import-before.png)

... and after mapping the materials it looks like this:

![Model after mapping materials](../assets/images/model-import-after.png)

**NOTE** Although I have focused on examples using the PGRC "Sega Saturn" shaders here (and more below), you don't have to use those shaders.  You can also create materials that are "StandardMaterial3D" resources, which is a highly configurable material type Godot that you can use to create a variety of visual styles easily. [More information here](https://docs.godotengine.org/en/stable/tutorials/3d/standard_material_3d.html)



## <a name="saturn_shaders"></a>"Sega Saturn" materials and shaders
You can use whatever materials, shaders you want in your track!  However, **if you want your level match the "Sega Saturn" look of PGRC** here are a few tips and tricks:

📝 Make sure your textures are very low resolution! For example, here is the texture used parking garage in the "Mount Rushmore" track from the game, it's a single 256x256 texture that is carefully re-used and tiled:

![Mt Rushmore Texture](../assets/images/mtrush-garage-texture.jpg)

📝 Use the provided "saturn lit" shader for your environment material.  Right-click in the FileSystem panel in Godot and choose "Create New" > "Resource". 

![Creating a resource](../assets/images/shader-create-resource.jpg)

Set the type to be "ShaderMaterial" and give it a name.  

![ShaderMaterial resource type](../assets/images/shader-shaderresource.jpg)

Select your new material in the FileSystem panel, and then look at the Inspector panel. Click the little ⬇️ to the right of the word "Shader" and select "Quick Load".  

![Quick Load Shader](../assets/images/shader-set-shader.jpg)

Choose "Shaders/saturn_lit.gdshader" ![Shader Path](../assets/images/shader-filename.jpg) and click "Open". Now in the inspector, expand the "Shader Parameters". At the bottom you will see "Main Texture". Again, click the ⬇️, choose "Quick Load", and select the texture you want to use. Congrats, you now have a material that will match the lighting, vertex wobble, and distance fade characteristics of all the built-in tracks from the game.

The shader has a few parameters that you can adjust:

![Shader Parameters](../assets/images/shader-parameters.jpg)

### Texture Mapping parameters:
There is an effect called "affine mapping" which simulates how textures stretched at the edges of the screen and when viewed at oblique angles on older hardware like the Sega Saturn.
* **Affine Mapping** toggle the texture stretching effect (on by default)
* **Affine Effect Reduction** increase this value to reduce the amount of texture stretching, lower it for more extreme stretching.
The affine effect is amplified when you have large triangles/quads in your mesh.  If you mesh has very large quads, you might need to disable Affine Mapping altogether to make it look acceptable in-game (alternatively, you can subdivide the mesh to reduce the stretching artifacts as well, if you have th ability to modify the mesh yourself).

### Vertex color adjustment parameters:
all of the environment lighting in PGRC tracks is achieved with **vertex colors**. Essentially each vertex (point) in the 3D model can be assigned a color, and that color can affect how the texture is colored at that spot in the level. This is how all of the lighting and shadows are accomplished in the level. There are several parameters to adjust how the vertex colors are applied in the shader:
* **Vert Color Gamma** this is essentially the "exposure" of the vertex colors.  Most tracks use a value between 0.6 and 1.5.
* **Vert Color Mult** a number to multiply the vertex colors with.  Generally controls the contrast. values < 1 will darken the colors, and values > 1 will increase the contrast of the colors.
* **Vert Color Gain** a number that is added to the vertex colors. values < 0 will darken, values > 1 will lighten.  Rarely used other than to slightly push the colors brighter or darker.
* **Vert Color Factor** a number between 0 and 1, which means "how much should the vertex colors be applied at all". 0 means ignore vertex colors, 1 meand fully incorporate them.
* **Vert Color Range** a way to simulate lower color depth.  If you set this number to 32, it means that Red, Green, and Blue can only have 32 unique levels of brightness, which will create "banding" and other artifacts that simulate older hardware. The default of 64 is pretty good, but you can adjust if you want more or less banding / artifacts.

### Culling parameters:
In order to simulate how 3D graphics were drawn on a Sega Saturn, objects in PGRC intentionally "pop in" when they get close enough to the camera. The distance at which objects pop-in follows the in-game "draw distance" setting.  Within this, there are essentially "near" and "far" objects. "near" objects pop in much closer to the camera than "far" objects. In PGRC levels, "prop" objects like spectator cars, arrow barriers, and railings are generally set to "near", while environment such as the track geometry are set the "far", but of course you can set things however you want! 

By default, the shader will cull an entire object as a whole, based on the distance from the origin of that object to the camera. If you build your level out of many small individual meshes, this creates a really pleasing "Saturn-like" pop-in effect. However, sometimes it is cumbersome to break up your level into many small individual objects (for example, if you have a large terrain object that is easier to edit as 1 piece). For that scenario, the shader can also be set to a "grid culling" mode, where sections of the model are culled individually based on a world-aligned grid.

* **Cull Bias** this is an optional offset for the culling calculations. a positive number will make the object stay visible until a farther distance from the camera (based on this value, in meters)
* **Cull Near Far** set this to 0 to indicate this object is a "near" object and should be culled aggressively.  Set to 1 to indicate this object is a "far" object and shouldn't cull as much.
* **Cull Pop Factor** Set this to 0 and the object will fade out gradually as it gets farther away from the camera. Set to 1 and the object will "pop" visible / hidden without fading.

* **Grid Culling** turn this on to use the world-space grid culling mode (instead of the per-object culling mode)
* **Grid Size** the size (in meters) of the world-space grid when using Grid Culling mode.


## <a name="spawn"></a>Placing the car spawn point
This part is pretty simple. In the Scene tab you can see a node called "CarSpawn". This node decides where the car will spawn at the start of the race, and which direction it will be facing.  You can move and rotate this object however you want. Generally you will want to place it a short distance behind the first checkpoint (the start/finish line), and slightly above the ground.
![Car Spawn](../assets/images/car-spawn.jpg)

## <a name="checkpoints"></a>Placing checkpoints
Checkpoints are also pretty simple to set up. In the Scene tab, expand the "Checkpoints" node so you can see it's child nodes.  Each child node is a checkpoint, and they should be placed around the track in order from first child to last child. In other words, the first checkpoint under "Checkpoints" is the start/finish line, and then each checkpoint after that proceeds around in sequence.
You can add more checkpoints by duplicating an existing checkpoint, or you can add a checkpoint from the FileSystem tab, the checkpoint scene (prefab) is in `res://Mods/Placeholders/mod_checkpoint.tscn`.
![Checkpoint Scene](../assets/images/checkpoint-scene.jpg)

Each checkpoint has an orientation, you can see the little red arrow to indicate the "forward" direction players are expected to pass through the checkpoint. This affects which side has the white arrows on it, and also where the car is placed when they reset to this checkpoint.
You can adjust the width and height of the checkpoint by changing the **"Size"** values in the inspector. If this checkpoint is near a big jump, it's a good idea to make the checkpoint Y size tall enough that players jumping through the checkpoint in the air will still trigger it.
![Checkpoint Details](../assets/images/checkpoint-editing.jpg)

## <a name="track_path"></a>Setting the track path / minimap
The track path is a very important object in each track.  Although it is not visible direclty in-game, it is till very important.  You will want to make the track path match the path players will drive through your track as closely as possible. This is because the track path is used for:
* Determining if players are "off track" (shows the reset prompt)
* Determining if players are driving backwards (shows the reset prompt)
* Determining which players are ahead of other players (in multiplayer)
* Creating the mini-map object
* Deciding which [track cameras](#cameras) to activate during replays

Expand the "TrackPath" node in the Scene tab, and you will see that there are a bunch of "track_path_point" child nodes. The track path becomes a smoothed curve that travels through all of the these child nodes, in order. Select a node and move / rotate it in the 3D view and you will see the track path update in realtime. You can "trace" the driving patch of your track by duplicating and placing nodes along the route.
![Track path node](../assets/images/track-path-node.jpg)

Usually you can just duplicate existing nodes to expand your track, but you can also find the "path point" scene (prefab) in `res://Mods/Placeholders/mod_track_path_point.tscn` and drag that into the Scene tab as a child of TrackPath to add a point manually. 
You can adjust some high-level settings about the track path by adjusting parameters on the TrackPath parent node:
* **Bezier Handle Length** this controls the path smoothing. A value of 0 has no smoothing (sharp corners between each point), larger values are "smoother". 2.5 is a good starting point for most tracks.
* **Track Width** width of the track, this will affect how thick the track looks as a mini-map. 6 is the default used for in-game tracks.
* **Vert Spacing** how often should the track path be subdivided? smaller numbers are smoother but use more polygons, higer numbers are less smooth but use less polygons.

A few **important notes** about the Track path:
* The first node needs to be placed right at the first checkpoint (the start of a lap)
* The final node needs to also be pladed right at the first checkpoint (the end of a lap)

## <a name="barriers"></a>Placing barriers and guide objects
If you want your track to use the built-in guide / barrier objects from the game, you can put placeholder objects as children of the "Barriers" node and they will be replaced with the official in-game models.
There are two types of barriers. Each type has a special placeholder scene (prefab), and a drop-down to choose the variant of that object:

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
Similar to barriers, there is a placeholder object in the template project that will be replaced with the in-game spectator cars (randomized just like the official tracks). If you place these placeholder scenes (prefabs) as a child of the special "SpectatorCars" node, they will be properly detected and replaced in-game.
You can duplicate the existing nodes in the template project and place them wherever you want! It's a good idea to place them slightly above the ground, because they are physics objects, and will fall and "settle" on the ground when the track is started.

![Spectator Car](../assets/images/spectator-car.jpg)

If for some reason you need to find the placeholder scene (prefab) manually, it can be found in `res://Mods/Placeholders/mod_spectator_car.tscn`.

## <a name="oob"></a>Setting up out-of-bounds areas
If the player find their way out of the track, it's important to reset them back! You do this by setting up "out of bounds" areas: when the car enters these areas, it will automatically be reset to the last checkpoint.
In the Scene tab you will see a special node called "OutOfBounds".  This node can have 1 or more child nodes, each one describing a box shape area that is an out-of-bounds zone. You can place as many or as few of these as you need for your track design.

At the very least, it's good to have a very large "fall trigger" to catch if players are able to fall out of their map, so they won't fall forever and have to reset manually.

Make sure that you use the **"Size"** parameter in the inspector to set the size of the trigger instead of scaling the node itself.

![OOB Trigger](../assets/images/oob-trigger.jpg)

## <a name="reverb"></a>Setting up reverb areas
Reverb areas are for making the game sounds have more echo when you are in certain areas of the track. In the in-game tracks, the reverb is increased when you are indoors / areas with ceilings, and there is no reverb when you are outdoors / on the roof of a parking garage.

Reverb areas are essentially the same as out-of-bounds triggers, with 2 differences:
* On the main "ReverbTrigger" node, you can set the strength of the reverb for *that specific* trigger / area.
* You can have more than 1 ReverbTrigger in the scene (if you need areas with different reverb settings), whereas you can only have 1 out of bounds area.

There is 1 ReverbTrigger set up in the template project as an example.

## <a name="cameras"></a>Setting up broadcast cameras for replays
Although not critical for normal gameplay, it's fun to set up various cameras around your track that will be used in the post-race replays. Similar to the other topics above, this consists of placing special placeholder scenes (prefabs) as children of the special "TrackCameras" node.

The position of each child node is the position of that camera, and there are a variety of settings in the Inspector for each camera node that controls how it operates. These allow you to decide if the camera follows it's target (or is stationary), and how much it zooms in and out, etc.

The order of the nodes is important, they should be in order of proceeding around the track sequentially. There is an important parameter called *Starting Track Interp* that decides when this camera is active. This is a value between 0 and 1, and represents a percentage of completion around the track.

### Previewing the track cameras
It can be a bit confusing to know what all those parameters do, so there is a built-in way to preview the cameras in the template project. Select the "TrackCameraPreviewer" Node and look at the Inspector. There is a parameter called "Preview Car Interp" with a little slider. Drag the slider, and a dark preview car will animate around your track path.  As it animates, a red wireframe preview will update showing which camera is active, and how it will frame the action.


## <a name="intro-camera"></a>Setting up the track intro camera
You can adjust the camera fly-through that happens at the beginning of the race.  Locate the `IntroCamera` node.  You should be able to expand it and see it's child nodes, including `CameraPath`, `LookPath`, `cam` etc.

![IntroCamera heirarchy](../assets/images/intro-cam-heirarchy.jpg)

If you don't see these or can't expand it, right-click on the `IntroCamera` node and select **"Editable Children"**.

The `CameraPath` and `LookPath` are two Path3D nodes useful for making a curved path in the scene.  During the intro sequence, the Camera will animate along the `CameraPath`, and its look target (where it will focus / look at) will animate along the `LookPath`.  You can edit these paths however you like.  It's a good idea to have the `CameraPath` end somewhat close to the Car Spawn position, because after animating along the path, the camera will transition to the in-game view before the game starts.  

### Previewing the intro camera animation
![Intro Camera Previewer](../assets/images/intro-cam-preview.jpg)

You can preview the intro camera animation in a method similar to previewing the track cameras.  Select the `IntroCamera` node and check the Inspector. There is a **"Preview Interp"** slider.  Drag it and you will see the Camera animate along the path.  Also on this node are 2 curves: **"Camera Anim Curve"** and **"Camera Look Curve"**.  These control the easing of the camera and its look target during the animation.  You can adjust these for fine control over the pacing.

In order to preview the animation, you can also change the Scene view to show the intro camera's viewpoint.  Select the `cam` child node of `Intro Camera`.  Because this is a Camera3D node, in the Scene view you will see a new toggle marked **"Preview"**.  

![Camera Preview](../assets/images/intro-cam-preview-toggle.jpg)

Toggle it and the scene view will now be from the camera's perspective.  After doing this, select the `IntroCamera` node, and drag the Preview Interp slider to preview the animation.

![Intro Camera POV](../assets/images/intro-cam-pov.jpg)

## <a name="lap_counts"></a> Setting lap counts
Select the "RaceSettings" special node in the Scene tab and look at the Inspector. There is a **Per Car Class Settings** parameter which is an array. Click to expand the array, there should be 4 "ModCarClassSetting" entries in the Array. Expand these as well.  As you can see, you can set the number of laps for a race for each car class individually. You can change the lap count for each car class here. Note that all of the cheat-code cars share the same internal "car class" name of "cheat".

![Settings: Laps](../assets/images/settings-laps.jpg)

You can also set the starting time for playing this track in **Endurance mode** here as well.

## <a name="skybox"></a>Track skybox
You have 3 options for the "skybox" (background art of the surrounding environment) in your track. Select the "RaceSettings" special node in the Scene tab and look at the Inspector. You will see a drop-down called **"Built In Skybox Style"**.

If you select **"PGRC Existing"**, it means you want to use one of the skybox images from the built-in tracks in the game. You can enter the track name in the **"PGRC Skybox Name"** field and that skybox will be used for your track. Here are the internal track names you can use to refer to the track you want:

| Track | Internal Name |
| ----- | ------------- |
| Learning Lot | `tut` |
| Mount Rushmore | `mtrush` |
| San Francisco | `sanfran` |
| Seattle Airport | `seattle` |
| New Orleans Stadium | `neworleans` |
| Chicago Marina | `chicago` |
| Minnesota Mega Mall | `mall` |
| Liberty Island | `liberty` |

By selecting **"Custom Image"** for the **"Built In Skybox Style"** parameter, you can provide your own texture image to be used as the skybox in the game. Assign the texture into the **"Custom Skybox Texture"** parameter, and optionally adjust the **"Custom Skybox Scale"** and **"Custom Skybox Offset"** to fine-tune how it appears in-game.

Finally, if you don't want any built-in skybox at all, choose **"None"** for the **"Built In Skybox Style"**. This will just have a neutral grey background when played in-game. Usually if you are choosing this option, it's because you are creating your own custom skybox mesh, shader, or other content directly in your track project, and don't need the built-in skybox system at all.

## <a name="music"></a>Track music
You have 2 options for the background music for your track. Select "RaceSettings" special node in the Scene tab and look at the Inspector. You will see a drop-down called **"Built In Music Style"**

If you select **"PGRC Existing"**, it means you want to use one of the songs from the tracks included with the game.  You can enter the track name in the **"PGRC Music Name"** field, and the music from that track will play in-game.  For a list of the internal track names to use in this field, see the table in the [Track skybox](#skybox) section.

By selecting **"Custom Music"**, you can provide your own music file! Add an .ogg format file into the project (remember to place files associated with your track in `Res://Mods/your_mod_name/Tracks/your_track_name`).  Also make sure to select the .ogg file in the FileSystem tab, and then look at the Import tab (usually next to the Scene tab), and check **loop** to ensure your music loops. Finally, assign your music file into the **"Custom Music Stream"** parameter on the RaceSettings node.


## <a name="track_preview"></a>Track preview
As mentioned in the [Getting Started](#getting-started) section, your track is a Godot "scene" file with the same filename as your track name, for example `my_track.tscn`.  If you want to make a custom thumbnail for your track (a little preview diorama of the track that appears in the track select screen in-game), you can also make an associated "thumbnail" scene. 
In the template project you can see that a thumbnail scene exists as an example.  This scene is very simple, it is just a simple 3D model (of your choosing).  When you open the scene you will notice an object in the scene called `Bounds (Will Be Hidden)`.  This object helps you know how big to make your thumbnail scene so that it will be sized properly in-game.  The bounds cylinder is hidden when the thumbnail is loaded, so you can leave it in the scene, and also leave it visible and not worry about it disrupting your scene in-game.

The template thumbnail scene looks like this:

![Thumbnail Scene in editor](../assets/images/thumbnail-scene.jpg)

And in-game it looks like this:

![Thumbnail Scene in-game](../assets/images/thumbnail-scene-in-game.jpg)

**Note:** Please keep thumbnail scenes SIMPLE!  Large scenes with many meshes or items can lag the track select screen.  Your thumbnail should just be a simple object (like a figure or diorama) that helps remind players which level is which!

**Note:** if you don't want a thumbnail scene, you can safely delete it from your project.  If the thumbnail scene is missing, a placeholder scene will be used in-game.


## <a name="exporting_and_testing"></a>Exporting and Testing
In order to test your track, you need to export your project into a Godot "zip" file format. **(Note: .pck format is not supported!)**

From the **Project** menu, select **Export...**

![Project Export](../assets/images/project-export.jpg)

Then select your platform of choice (if unsure, choose "Windows") and click **"Export PCK/ZIP..."**. 

![Export Dialog](../assets/images/export-dialog.jpg)

 Make sure to save your mod with a file name that matches your mod name (remember when you [renamed the folder](#renaming-folders-important) at the beginning of this process?).  For example if your mod name is `cool_mod`, then you should save the file as `cool_mod.zip`. (pck format is not supported)

Finally, it's time to test your track in the game! This involves copying the mod file into the correct folder where you have PGRC installed.

### Copying the file into the correct folder
You will need to place your mod file into a specific folder where the game is installed on your PC. To find the game's installed location, find PGRC in your steam library, right-click it, and choose **Manage** and then **Browse Local Files**.

![Steam Local Files](../assets/images/steam-local-files.jpg)

Navigate into the `win` or `linux` folder (depending on your platform), and you should see the Game's executable files. On Windows it's `garagereally.exe`, on Linux it's `garagerally.x86_64`. If this is your first time installing a mod, you will need to create a folder called `Mods` inside this folder. After this step, the folder should look like this (pictured Example is on Windows)

![Mods Folder Example](../assets/images/mod-folder-example.jpg)

Place your mod file inside this `Mods` folder.

OK, try running PGRC and see if your track works! If the track doesn't appear, or the game crashes, you will want to check the game's log file to look for some output that hints at what is wrong. You can find the log files for the game in your save data location:

Save data locations per platform:

| Platform | Save Data Location |
| ----- | ------------- |
| Windows | `%AppData%\ParkingGarageRallyCircuit` |
| Linux | `~/.local/share/ParkingGarageRallyCircuit` |
| MacOS | `~/Library/Application Support/ParkingGarageRallyCircuit` |

... in a sub-folder called `logs`. The `godot.log` is always the most recent log from the last time you played the game. Previous logs will also be in this folder, with a timestamp in the filename to help you realize which one you want to check. The game tries to log errors and warnings when it encounters errors with mod tracks, and checking the log is the best way to debug what is going on!

### Congratulations and THANK YOU! 🤩
If you made it this far, YOU ARE AMAZING! I can't wait to see what you create! If you haven't already, consider [joining the Walaber discord](https://discord.gg/walaber) and sharing your creation with other players!


## <a name="trophy-ghosts"></a>Gold Trophy ghosts
The final touch is to record the "gold trophy" ghosts for your track!  If your track has a gold trophy ghost, it will appear in-game just like the built-in tracks, and players can earn a gold trophy if they beat your ghost.

The first step is easy: play your track with each car class (don't forget to choose a cheat car as well, all cheat cars share the same records, so pick 1 cheat car to be your ghost for this level and use it when you play).  Once you're happy with your best time ghost performances, you will need to copy the data into your mod.

Find your save data folder on your computer (see above for locations).  You should see some files associated with your track.  For the **"sample_track"** that is part of the **"walaber_sample"** mod, the files look like this:

![Trophy Ghost Source Files](../assets/images/trophy-ghost-source-files.jpg)

Copy the 4 ghost files into your mod track folder (the same folder with your main track .tscn file), and rename them into the format **"ghost_[CAR CLASS NAME].dat"**.  Again, for the template track it looks like this:

![Trophy Ghost Copied Files](../assets/images/trophy-ghost-dest-files.jpg)

Now re-export your mod!  In the track select screen you should see the trophy times displayed for each car class.  They will not immediately show up in-game though, because your local best time is equal to or better than the ghost time (since it's a copy of your own best time)... This is the same scenario as a player who has already beaten your trophy ghost!  If you want to actually verify the ghost in-game, you will need to delete the progress for your track from your `records.cfg` file in the game Save Data folder to reset your progress for your track.


## <a name="uploading"></a>Uploading to Steam Workshop
When you are done testing locally and ready to share with players around the world, it's time to upload your mod to Steam Workshop!
There are detailed instructions [here](../overview#uploading-to-workshop)


## <a name="point-to-point"></a>Creating point-to-point tracks
What's that you say? You want to make a proper **rally** track?  ok fine!  Here are the steps to make a point-to-point track:
The most important step is to set the number of laps in the [race settings](#setting-lap-counts) to zero (0) to indicate your track has no laps and should end when players cross the final checkpoint.

![Track is Point to Point checkbox](./../assets/images/track-path-is-p2p.png)

You will also want to check the "Race Is Point To Point" checkbox on the TrackPath ([see here](#setting-the-track-path--minimap)) so that the track path doesn't try to form a closed loop (this will also switch the in-game UI mini-map to have the camera follow the car instead of being fixed in the center of the map).

![info.cfg allow_endurance example](./../assets/images/info-cfg-allow-endurance.png)

Finally, endurance mode doesn't really make sense (nor work properly) for point-to-point tracks, so you should probably disable endurance mode for your track as well.  This is a simple setting in the info.cfg file for your mod, in the section for the track, set `allow_endurance=false`
There are detailed instructions [here](../overview#uploading-to-workshop)

You can see an [example project of a point-to-point track here](https://github.com/walaber-ent/pgrc-underground-lot)

## <a name="branching-paths"></a>Branching paths / checkpoints
If you want to have branching paths in your track (that include different checkpoints), it's pretty easy!  The overall # of checkpoints in a lap must be consistent, which means that if players take path A or path B, they will utlimately cross the same number of checkpoints.  This restriction keeps things very simple:  when you want to make a branching option, right-click on the "Checkpoints" node in the Scene tab, and choose "+ Add Child Node..." and in the search box type "checkpointset" and select **ModCheckpointSet**. 

![add ModCheckpointSet node](./../assets/images/add-checkpointset-node.png)

This script is an indicator that a checkpoint actually has multiple options. Put as many mod_checkpoint scenes as children of this node.  This will make all children of this node valid checkpoints for that checkpoint in the sequence.  Here is an example from the [official 'underground lot' example track](https://github.com/walaber-ent/pgrc-underground-lot)

![heirarchy example of branching checkpoints](./../assets/images/branching-checkpoints-heirarchy.png)

In the above example, checkpoint 8, 9, and 10 all have 2 options each, where as 7 and 11 are a single checkpoint.

When you create a meaningful branching path, you will probably also want to make the game aware of it so that things like the off-track detection works, and the mini-map can show the path as well.  In order to do this, right-click on the root track node and select "+ Add Child Node..." and in the search box type "pathalt" and select **ModTrackPathAltRoute**.  

![add ModTrackPathAltRoute node](./../assets/images/add-alt-route-node.png)

Similar to the TrackPath node, you can add multiple mod_track_path_point scenes as children and move them around to create the path.  Make sure that the first and last nodes in this alternate path start and end very close to the main track path.  

![example of main path and alt path in the 3D view](./../assets/images/alt-route-in-scene.png)

The game uses proximity to the main path to know when the alternate path starts and ends.

Again, you can see an [example project of a track with branching paths here](https://github.com/walaber-ent/pgrc-underground-lot)


## <a name="skybox-triggers"></a>Skybox Triggers
If your track is large and has multiple areas that look quite different, you may want to change the skybox as the player progresses through the track.  This is particularly valuable for players that have the draw distance set to "Sega Saturn" or "Arcade", which means the geometry in the distance will be culled, and players will see the skybox more often.

For example, for the [official example track 'underground'](https://github.com/walaber-ent/pgrc-underground-lot), the track takes place mostly underground, but has outdoor sections at the beginning and end.  If the skybox was always just an outdoor image, you would be seeing the sky even when you are in the underground sections.  To prevent this, this track makes use of multiple skybox triggers to change the skybox to match the section of track the player is entering.

![skybox trigger setup](./../assets/images/skybox-trigger.png)

To make a skybox trigger: Create a node with a **ModSkyboxTrigger** and then drag in the mod_trigger.tscn as a child.  Place it in the scene and then set the various settings in the Inspector to control the skybox.  The settings are very similar to those for the main [skybox](#track-skybox)


## <a name="troubleshooting"></a>Troubleshooting
**I have an `info.cfg` file in my project, but when I try to load my mod the log complains there is no `info.cfg` file!**

By default, Godot won't include all file types into the exported project (including .cfg files).  You need to ensure that Godot includes the `info.cfg` file into your export.  Do this by choosing **Project** > **Export...**, select your platform (usually Windows) and then select the **Resources** tab.  In the "Filters to export non-resource files/folders" box, add `info.cfg` to make sure it's included in the export:

![info.cfg resource exception](../assets/images/info-cfg-resource-exception.jpg)

Note: the template project has been updated with this set by default, but older mad projects created before this change will have to make this change manually.

**I made trophy ghosts but they aren't showing up in-game**

The Godot template project was updated to ensure that `.dat` files would be properly included in the exported mod.  If you started your mod before this update, you might need to manually update your Godot project.  Follow the steps above for the `info.cfg` file, and also add `*.dat` into the Filters to export non-resource files/folders box.