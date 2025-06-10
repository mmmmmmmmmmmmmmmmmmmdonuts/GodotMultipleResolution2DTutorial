extends Control

#region: Window Size Setup
@onready var ob_SetWindowSize : OptionButton = %OB_SetWindowSize
var window_size_list = [
			WindowSizeItem.new().set_size(Vector2i(320, 180)), WindowSizeItem.new().set_size(Vector2i(640, 360)), WindowSizeItem.new().set_size(Vector2i(640, 480)),
			WindowSizeItem.new().set_size(Vector2i(1280, 720)), WindowSizeItem.new().set_size(Vector2i(1280, 800)),			
			WindowSizeItem.new().set_size(Vector2i(1920, 1080)), WindowSizeItem.new().set_size(Vector2i(1920, 1200)),
			WindowSizeItem.new().set_size(Vector2i(2560, 1440)), WindowSizeItem.new().set_size(Vector2i(3440,1440))]
#endregion

#region: Content Scale Setup
# Content Scale Size Selector
@onready var ob_SetContentScaleSize: OptionButton = %OB_SetContentScaleSize
var content_scale_size_list = [ #Content Sizes are the same as window size items
			WindowSizeItem.new().set_size(Vector2i(320, 180)), WindowSizeItem.new().set_size(Vector2i(640, 360)), WindowSizeItem.new().set_size(Vector2i(640, 480)),
			WindowSizeItem.new().set_size(Vector2i(1280, 720)), WindowSizeItem.new().set_size(Vector2i(1280, 800)),			
			WindowSizeItem.new().set_size(Vector2i(1920, 1080)), WindowSizeItem.new().set_size(Vector2i(1920, 1200)),
			WindowSizeItem.new().set_size(Vector2i(2560, 1440)), WindowSizeItem.new().set_size(Vector2i(3440,1440))]

# Content Scale Mode Selector
@onready var ob_SetContentScaleMode: OptionButton = %OB_SetContentScaleMode
enum SM { DISABLED, CANVAS_ITEMS, VIEWPORT }
#endregion

#region: Aspect Ratio Setup
@onready var ob_SetAspectRatio: OptionButton = %OB_SetAspectRatio
enum ASPECT { 
	IGNORE = 0, 
	KEEP = 1,
	KEEP_WIDTH = 2,
	KEEP_HEIGHT = 3,
	EXPAND = 4
}
@onready var l_ScaleSelect: Label = %L_ScaleSelect
@onready var hs_SetScale: HSlider = %HS_SetScale
#endregion

#region: Screen Selection and Window Mode
@onready var ob_SetScreen: OptionButton = %OB_SetScreen
@onready var ob_SetWindowMode: OptionButton = %OB_SetWindowMode
enum WM {WINDOWED, MINIMIZED, MAXIMIZED, FULL_SCREEN, EXCLUSIVE_FULL_SCREEN}
@onready var l_CurrentScreenRes: Label = %L_CurrentScreenRes

#endregion


func _ready() -> void:
	
	#region: Setup Screen WindowSizeItem Selector
	ob_SetWindowSize.item_selected.connect(_on_OB_SetWindowSize) #connect the signal
	for i in range(0, window_size_list.size()):
		#Add each Window Size Item to the box
		ob_SetWindowSize.add_item(window_size_list[i].text, i)
		#Set the Metadata to be a WindowSizeItem Object, the item metadata is set by the index which is only whole numbers starting at 1, adjust by +1 to match
		ob_SetWindowSize.set_item_metadata(i, window_size_list[i])
	#endregion

	#region Setup Content Scale Features
	
	#setup Content Scale Size Selection Box
	ob_SetContentScaleSize.item_selected.connect(_on_OB_SetContentScaleSize) #connect the signal
	for i in range(0, content_scale_size_list.size()):
		#Add each Root Content Scale Size Item to the box
		ob_SetContentScaleSize.add_item(content_scale_size_list[i].text, i)
		#Set the Metadata to be a RootContentWindowSize Object which is the same as a WindowSizeItem
		ob_SetContentScaleSize.set_item_metadata(i, content_scale_size_list[i])
	
	#setup Content Scale Mode Selection Box
	ob_SetContentScaleMode.item_selected.connect(_on_OB_SetContentScaleMode)
	for i in range(0, SM.size()):
		ob_SetContentScaleMode.add_item(SM.keys()[i], SM.values()[i])
		#print("SM Key Name: %s\tValue: %d" % [SM.keys()[i], SM.values()[i]])
	
	
	get_tree().root.content_scale_aspect
	
	#endregion

	#region: Setup Aspect Scale
	ob_SetAspectRatio.item_selected.connect(_on_OB_SetAspectRatio) #connect the signal
	for i in range(0, ASPECT.size()):
		ob_SetAspectRatio.add_item(ASPECT.keys()[i], ASPECT.values()[i])
	
	l_ScaleSelect.text = "Current Scale Factor: %d" % get_tree().root.content_scale_factor
	hs_SetScale.drag_ended.connect(_on_HS_SetScale)
	#endregion
	
	#region: Setup Screen Selector and Window Mode
	# Current Screen Resolution
	l_CurrentScreenRes.text = "Current Screen Res: %s" % DisplayServer.screen_get_size(DisplayServer.get_primary_screen())
	# Screen Selection
	var num_screens : int = DisplayServer.get_screen_count()
	var primary_screen : int = DisplayServer.get_primary_screen()
	print("Number of Screens: %d	The Primary Screen is: %d" % [num_screens, primary_screen])
	# Add screens to the Set Screen Option Button
	for i in range(0, num_screens):
		ob_SetScreen.add_item("Screen: %d" % i, i)
	ob_SetScreen.item_selected.connect(_on_OB_SetScreen)	
	
	# Window Mode
	ob_SetWindowMode.item_selected.connect(_on_OB_SetWindowMode)
	for i in range(0, WM.size()):
		ob_SetWindowMode.add_item(WM.keys()[i], WM.values()[i])
	#endregion

#region Event Handlers
func _on_OB_SetWindowSize(index : int) -> void:	
	var selected_window_size := ob_SetWindowSize.get_item_metadata(index) as WindowSizeItem
	print("Selected Screen Size @index %d is: %dx%d" % [index, selected_window_size.width, selected_window_size.height])
	get_tree().root.size = selected_window_size.size
	print("Tree root window size is %s" % [get_tree().root.size])
	#DisplayServer.window_set_size(Vector2i(selected_window_size.width, selected_window_size.height)) ## appears to be deprecated, preferred now to use get_tree().root.size

func _on_OB_SetContentScaleSize(index : int) -> void:	
	var selected_content_scale_size := ob_SetContentScaleSize.get_item_metadata(index) as WindowSizeItem	
	print("Selected Content Scale Size @index %d is: %dx%d" % [index, selected_content_scale_size.width, selected_content_scale_size.height])
	get_tree().root.content_scale_size = selected_content_scale_size.size
	#print("Tree root content scale size is %s" % [get_tree().root.content_scale_size])

func _on_OB_SetContentScaleMode(index : int) -> void:
	var scale_mode := ob_SetContentScaleMode.get_item_id(index)
	
	match scale_mode:
		SM.DISABLED:
			get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_DISABLED
		SM.CANVAS_ITEMS:
			get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
		SM.VIEWPORT:
			get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT
	print("Current Scale Mode is: %s" % get_tree().root.content_scale_mode)

func _on_OB_SetScreen(index : int) -> void:
	var selected_screen = ob_SetScreen.get_item_id(index)
	print("Selected Screen is: %d" % selected_screen)
	get_tree().root.current_screen = selected_screen
	l_CurrentScreenRes.text = "Current Screen Res: %s" % DisplayServer.screen_get_size(selected_screen)
	

func _on_OB_SetWindowMode(index : int) -> void:
	var window_mode := ob_SetWindowMode.get_item_id(index)
	
	match window_mode:
		WM.WINDOWED:
			get_tree().root.mode = Window.MODE_WINDOWED
		WM.MAXIMIZED:
			get_tree().root.mode = Window.MODE_MAXIMIZED
		WM.MINIMIZED:
			get_tree().root.mode = Window.MODE_MINIMIZED
		WM.FULL_SCREEN:
			get_tree().root.mode = Window.MODE_FULLSCREEN
		WM.EXCLUSIVE_FULL_SCREEN:
			get_tree().root.mode = Window.MODE_EXCLUSIVE_FULLSCREEN
			
	print("Current Window Mode is: %s" % get_tree().root.mode)

func _on_OB_SetAspectRatio(index : int) -> void:
	var scale_aspect := ob_SetAspectRatio.get_item_id(index)
	
	match scale_aspect:
		ASPECT.IGNORE:
			get_tree().root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_IGNORE
		ASPECT.KEEP:
			get_tree().root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
		ASPECT.KEEP_WIDTH:
			get_tree().root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP_WIDTH
		ASPECT.KEEP_HEIGHT:
			get_tree().root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP_HEIGHT
		ASPECT.EXPAND:
			get_tree().root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_EXPAND
	print("Current Scale Apect is: %s" % get_tree().root.content_scale_aspect)

func _on_HS_SetScale(value_changed : bool) -> void:
	get_tree().root.content_scale_factor = hs_SetScale.value
	l_ScaleSelect.text = "Current Scale Factor: %.1f" % get_tree().root.content_scale_factor
	
#endregion
