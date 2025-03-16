---
layout: page
title: "Modding Overview"
permalink: /overview/
---

Parking Garage Rally Circuit has some built-in mod support that allows players to:
* Create new custom tracks

## TOPICS
* [Things you need to make a mod](#requirements)
* [Getting Started](#getting-started)
* [Getting the Template](#template)
* [A Mod can contain multiple items](#multiple-items)
* [Uploading your mod to Steam Workshop](#uploading-to-workshop)

## <a name="requirements"></a>Things you need to make a mod
In order to create your own mod for PGRC, you will need:
* A copy of the game [purchased on Steam](https://store.steampowered.com/app/2737300/Parking_Garage_Rally_Circuit/)
* Godot engine **4.2** editor [downloaded on your PC](https://godotengine.org/download/archive/4.2.2-stable/) **NOTE THE VERSION**, use Godot 4.2, not latest!
* A way to make or manipulate 3D models such as [Blender](https://www.blender.org/download/)
* A way to make or manipulate images / textures such as [aseprite](https://www.aseprite.org/)

## <a name="getting-started"></a>Getting started
Walaber has created a template project that you can use as a starting point to make your new mod.  To make your own mod you will:
1. Download the template
2. Modify the template by renaming things and adding your own content
3. Package your mod and test it in-game

## <a name="template"></a>Getting the [template][repo]
If you are not familiar with github or git in general, the [template site][repo] might feel a bit intimidating.  Git is a way to publish a project, and also track changes to that project over time.

If you are familiar with git, it is strongly recommended that you fork the [repository][repo] for the template.  This will let you use git yourself to track and save your changes to your mod, and also make it much easier to merge in changes when/if the mod support for PGRC has updates that require changes to your mod.

If you have no idea what "fork" or "repository" even mean, you can also just [download a .zip](https://github.com/walaber-ent/pgrc-mod/archive/refs/heads/main.zip) file of the template to your computer, unzip it, and be done with it!  This will work just fine, but if you make a really cool mod, and then in the future Walaber updates the mod system in the game in a way that requires your mod to be updated to work with the new system, it will be a bit more work to update your mod manually.

## <a name="multiple-items"></a>A Mod can contain multiple items
It's important to know that a single "mod" (packaged mod built from a single godot project) can contain *multiple* tracks or other content!  This way, you don't need to maintain a separate mod project for each individual thing you create, and you can also package multiple tracks into a "pack" for players to easily install together.  There are more details in the [creating a track](../track) step-by-step guide.

## <a name="uploading-to-workshop"></a>Uploading your mod to Steam Workshop
Once you have created and tested your mod locally, you can upload it to Steam Workshop for other players to enjoy!  This step is done using Parking Garage Rally Circuit itself.  Launch the game through Steam, and from the main menu, select "manage mods".
![Manage Mods](../assets/images/upload_to_workshop_manage_mods.jpg)

Switch to the "MODS I MADE" tab.  Here you can manage your mods to upload or update them on Workshop.  Click "ADD A MOD..." and then find your mod's .zip file in the file selector.  After this, write a nice description for your mod, and select your preview image.
*NOTES ON PREVIEW IMAGES*
A common cause for errors when attempting to upload/update a mod on Workshop actually comes from the preview image.  The preview image has the following requirements:
- It should be 16:9 aspect ratio (ideally a 1920x1080 image)
- The file size must be under *1MB* (consider using .jpg format to ensure a small file size)

![Mods I Made screen](../assets/images/upload_to_workshop_mods_i_made.jpg)

Once all this is set, use "UPLOAD NOW" or "UPDATE NOW" to upload your mod to Workshop.  If all goes well, you will see the "Workshop Status" update to say "Uploaded to workshop (XXXXXXX)", where the "XXXXXXX" part is a number (the workshop ID for your mod).


[repo]:https://github.com/walaber-ent/pgrc-mod