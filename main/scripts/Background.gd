extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	set_noise_texture()


func set_noise_texture():
	var noise = OpenSimplexNoise.new()
	# Configure
	noise.seed = randi()
	noise.octaves = 0
	var image = noise.get_image(OS.window_size.x, OS.window_size.y)
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	$BackgroundShader.material.set_shader_param("NOISE_PATTERN", texture)

