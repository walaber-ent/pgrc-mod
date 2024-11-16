extends Node
class_name ModRaceSettings

@export_category("Laps")
@export var per_car_class_settings : Array[ModCarClassSetting] = []

enum BuiltinSkyboxStyle
{
	PGRCExisting,
	CustomImage,
	None
}

@export_category("Endurance")
@export var endurance_start_seconds : float = 30.0

@export_category("Skybox")
@export var built_in_skybox_style : BuiltinSkyboxStyle = BuiltinSkyboxStyle.PGRCExisting
@export var pgrc_skybox_name : String = "tut"
@export var custom_skybox_texture : Texture2D = null
@export var custom_skybox_scale : float = 0.4
@export var custom_skybox_offset : Vector2 = Vector2(0.0, 0.0)

enum BuiltinMusicStyle
{
	PGRCExisting,
	CustomMusic
}

@export_category("Music")
@export var built_in_music_style : BuiltinMusicStyle = BuiltinMusicStyle.PGRCExisting
@export var pgrc_music_name : String = "tut"
@export var custom_music_stream : AudioStream = null
