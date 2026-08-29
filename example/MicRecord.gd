extends Control

var effect: AudioEffectRecord
var capture: AudioEffectCapture
var recording: AudioStreamWAV = null
var opusEncoded: PackedByteArray
var streaming = false


func _ready():
	var idx = AudioServer.get_bus_index("Record")
	effect = AudioServer.get_bus_effect(idx, 0)
	capture = AudioServer.get_bus_effect(idx, 1)

	update_opus_buttons()


# Live loopback: mic -> Opus encode -> Opus decode -> speakers, one packet at a time
func _on_StreamButton_toggled(on: bool):
	streaming = on
	if on:
		capture.clear_buffer()
		$OpusEncoder.reset_stream()
		$StreamOutput.play()
	else:
		$StreamOutput.stop()
		$OpusDecoder.reset_stream()


func _process(_delta):
	if streaming:
		$OpusEncoder.push_audio(capture.get_buffer(capture.get_frames_available()))
		while $OpusEncoder.has_packet():
			var frames = $OpusDecoder.decode_frame($OpusEncoder.pop_packet())
			var playback = $StreamOutput.get_stream_playback()
			if playback.can_push_buffer(frames.size()):
				playback.push_buffer(frames)


func _on_RecordButton_pressed():
	if effect.is_recording_active():
		recording = effect.get_recording()

		$PlayButton.disabled = false
		effect.set_recording_active(false)
		$RecordButton.text = "Record"
		$Status.text = ""
	else:
		$PlayButton.disabled = true
		effect.set_recording_active(true)
		$RecordButton.text = "Stop"
		$Status.text = "Recording..."

	update_opus_buttons()


func _on_PlayButton_pressed():
	$AudioStreamPlayer.stream = recording
	$AudioStreamPlayer.play()


func update_opus_buttons():
	$EncodeButton.disabled = (recording == null)
	$DecodeButton.disabled = (opusEncoded.is_empty())


func _on_EncodeButton_pressed():
	if recording != null:
		var pcmData := recording.data
		var pcmSize = pcmData.size()

		opusEncoded = $OpusEncoder.encode(pcmData)
		var opusSize = opusEncoded.size()

		$PcmSize.text = "PCM  Size: %1.1f kB" % [pcmSize as float / 1024.0]
		$OpusSize.text = "Opus Size: %1.1f kB" % [opusSize as float / 1024.0]
		$CompressionRatio.text = "%1.3fx smaller" % [(pcmSize as float / opusSize as float)]

		update_opus_buttons()


func _on_DecodeButton_pressed():
	if not opusEncoded.is_empty():
		var pcm = $OpusDecoder.decode(opusEncoded)

		opusEncoded.resize(0)

		var sample = AudioStreamWAV.new()
		sample.format = AudioStreamWAV.FORMAT_16_BITS
		sample.mix_rate = recording.mix_rate
		sample.stereo = recording.stereo
		sample.data = pcm

		$AudioStreamPlayer.stream = sample
		$AudioStreamPlayer.play()

		update_opus_buttons()
