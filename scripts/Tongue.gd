extends Node2D

onready var tongue = $TongueLinks;

export(int) var SPEED : int = 20;

var flying : bool = false;
var hooked : bool = false;

var direction : Vector2 = Vector2()
var tip_pos : Vector2 = Vector2()

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			shoot(get_global_mouse_position() - global_position);
		else:
			release()

func shoot(target):
	flying = true
	direction = target.normalized()
	
func release():
	flying = false;
	hooked = false;
	$Tip.position = Vector2()

func _process(_delta):
	var tip_dir : float = atan2($Tip.position.y,$Tip.position.x) + PI/2
	tongue.set_region_rect(Rect2(0,0,8,$Tip.position.length()))
	tongue.set_rotation(tip_dir+PI)
	$Tip.set_rotation(tip_dir)

func _physics_process(_delta):
	if hooked: $Tip.global_position = tip_pos;
	if not flying: return;
	
	if $Tip.move_and_collide(direction*SPEED):
		hooked = true;
		flying = false;
		tip_pos = $Tip.global_position
		$Splat.play()
		
		
