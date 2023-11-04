extends Node2D

onready var tongue = $TongueLinks;
var direction = Vector2()
var tip = Vector2()

const SPEED = 50

var flying = false;
var hooked = false;

func shoot(dir: Vector2) -> void:
	print(dir)
	direction = dir.normalized()
	flying = true;
	tip = self.global_position;
	
func release():
	flying = false;
	hooked = false;
	
func _process(delta):
	self.visible = flying or hooked;
	if not self.visible:
		return
	var tip_loc = to_local(tip)
	# We rotate the links (= chain) and the tip to fit on the line between self.position (= origin = player.position) and the tip
	tongue.rotation = self.position.angle_to_point(tip_loc) - deg2rad(90)
	$Tip.rotation = self.position.angle_to_point(tip_loc) - deg2rad(90)
	tongue.position = tip_loc						# The links are moved to start at the tip
	tongue.region_rect.size.y = tip_loc.length()	



func _physics_process(_delta):
	$Tip.global_position = tip;
	if flying:
		var d = $Tip.move_and_collide(direction*SPEED)
		if d:
			hooked=true;
			flying = false;
	tip = $Tip.global_position
