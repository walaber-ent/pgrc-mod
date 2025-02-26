extends Node3D
class_name ModSkyboxTrigger

@export var built_in_skybox_style : ModRaceSettings.BuiltinSkyboxStyle = ModRaceSettings.BuiltinSkyboxStyle.PGRCExisting
@export var pgrc_skybox_name : String = "tut"
@export var custom_skybox_texture : Texture2D = null
@export var custom_skybox_scale : float = 0.4
@export var custom_skybox_offset : Vector2 = Vector2(0.0, 0.0)
