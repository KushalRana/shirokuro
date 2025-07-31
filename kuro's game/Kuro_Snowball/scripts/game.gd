extends Node2D

#var srn #to hold screen size
var force #affects acceleration
var max_spd
var jump_multiplier

#Joystick position
var srn_x
var srn_y
#if is press and drag
var joystick_on
var base_pos
var dir

#scoring
var cur_height
var max_height
var survival_time
var player_base_height

var snowball_base_spd #every 0.5 seconds 1 ball
var snowball_spd_incr #each increment of difficulty minus 0.01 second
var diff_incr_interval

var srn_scroll_interval

var game_over
var overflow_snowball_limit

var last_obstacle_y
var obstacle_interval
var rnd

var snowball_scale
var jump_button_diameter

#Generate snowball
@export var snowball: PackedScene
#Generate gameover menu
@export var game_over_menu: PackedScene


func _ready():
	#srn=DisplayServer.screen_get_size()
	Globals.srn=DisplayServer.window_get_size()
	#For player to fall onto the ground
	$Player.global_position=Vector2(50.0,-10)
	
	#force=20.0
	#max_spd=300.0
	force=9.0
	jump_multiplier=80.0
	max_spd=150.0
	$Player/RigidBody2D.contact_monitor=true
	$Player/RigidBody2D.max_contacts_reported=20; 
	
	$Snowball_Timer.start()
	
	srn_x=Globals.srn.x/2
	srn_y=Globals.srn.y/2
	joystick_on=false
	base_pos = Vector2(0,0)
	dir=0
	
	cur_height=0.0
	max_height=0.0
	survival_time=0.0
	player_base_height=0.0
	
	#Position camera	
	$Camera2D.global_position=Vector2(Globals.srn.x/2,$Player/RigidBody2D.global_position.y)
	$Camera2D.offset=Vector2(0.0,-Globals.srn.y/4) #player 2/3 from top of screen
	srn_scroll_interval = Globals.srn.y/8
	
	#screen has shifted to slightly below ground so placing button on ground level is sufficient
	#then move up with each offset
	var jump_button_scale=1.0/5*Globals.srn.x/($JumpButton.shape.radius*2.0)
	jump_button_diameter=($JumpButton.shape.radius * 2.0 * jump_button_scale)
	$JumpButton.scale=Vector2(jump_button_scale,jump_button_scale)
	$JumpButton.position=Vector2(Globals.srn.x-10-jump_button_diameter , $Camera2D.global_position.y + $Camera2D.offset.y + Globals.srn.y/2 - jump_button_diameter-10)
	$Info.position=Vector2(0.0,$Camera2D.global_position.y + $Camera2D.offset.y - Globals.srn.y/2)
	$Info.text="Game Loading"
	
	
	#Update timer which refresh display info
	$Update_Timer.start()
	
	snowball_base_spd=0.5 #every 0.5 seconds 1 ball
	snowball_spd_incr=0.01 #each increment of difficulty minus 0.01 second
	diff_incr_interval=3
	game_over=false
	
	#if stationary snowball exceeds this amount above screen, gameover
	overflow_snowball_limit=10
	
	last_obstacle_y=0.0 #to hwlp limit obstacles placed
	obstacle_interval=Globals.srn.y/2
	rnd=RandomNumberGenerator.new()
	rnd.randomize()
	
	scaling_init()

func scaling_init():
	if $Player.player_scale>0:
		force+=($Player.player_scale*force*2/3)
		max_spd+=($Player.player_scale*max_spd*2/3)
		$Info.label_settings.font_size=6.0*$Player.player_scale
		$BackGround.change_scale($Player.player_scale/2.5)
	#Initialize separately based on image
	snowball_scale=-1

func _physics_process(_delta):
	#keyboard handle
	if Input.is_action_pressed("Move_Right"):
		move_right()
	if Input.is_action_pressed("Move_Left"):
		move_left()

	if Input.is_action_pressed("Jump") && can_jump():
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
	#Dropping from abit higher is fine
	dup.position=Vector2(randf_range(0,Globals.srn.x) , $Camera2D.global_position.y + $Camera2D.offset.y - 1.5 * Globals.srn.y)
	##Add speed to prevent detection of gameover
	dup.find_child("RigidBody2D").linear_velocity=Vector2(0.0,0.01)
	#handle scaling to 1/5th the screen width
	if snowball_scale<0:
		snowball_scale=1.0/5*Globals.srn.x/dup.find_child("RigidBody2D").find_child("Sprite2D").texture.get_width()
	dup.find_child("RigidBody2D").find_child("Sprite2D").scale=Vector2(snowball_scale,snowball_scale)
	dup.find_child("RigidBody2D").find_child("CollisionShape2D").scale*=Vector2(snowball_scale,snowball_scale)
	add_child(dup)
	
	dup.add_to_group("new_snowballs")
	
#Handling joystick
func _input(event):
	#if screen drag at lower left, set flag to move player. Actual movement in _process
	if event is InputEventScreenDrag && event.position.x<srn_x && event.position.y>srn_y:
		dir=event.get_relative().x
	#joystick release if not screen release on the jump button
	if event is InputEventScreenTouch && event.is_released() && ((Globals.srn.x-event.position.x-jump_button_diameter)>0  || (Globals.srn.y-event.position.y-jump_button_diameter)>0):
		dir=0.0
			
func move_right():
	$Player/RigidBody2D.apply_impulse(Vector2(force,0.0))
	$Player/RigidBody2D/AnimatedSprite2D.flip_h=false
		
func move_left():
	$Player/RigidBody2D.apply_impulse(Vector2(-force,0.0))
	$Player/RigidBody2D/AnimatedSprite2D.flip_h=true
		
func jump():
	$Player/RigidBody2D.apply_impulse(Vector2(0.0, -force*jump_multiplier))
	
func can_jump():
	var num_contacts=0
	for cb in $Player/RigidBody2D.get_colliding_bodies():
		if cb.name=="LeftWall":
			continue
		elif cb.name=="RightWall":
			continue
		elif cb.global_position.y > $Player/RigidBody2D.global_position.y:
			num_contacts+=1
	return num_contacts>0

func cap_spd():
#cap the speed
	if $Player/RigidBody2D.linear_velocity.x>max_spd:
		$Player/RigidBody2D.linear_velocity=Vector2(max_spd,$Player/RigidBody2D.linear_velocity.y)
	if $Player/RigidBody2D.linear_velocity.x<-max_spd:
		$Player/RigidBody2D.linear_velocity=Vector2(-max_spd,$Player/RigidBody2D.linear_velocity.y)
	if $Player/RigidBody2D.linear_velocity.y<-max_spd:
		$Player/RigidBody2D.linear_velocity=Vector2($Player/RigidBody2D.linear_velocity.x,-max_spd)

func move_screen():
	#Move camera with player along the Y axis
	var offset = $Player/RigidBody2D.global_position.y - $Camera2D.global_position.y 
	if offset > srn_scroll_interval:
		$Camera2D.global_position=Vector2(Globals.srn.x/2,$Player/RigidBody2D.global_position.y - srn_scroll_interval)
	elif offset < -srn_scroll_interval:
		$Camera2D.global_position=Vector2(Globals.srn.x/2,$Player/RigidBody2D.global_position.y + srn_scroll_interval)
	
	$JumpButton.position=Vector2(Globals.srn.x-10-jump_button_diameter , $Camera2D.global_position.y + $Camera2D.offset.y + Globals.srn.y/2 - jump_button_diameter-10)
	$Info.position=Vector2(0.0,$Camera2D.global_position.y + $Camera2D.offset.y - Globals.srn.y/2)
	
	$BackGround.update_pos($Player/RigidBody2D.position)
	
	var cur_pos_y=$Camera2D.global_position.y + $Camera2D.offset.y - Globals.srn.y/2
	#if scroll screen up, check if should add an obstacle
	if(cur_pos_y<(last_obstacle_y-obstacle_interval) && rnd.randi()%2): #decide if should add obstacle
		last_obstacle_y=cur_pos_y
		var flip=rnd.randi()%2
		var obstacle_x = 0.0
		if(flip): #decide if should be left or right
			obstacle_x=Globals.srn.x
		$Obstacles.add_obstacle(rnd.randi()%6+1,Vector2(obstacle_x, last_obstacle_y),flip)

func _on_update_timer_timeout() -> void:
	if game_over == true:
		$Info.text+="\nGame Over"
		$Snowball_Timer.stop()
		$Update_Timer.stop()
		Globals.cur_score=max_height
		Globals.cur_time=survival_time
		Globals.refresh_score()
		var dup=game_over_menu.instantiate()
		dup.global_position=$Camera2D.global_position+$Camera2D.offset-Globals.srn/2.0
		dup.move_to_front()
		add_child(dup)
	
	else:
		if player_base_height==0.0:
			player_base_height=$Player/RigidBody2D.global_position.y
		#Display update
		cur_height=-snapped(($Player/RigidBody2D.global_position.y-player_base_height)/10,0.01)
		#apply scaling to the score (to be similar to development's phase's score)
		cur_height*=snapped(2.5/$Player.player_scale,0.01)
		max_height=max(max_height,cur_height)
		survival_time+=$Update_Timer.wait_time
		
		$Info.text="Current Height :" + str(cur_height) + " M\n"
		$Info.text+="Max Height: " + str(max_height) + " M\n"
		$Info.text+="Survival Time: " + str(snapped(survival_time,1)) + " seconds"
		#debug:
		#$Info.text+="\nButton: " + str($JumpButton.global_position.x-$JumpButton.shape.get_rect().size.x) + " ,"
		
		#Difficulty up every 10 seconds
		#but cap at 0.05 sec interval
		if $Snowball_Timer.wait_time>0.05:
			var spd=snowball_base_spd-snowball_spd_incr*snapped(survival_time/diff_incr_interval,1)
			spd=max(0.05,spd) #cannot go below 0.05 as per godot
			$Snowball_Timer.wait_time=spd
						
func check_gameOver():
	var srn_top_y=$Camera2D.global_position.y+$Camera2D.offset.y-Globals.srn.y/2
	var danger_zone=$Camera2D.global_position.y+$Camera2D.offset.y-Globals.srn.y/4
	var stationary_count=0
	
	var snowballs = get_tree().get_nodes_in_group("new_snowballs")
	for snball in snowballs:
		var ball=snball.find_child("RigidBody2D")
		if game_over == false && ball.linear_velocity.y <= 0.0:
			#nudge balls above the danger zone 
			#to prevent balls stuck on cliffs
			if ball.global_position.y < danger_zone:
				#if left nudge right, else nudege left
				if ball.global_position.x < Globals.srn.x/2 :
					ball.apply_impulse(Vector2(1.0,0.0))
				else:
					ball.apply_impulse(Vector2(-1.0,0.0))
			#if not moving and exceed top of screen then gameover
			if ball.global_position.y < srn_top_y:
				#game_over=true
				stationary_count+=1
			#snowballs below player are not application to gameover logic
			if ball.global_position.y > $Player/RigidBody2D.position.y:
				snball.remove_from_group("new_snowballs")
				
	if stationary_count>overflow_snowball_limit:
		game_over=true
		
