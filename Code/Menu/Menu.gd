extends PanelContainer
class_name Menu

@onready var play_button: Button = $VBox/PlayButton
@onready var quit_button: Button = $VBox/QuitButton

func _ready() -> void:
	# Signal hooks.
	play_button.pressed.connect(OnPlayClicked)
	quit_button.pressed.connect(OnQuitClicked)
	hide()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		visible = !visible
		get_tree().paused = not get_tree().paused

# Callbacks: automatic.
func OnPlayClicked():
	print("I was clicked: Play")
	hide()
	get_tree().paused = false

func OnQuitClicked():
	get_tree().quit()
