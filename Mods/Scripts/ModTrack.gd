extends Node3D
class_name ModTrack

@onready var race_settings: ModRaceSettings = %RaceSettings
@onready var car_spawn: Marker3D = %CarSpawn
@onready var checkpoints: Node3D = %Checkpoints
@onready var track_path: ModTrackPath = %TrackPath
@onready var barriers: Node3D = %Barriers
@onready var out_of_bounds: Node3D = %OutOfBounds
@onready var spectator_cars: Node3D = %SpectatorCars
@onready var track_cameras: Node3D = %TrackCameras
@onready var track_camera_previewer: ModTrackCameraPreviewer = %TrackCameraPreviewer
@onready var intro_camera: ModTrackIntroCamera = %IntroCamera
