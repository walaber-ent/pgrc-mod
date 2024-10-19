extends Node3D
class_name ModTrack

@onready var car_spawn: Marker3D = %CarSpawn
@onready var checkpoints: Node3D = %Checkpoints
@onready var track_path: ModTrackPath = %TrackPath
@onready var out_of_bounds: Node3D = %OutOfBounds
@onready var spectator_cars: Node3D = %SpectatorCars
