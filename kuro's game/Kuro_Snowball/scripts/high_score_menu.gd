extends Node2D

var mandatory_number_of_top_scores = 5
var score_around_player = 3

func _on_position_get(param):
	var root = $Tree.get_root()
	var node
	var above=param["scores_above"]
	var below=param["scores_below"]
	#create separator if below top scores
	if ((int(param["position"])-score_around_player)>(mandatory_number_of_top_scores+1)):
		node=$Tree.create_item(root)
		node.set_text(0,":")
		node.set_text(1,":")
		node.set_text(2,":")
		node.set_text(3,":")
	for s in above:
		var pos=int(s.position)			
		if(pos>mandatory_number_of_top_scores):
			node=$Tree.create_item(root)
			node.set_text(0,str(pos))
			node.set_text(1,str(s.metadata["p_name"]))
			node.set_text(2,str(s.score) + " m")
			node.set_text(3,str(s.metadata["time"]) + "s")
			
			if s.player_name==str(Globals.player_id):
				node.set_custom_color(0,Color(255.0,0.0,0.0))
				node.set_custom_color(1,Color(255.0,0.0,0.0))
				node.set_custom_color(2,Color(255.0,0.0,0.0))
				node.set_custom_color(3,Color(255.0,0.0,0.0))
				
	#For debugging
	#node=$Tree.create_item(root)
	#node.set_text(0,str(param["position"]))
	#node.set_text(1,"Blank")
	
	#The current score pass in takes up a space and the rest are pushed down
	#So actual position is -1
	for s in below:
		node=$Tree.create_item(root)
		node.set_text(0,str(int(s.position-1)))
		node.set_text(1,str(s.metadata["p_name"]))
		node.set_text(2,str(s.score) + " m")
		node.set_text(3,str(s.metadata["time"]) + "s")
		
		if s.player_name==str(Globals.player_id):
			node.set_custom_color(0,Color(255.0,0.0,0.0))
			node.set_custom_color(1,Color(255.0,0.0,0.0))
			node.set_custom_color(2,Color(255.0,0.0,0.0))
			node.set_custom_color(3,Color(255.0,0.0,0.0))
			
	$Loading_Text.text=""	

func _ready():
	#Set Screen to loading
	$Loading_Text.position=Vector2(0.0,0.0)
	$Loading_Text.size=Vector2(Globals.srn.x,Globals.srn.y)
	
	#SilentWolf.Scores.sw_get_position_complete.connect(_on_position_get)
	SilentWolf.Scores.sw_get_scores_around_complete.connect(_on_position_get)
	
	#scale the button
	var scale_x=2.0/9.0*Globals.srn.x/$Back_Button.texture_normal.get_width()
	#var scale_y=2.0/9.0*Globals.srn.y/$Back_Button.texture_normal.get_height()
	$Back_Button.scale=Vector2(scale_x,scale_x)
	$Back_Button.position=Vector2(7.0/9.0*Globals.srn.x - 10, Globals.srn.y - $Back_Button.texture_normal.get_height()*scale_x - 10)
	
	#scale button text
	var scale_text=7.0/9.0*$Back_Button.texture_normal.get_height()/$Back_Button/Label.size.y
	$Back_Button/Label.scale=Vector2(scale_text,scale_text)
	$Back_Button/Label.position=Vector2(10.0,10.0)
	
	var player_found=false
	if Globals.player_id==null:
		player_found=true
	SilentWolf.Scores.get_scores(mandatory_number_of_top_scores)
	await SilentWolf.Scores.sw_get_scores_complete
	var p=1
	$Tree.set_column_title(0,"Rank")
	$Tree.set_column_title(1,"Player")
	$Tree.set_column_title(2,"Score")
	$Tree.set_column_title(3,"Time")
	$Tree.size=Vector2(Globals.srn.x,Globals.srn.y)
	var root = $Tree.create_item()
	for s in SilentWolf.Scores.scores:
		var node=$Tree.create_item(root)
		#Player_id is in s.player_name)
		#Rank
		#node.set_text(0,str(s.position))
		node.set_text(0,str(p))
		p+=1
		#Player Name
		node.set_text(1,str(s.metadata["p_name"]))
		#Player Score (how high)
		node.set_text(2,str(s.score) + " m")
		#Time Survived
		node.set_text(3,str(s.metadata["time"]) + "s")
		if player_found==false && s.player_name==str(Globals.player_id):
			player_found=true
			node.set_custom_color(0,Color(255.0,0.0,0.0))
			node.set_custom_color(1,Color(255.0,0.0,0.0))
			node.set_custom_color(2,Color(255.0,0.0,0.0))
			node.set_custom_color(3,Color(255.0,0.0,0.0))
		
	if player_found==false && Globals.player_id!=null:
		SilentWolf.Scores.get_scores_around(Globals.player_score,score_around_player)
	else:
		#clear loading text
		$Loading_Text.text=""
		
