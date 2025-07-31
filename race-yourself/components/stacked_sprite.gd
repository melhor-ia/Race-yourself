extends Sprite2D

@onready var sprite_axis:= Marker2D.new()
var tree_ready:bool

func _ready():
	render_sprites()
	add_child(sprite_axis)
	tree_ready = true


func _process(delta):
	if tree_ready:
		for sprite in sprite_axis.get_children():
			sprite_axis.global_rotation = 0
			sprite.rotation = global_rotation


func clear_sprites():
	for sprite in sprite_axis.get_children():
		sprite.queue_free()


func render_sprites():
	clear_sprites()
	for i in range(0, hframes):
		var next_sprite = Sprite2D.new()
		next_sprite.texture = texture
		next_sprite.hframes = hframes
		next_sprite.frame = i
		next_sprite.position.y = -i *3
		next_sprite.scale = scale
		sprite_axis.add_child(next_sprite)
