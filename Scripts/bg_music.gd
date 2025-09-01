extends Node

@onready var music_track_1: AudioStreamPlayer = $Track_1
@onready var music_track_2: AudioStreamPlayer = $Track_2
@onready var music_track_3: AudioStreamPlayer = $Track_3
@onready var music_track_4: AudioStreamPlayer = $Track_4

var tracks: Array[AudioStreamPlayer]

func _ready():
	randomize()
	tracks = [music_track_1, music_track_2, music_track_3, music_track_4]
	
	for t in tracks:
		t.connect("finished", Callable(self, "_on_track_finished"))
	
	if tracks.size() > 0:
		random_track()

func _on_track_finished():
	random_track()

func random_track():
	if tracks.size() > 0:
		var index = randi_range(0, tracks.size() - 1)
		for t in tracks:
			t.stop()
		tracks[index].play()
	else:
		print("Error: no music loaded")
