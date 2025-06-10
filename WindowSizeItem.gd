class_name WindowSizeItem
extends Node

var width : int = 640
var height : int = 480
var text : String = "640x480"
var size : Vector2i

func set_size(size : Vector2i) -> WindowSizeItem:
	width = size.x
	height = size.y
	self.size = size
	text = "%dx%d" % [width,height]
	return self
