extends Node

var current_track: AudioStream

@onready var music: AudioStreamPlayer = $Music


func play_music(music_track: AudioStream) -> void:
	if not music.stream:
		music.stream = music_track
		music.volume_linear = 1.0
		music.play()
	
	if music.stream == music_track:
		return
	
	current_track = music_track
	
	var fade_out_tween = create_tween()
	fade_out_tween.tween_property(music, "volume_linear", 0.0, 0.4)
	await fade_out_tween.finished

	music.stream = current_track
	music.play()
	
	var fade_in_tween = create_tween()
	fade_in_tween.tween_property(music, "volume_linear", 1.0, 0.4)
	await  fade_in_tween.finished
