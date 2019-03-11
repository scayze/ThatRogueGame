extends TextureRect

func _ready():
	texture = AnimatedTexture.new()
	texture.frames = 40
	texture.fps = 20
	self.anchor_top = -0.9
	self.margin_top = 0
	self.margin_bottom = 0
	for i in range(40):
		texture.set_frame_texture(i,load("res://Logo/render.png_" + str(i) + ".png"))
	pass
