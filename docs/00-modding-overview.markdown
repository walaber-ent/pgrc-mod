---
layout: page
title: "Modding Overview"
permalink: /overview/
---

Parking Garage Rally Circuit has some built-in mod support that allows players to:
* Create new custom tracks

## Things you need to make a mod
In order to create your own mod for PGRC, you will need:
* A copy of the game [purchased on Steam](https://store.steampowered.com/app/2737300/Parking_Garage_Rally_Circuit/)
* Godot engine 4.2 editor [downloaded on your PC](https://godotengine.org/download/archive/4.2.2-stable/)
* A way to make or manipulate 3D models such as [Blender](https://www.blender.org/download/)
* A way to make or manipulate images / textures such as [aseprite](https://www.aseprite.org/)

## Getting started
Walaber has created a template project that you can use as a starting point to make your new mod.  To make your own mod you will:
1. Download the template
2. Modify the template by renaming things and adding your own content
3. Package your mod and test it in-game

## Getting the [template][repo]
If you are not familiar with github or git in general, the [template site][repo] might feel a bit intimidating.  Git is a way to publish a project, and also track changes to that project over time.

If you are familiar with git, it is strongly recommended that you fork the [repository][repo] for the template.  This will let you use git yourself to track and save your changes to your mod, and also make it much easier to merge in changes when/if the mod support for PGRC has updates that require changes to your mod.

If you have no idea what "fork" or "repository" even mean, you can also just [download a .zip](https://github.com/walaber-ent/pgrc-mod/archive/refs/heads/main.zip) file of the template to your computer, unzip it, and be done with it!  This will work just fine, but if you make a really cool mod, and then in the future Walaber updates the mod system in the game in a way that requires your mod to be updated to work with the new system, it will be a bit more work to update your mod manually.

## A Mod can contain multiple items
It's important to know that a single "mod" (packaged mod built from a single godot project) can contain *multiple* tracks or other content!  This way, you don't need to maintain a separate mod project for each individual thing you create, and you can also package multiple tracks into a "pack" for players to easily install together.  There are more details in the [creating a track](../track) step-by-step guide.



[repo]:https://github.com/walaber-ent/pgrc-mod