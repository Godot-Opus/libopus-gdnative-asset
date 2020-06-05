tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("OpusEncoder", "Node", load("res://addons/opus/OpusEncoderNode.gdns"), load("res://addons/opus/ic_encoder.png"))
	add_custom_type("OpusDecoder", "Node", load("res://addons/opus/OpusDecoderNode.gdns"), load("res://addons/opus/ic_decoder.png"))


func _exit_tree():
	remove_custom_type("OpusEncoder")
	remove_custom_type("OpusDecoder")
