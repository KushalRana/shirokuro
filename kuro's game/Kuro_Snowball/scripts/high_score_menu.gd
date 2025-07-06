extends Node2D

func _ready():
	SilentWolf.Scores.get_scores()
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
		
		
