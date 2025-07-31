extends Sprite2D

var isready = false

func _process(delta):
	if isready:
		for sprite in $reverse_rotation.get_children():
			$reverse_rotation.global_rotation = 0
			sprite.rotation = global_rotation

func clear_sprites():
	for sprite in $reverse_rotation.get_children():
		sprite.queue_free()

func _ready():
	render_sprites()
	isready = true

func render_sprites():
	clear_sprites()
	for i in range(0, hframes):
		var next_sprite = Sprite2D.new()
		next_sprite.texture = texture
		next_sprite.hframes = hframes
		next_sprite.frame = i
		next_sprite.position.y = -i *2
		next_sprite.scale = scale
		$reverse_rotation.add_child(next_sprite)
