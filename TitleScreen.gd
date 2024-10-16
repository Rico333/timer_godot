extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var current_time = 0
var step = 0
#var timer = Timer.new() 
var started = false
var display_string = "00 : 00"
var display = null
var volume_node = null
var time_1 = null
var time_2 = null
var start_button = null

var song_1 : AudioStream = null
var song_2 : AudioStream = null
var song_player : AudioStreamPlayer = null
var volume_num = 3


# Called when the node enters the scene tree for the first time.
func _ready():
	display = get_tree().get_root().find_node("display", true, false)
	time_1 = get_tree().get_root().find_node("time_1", true, false)
	time_2 = get_tree().get_root().find_node("time_2", true, false)
	start_button = get_tree().get_root().find_node("start_button", true, false)
	volume_node = get_tree().get_root().find_node("volume", true, false)
	song_1 = preload("res://timer_1.wav")
	song_2 = preload("res://timer_2.wav")
	song_player = AudioStreamPlayer.new()
	self.add_child(song_player)
	#var song_player = AudioStreamOGGVorbis.new()
	#song_player.set_stream(song_1)
	#song_player.set_bus("Master")
	#song_player.set_volume_db(3.0)
	#song_player.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_start_button_button_up():
	if (started):
		started = false
		start_button.set_text("start")
	else:
		started = true
		start_button.set_text("stop")
		step = 1;
		#var time_1 = get_tree().get_root().get_node("time_1")
		#var time_2 = get_tree().get_root().get_node("time_2")
		#print(get_tree().get_root().get_node("TitleScreen/CenterContainer/VBoxContainer/time_1").text)
		#print(get_tree().get_root().find_node("time_1", true, false).text)
		
		#var time_1 = get_tree().get_root().find_node("time_1", true, false).text
		#var time_2 = get_tree().get_root().find_node("time_2", true, false).text
		run_timer()
	pass # Replace with function body.
	
	
	
	
func _process(delta):
	if (started):
		if (current_time < 0 ):
			run_timer()
		else:
			current_time = current_time - delta
		display_string = str(floor(current_time / 60), ' : ', floor(fmod(current_time , 60)) )
		display.set_text(display_string)
	pass
	
	
	
	
func run_timer ():
	if (step == 1):
		current_time = time_1.text
		step = 2
		#print('step 1')
		#current_time = 365
	elif (step == 2):
		current_time = 0.16
		step = 3
		song_player.set_stream(song_2)
		volume_num = get_volume_db()
		if (volume_num > -80):
			song_player.set_volume_db(volume_num)
			song_player.play()
		#print('step 2')
	elif (step == 3):
		current_time = time_2.text
		step = 4
		#print(step)
		#current_time = 2
		#print('step 3')
	else:
		current_time = 0.16
		step = 1
		song_player.set_stream(song_1)
		volume_num = get_volume_db()
		if (volume_num > -80):
			song_player.set_volume_db(volume_num)
			song_player.play()
		#print('step 4')
		
	current_time = float(current_time) * 60
	#current_time = float(current_time)
	#print( current_time )
	#timer.connect("timeout",self,"timeout") 
	#timer.wait_time = current_time
	#timer.one_shot = true
	#add_child(timer)
	#movespeed=1000
	#timer.start()
	pass

func timeout ():
	pass
	
	
func get_volume_db ():
	# 200 = 104  100 = 0  0 = -80
	# 130 - 100 = 30  30 * 0.24 = 7.2
	# 40 - 100  = -60
	# range -80db to 24db
	# setted range -24db to 24db
	volume_num = float(volume_node.text)
	
	if (volume_num < 100):
		if (volume_num <= 0):
			volume_num = -80
			volume_node.set_text('0')
		else:
			#volume_num = -(8 - (volume_num  * 0.8))
			volume_num = -(24 - (volume_num  * 0.24))
	else:
		if (volume_num > 130):
			volume_num = 130
			volume_node.set_text('130')
		volume_num = (volume_num - 100) * 0.24
		
	return volume_num
