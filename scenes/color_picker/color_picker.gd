extends VBoxContainer


signal color_changed(c)

const REGEX_STR := "^#?[A-Fa-f0-9]{6}$"

var cur_color := Color.white
var is_screen_picking := false
var hex_reg: RegEx

onready var sv := $Top/SaturationValue
onready var hue := $Top/Hue
onready var cur := $Bottom/Current
onready var sel := $Bottom/Selected
onready var line_edit := $Bottom/LineEdit


func _ready():
	hex_reg = RegEx.new()
	hex_reg.compile(REGEX_STR)


func on_current_sv_changed(sat, val):
	cur_color.s = sat
	cur_color.v = val
	cur.color = cur_color
	emit_signal("color_changed", cur_color)


func on_selected_sv_changed(sat, val):
	sel.color = Color.from_hsv(cur_color.h, sat, val)


func on_current_hue_changed(hu):
	cur_color.h = hu
	cur.color = cur_color
	sv.material.set_shader_param("hue", hu)
	emit_signal("color_changed", cur_color)


func on_selected_hue_changed(hu):
	sel.color = Color.from_hsv(hu, cur_color.s, cur_color.v)


func on_screen_color_picked(c):
	update_color(c)


func on_screen_color_hovered(c):
	sel.color = c


func on_line_edit_text_entered(new_text:String):
	if hex_reg.search(new_text):
		update_color(Color(new_text))
	line_edit.clear()

	
func update_color(c):
	cur_color = c
	cur.color = c
	sel.color = c
	hue.y = c.h * hue.rect_size.y
	hue.update()
	sv.material.set_shader_param("hue", c.h)
	sv.x = c.s * sv.rect_size.x
	sv.y = (1.0 - c.v) * sv.rect_size.y
	sv.update()
	emit_signal("color_changed", cur_color)