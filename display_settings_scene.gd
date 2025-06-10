extends Node2D
@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport
@onready var sub_viewport_container: SubViewportContainer = $SubViewportContainer
@onready var window: Window = $SubViewportContainer/SubViewport/Window

func _ready() -> void:
	sub_viewport.size_2d_override_stretch
	
	pass
