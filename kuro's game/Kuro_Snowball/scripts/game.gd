extends Node2D

var srn #to hold screen size
var force #affects acceleration
var max_spd

#Joystick position
var srn_x
var srn_y
#if is press and drag
var joystick_on
var base_pos
var dir

var camera_y_start
var camera_shift_interval
var char_init_offset

#scoring
var cur_height
var max_height
var survival_time

var snowball_base_spd #every 0.5 seconds 1 ball
var snowball_spd_incr #each increment of difficulty minus 0.01 second
var diff_incr_interval

var game_over
var last_player_pos
var max_ticks_not_moving
var tick_player_not_moving


var last_obstacle_y
var obstacle_interval
var rnd

#Generate snowball
@export var snowball: PackedScene

func _ready():
	#srn=DisplayServer.screen_get_size()
	srn=DisplayServer.window_get_size()
	#$Player.apply_scale(Vector2(50.0,50.0))
	#$Player.position=Vector2(50.0,srn.y-10)
	$Player.position=Vector2(50.0,-10)
	
	force=20.0
	max_spd=300.0
	$Player/RigidBody2D.contact_monitor=true
	$Player/RigidBody2D.max_contacts_reported=20; 
	
	#var dup=snowball.instantiate()
	#dup.position=Vector2(100,0)
	#add_child(dup)
	
	$Snowball_Timer.start()
	
	srn_x=srn.x/2
	srn_y=srn.y/2
	joystick_on=false
	base_pos = Vector2(0,0)
	dir=0
	
	cur_height=0.0
	max_height=0.0
	survival_time=0.0
	
	#Start camera abit lower so ground can be seen
	camera_y_start = srn.y-20.0 #The top left of camera
	camera_shift_interval = 20 #smaller = smoother scrolling
	$Camera2D.position=Vector2(srn.x/2,-camera_y_start/2)
	char_init_offset=-1 #uninitialized
	
	#screen has shifted to slightly below ground so placing button on ground level is sufficient
	#then move up with each offset
	$JumpButton.position=Vector2(srn.x-10-$JumpButton.shape.radius,$Camera2D.offset.y-$JumpButton.shape.radius)
	$Info.position=Vector2(0.0,-camera_y_start)
	$Info.text="Game Loading"
	
	
	#Update timer which refresh display info
	$Update_Timer.start()
	
	snowball_base_spd=0.5 #every 0.5 seconds 1 ball
	snowball_spd_incr=0.01 #each increment of difficulty minus 0.01 second
	diff_incr_interval=3
	game_over=false
	
	last_player_pos=Vector2($Player/RigidBody2D.global_position)
	max_ticks_not_moving=10 #timer interval 0.5 sec so 5 sec is 10 ticks
	tick_player_not_moving=0
	
	last_obstacle_y=0.0 #to hwlp limit obstacles placed
	obstacle_interval=srn.y/3
	rnd=RandomNumberGenerator.new()
	rnd.randomize()
	

func _process(delta):
	#keyboard handle
	if Input.is_action_pressed("Move_Right"):
		move_right()
	if Input.is_action_pressed("Move_Left"):
		move_left()

	if Input.is_action_pressed("Jump"):
		if $Player/RigidBody2D.get_colliding_bodies().size()>0 && $Player/RigidBody2D.get_colliding_bodies()[0].name!="LeftWall" && $Player/RigidBody2D.get_colliding_bodies()[0].name!="RightWall":
			jump()
		elif $Player/RigidBody2D.get_colliding_bodies().size()>1:
			jump()
		
	#Joystick handle
	if dir>0:
		move_right()
	elif dir<0:
		move_left()
		
	# Slide off walls
	$Player/RigidBody2D.apply_impulse(Vector2(0.0,0.1))
	
	#cap the speed
	cap_spd()
	
	#scroll up as player proceeds
	move_screen()
		
	check_gameOver()
		
	
func _on_snowball_timer_timeout() -> void:
	var dup=snowball.instantiate()
<<<<<<< HEAD
	#dup.position=Vector2(randf_range(0,srn.x-200),0)
	dup.position=Vector2(randf_range(0,srn.x),-camera_y_start+$Camera2D.offset.y)
=======
	#Dropping from abit higher is fine
	dup.position=Vector2(randf_range(0,srn.x) , $Camera2D.global_position.y + $Camera2D.offset.y - 1.5 * srn.y)
>>>>>>> cb883e5a4419476826e89b55f8a2aafe991b7504
	##Add speed to prevent detection of gameover
	dup.find_child("RigidBody2D").linear_velocity=Vector2(0.0,0.01)
	add_child(dup)
	
	dup.add_to_group("new_snowballs")
	
#Handling joystick
func _input(event):
	#if screen touched
	if event is InputEventScreenTouch:
		#And is pressed at bottom left (can fine tune location)
		if event.is_released():
			joystick_on=false
			base_pos=Vector2(0.0,0.0)
			dir=0
		elif event.is_pressed() && event.position.x<srn_x && event.position.y>srn_y:
			#the joystick is pressed on and start point is recorded
			joystick_on=true
			base_pos=event.position
		#else turn joystick off just in case
		else:
			joystick_on=false
			base_pos=Vector2(0.0,0.0)
			dir=0
	#if is screen drag
	elif event is InputEventScreenDrag:
		#if joystick is on then act on it
		if joystick_on == true:
			#The action here is to apply force in the direction but can be other logics
			dir=event.position.x-base_pos.x
			if dir>0:
				move_right()
			elif dir<0:
				move_left()
			
func move_right():
	$Player/RigidBody2D.apply_impulse(Vector2(force,0.0))
	$Player/RigidBody2D/AnimatedSprite2D.flip_h=false
		
func move_left():
	$Player/RigidBody2D.apply_impulse(Vector2(-force,0.0))
	$Player/RigidBody2D/AnimatedSprite2D.flip_h=true
		
func jump():
	$Player/RigidBody2D.apply_impulse(Vector2(0.0, -force*70))
	
func cap_spd():
#cap the speed
	if $Player/RigidBody2D.linear_velocity.x>max_spd:
		$Player/RigidBody2D.linear_velocity=Vector2(max_spd,$Player/RigidBody2D.linear_velocity.y)
	if $Player/RigidBody2D.linear_velocity.x<-max_spd:
		$Player/RigidBody2D.linear_velocity=Vector2(-max_spd,$Player/RigidBody2D.linear_velocity.y)
	if $Player/RigidBody2D.linear_velocity.y<-max_spd:
		$Player/RigidBody2D.linear_velocity=Vector2($Player/RigidBody2D.linear_velocity.x,-max_spd)

func move_screen():
	#if player position is above mid screen, scroll screen up
	if ($Player/RigidBody2D.position.y-char_init_offset) < ($Camera2D.offset.y-camera_shift_interval*14):
		$Camera2D.offset=Vector2(0.0,$Camera2D.offset.y-camera_shift_interval/4)
		$JumpButton.position=Vector2(srn.x-10-$JumpButton.shape.radius,$Camera2D.offset.y-$JumpButton.shape.radius)
		$Info.position=Vector2(0.0,-camera_y_start+$Camera2D.offset.y)
		
		#if scroll screen up, check if should add an obstacle
		if($Camera2D.offset.y<(last_obstacle_y-obstacle_interval) && rnd.randi()%2): #decide if should add obstacle
			last_obstacle_y=$Camera2D.offset.y
			var flip=rnd.randi()%2
			var obstacle_x = 0.0
			if(flip): #decide if should be left or right
				obstacle_x=srn.x
			$Obstacles.add_obstacle(rnd.randi()%6+1,Vector2(obstacle_x,-camera_y_start+$Camera2D.offset.y+200),flip)

func _on_update_timer_timeout() -> void:
	#Initialize distance
	if char_init_offset==-1:
		char_init_offset=$Player/RigidBody2D.position.y
		
	if game_over == true:
		$Info.text+="\nGame Over"
		$Snowball_Timer.stop()
		$Update_Timer.stop()
	
	else:
		#Display update
		cur_height=snapped((char_init_offset-$Player/RigidBody2D.position.y)/10,0.01)
		max_height=max(max_height,cur_height)
		survival_time+=$Update_Timer.wait_time
		
		$Info.text="Current Height :" + str(cur_height) + " M\n"
		$Info.text+="Max Height: " + str(max_height) + " M\n"
		$Info.text+="Survival Time: " + str(snapped(survival_time,1)) + " seconds"
		
		##debugging info
		$Info.text+="\nActive_Movement: " + str(last_player_pos.distance_to($Player/RigidBody2D.global_position))
		
		#Difficulty up every 10 seconds
		#but cap at 0.01 sec interval
		if $Snowball_Timer.wait_time>0.01:
			var spd=snowball_base_spd-snowball_spd_incr*snapped(survival_time/diff_incr_interval,1)
			spd=max(0.01,spd) #cannot go below 0.01
			$Snowball_Timer.wait_time=spd
			
		#chk if player moving
		if(last_player_pos.distance_to($Player/RigidBody2D.global_position)<30.0):
			tick_player_not_moving+=1
		else:
			tick_player_not_moving=0
		last_player_pos = Vector2($Player/RigidBody2D.global_position)
			
func check_gameOver():
	var camera=$Camera2D.global_position+$Camera2D.offset
	var srn_top_y=camera.y-srn.y/2 + 50
	#if covered by snowballs up to depth of 1/3 the screen, assumed stuck
	var player_buried_y = $Player/RigidBody2D.global_position.y-srn.y/3
	
	var snowballs = get_tree().get_nodes_in_group("new_snowballs")
	for snball in snowballs:
		if game_over == false && snball.find_child("RigidBody2D").linear_velocity.y < 0.0:
			if snball.find_child("RigidBody2D").global_position.y < player_buried_y && tick_player_not_moving >= max_ticks_not_moving:
				game_over=true
			if snball.find_child("RigidBody2D").global_position.y < srn_top_y && tick_player_not_moving >= max_ticks_not_moving:
				game_over=true
			#snowballs that are stopped or bounced do not need to be checked anymore
			if snball.find_child("RigidBody2D").global_position.y > $Player/RigidBody2D.position.y:
				snball.remove_from_group("new_snowballs")
		
