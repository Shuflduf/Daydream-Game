@tool
extends PanelContainer

@export_tool_button("Create") var cb = create_bars
@export_tool_button("Update") var ub = update_bars

@export_color_no_alpha var no_energy_col: Color
@export var energy = 8
@export var current_energy = 2


func _ready() -> void:
	create_bars()
	update_bars()


func create_bars():
	for bar in %EnergyContainer.get_children():
		bar.queue_free()
	for i in energy:
		%EnergyContainer.add_child(%EnergyBase.duplicate())


func update_bars():
	for bar in %EnergyContainer.get_children():
		if bar.get_index() < energy - current_energy:
			bar.color = no_energy_col
		else:
			bar.color = Color.WHITE
