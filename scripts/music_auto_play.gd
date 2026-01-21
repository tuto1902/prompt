class_name MusicAutoPlay extends Node

@export var music_track: AudioStream


func _ready() -> void:
	Audio.play_music(music_track)
