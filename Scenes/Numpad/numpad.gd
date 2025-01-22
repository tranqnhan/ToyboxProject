extends Control

signal numpad_number_pressed(num: int)
signal numpad_delete_pressed
signal numpad_enter_pressed

var main_theme: Theme = preload("res://Styles/main_theme.tres")
var inverse_theme: Theme = preload("res://Styles/inverse_theme.tres")
var delete_button: Button
var enter_button: Button

func _ready() -> void:
	var b: Button
	var num_buttons: int = 10
	var num_button_width: int = 75
	var grid_hsep_constant: int = $VBoxContainer/GridContainer.get_theme_constant("h_separation")
	var grid_vsep_constant: int = $VBoxContainer/GridContainer.get_theme_constant("v_separation")
	var grid_num_columns: int = $VBoxContainer/GridContainer.columns
		
	for i in range(num_buttons):
		b = Button.new()
		b.text = str(i)
		b.theme = main_theme
		b.custom_minimum_size = Vector2(num_button_width, num_button_width)
		b.focus_mode = Control.FOCUS_NONE
		b.pressed.connect(number_button_pressed.bind(i))
		$VBoxContainer/GridContainer.add_child(b)
	
	var grid_width = (grid_num_columns - 1) * grid_hsep_constant + grid_num_columns * num_button_width
	enter_button = Button.new()
	enter_button.text = "Enter"
	enter_button.theme = main_theme
	enter_button.focus_mode = Control.FOCUS_NONE
	enter_button.custom_minimum_size = Vector2(grid_width * 0.75 - grid_hsep_constant, num_button_width)
	enter_button.pressed.connect(enter_button_pressed)
	$VBoxContainer/HBoxContainer.add_child(enter_button)
	
	delete_button = Button.new()
	delete_button.text = "Delete"
	delete_button.theme = inverse_theme
	delete_button.focus_mode = Control.FOCUS_NONE
	delete_button.custom_minimum_size = Vector2(grid_width * 0.25, num_button_width)
	delete_button.pressed.connect(delete_button_pressed)
	$VBoxContainer/HBoxContainer.add_child(delete_button)
	$VBoxContainer/HBoxContainer.add_theme_constant_override("separation", grid_hsep_constant)
	$VBoxContainer.add_theme_constant_override("separation", grid_vsep_constant)

	
func number_button_pressed(num: int) -> void:
	numpad_number_pressed.emit(num)
	
	
func delete_button_pressed() -> void:
	numpad_delete_pressed.emit()
	
	
func enter_button_pressed() -> void:
	numpad_enter_pressed.emit()
