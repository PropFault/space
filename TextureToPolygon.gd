tool
extends CollisionPolygon2D
export(Texture) var tex

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func isSimilar(pixel1, pixel2, tolerance):
	return abs(pixel1.to_rgba32() - pixel2.to_rgba32()) < tolerance

var points = []
func randomWalk(x, y, image):
	var alphaPixel = Color(0,0,0,1)
	var readPixel = alphaPixel
	var cursorX = x
	var cursorY = y
	var width = image.get_width()
	var height = image.get_height()
	var rng = RandomNumberGenerator.new()
	image.lock()
	while(isSimilar(readPixel, alphaPixel, 1000)):
		cursorY = clamp(cursorY +min(rng.randi_range(-1,3),1), 0, height-1)
		cursorX = clamp(cursorX +min(rng.randi_range(-1,3),1), 0, width-1)
		readPixel = image.get_pixel(cursorX, cursorY)
	image.unlock()
	return Vector2(cursorX, cursorY)
func generate():
	var image = tex.get_data()
	var width = image.get_width()
	var height = image.get_height()
	points = []
	for x in range(0, width-1):
		points.append(randomWalk(x,0,image))
	for y in range(0, height-1):
		points.append(randomWalk(0,y,image))
	for x in range(0, width-1):
		points.append(randomWalk(x,height-1,image))
	for y in range(0, height-1):
		points.append(randomWalk(width-1,y,image))
	points.append(points[0])
	self.polygon = points

# Called when the node enters the scene tree for the first time.
func _ready():
	generate()


func _process(delta):
	if(self.polygon.size() == 0):
		generate()
		

func _draw():
	for point in points:
		draw_circle(point, 1, Color.red)
