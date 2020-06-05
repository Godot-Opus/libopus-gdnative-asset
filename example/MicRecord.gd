extends Control

var effect: AudioEffectRecord
var recording: AudioStreamSample = null
var opusEncoded: PoolByteArray


func _ready():
	var idx = AudioServer.get_bus_index("Record")
	effect = AudioServer.get_bus_effect(idx, 0)
	
	update_opus_buttons()


func _on_RecordButton_pressed():
	if effect.is_recording_active():
		recording = effect.get_recording()
		
		print(recording)
		print(recording.format)
		print(recording.mix_rate)
		print(recording.stereo)
		
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
	print(recording)
	print(recording.format)
	print(recording.mix_rate)
	print(recording.stereo)
	var data = recording.get_data()
	print(data)
	print(data.size())
	
	$AudioStreamPlayer.stream = recording
	$AudioStreamPlayer.play()


func update_opus_buttons():
	$EncodeButton.disabled = (recording == null)
	$DecodeButton.disabled = (opusEncoded.empty())


func _on_EncodeButton_pressed():
	
	if recording != null:
		var data = recording.get_data()
		print("PCM Data")
		var pcmData := recording.data
		var pcmSize = pcmData.size()
		print(pcmSize)
		
		opusEncoded = $OpusEncoder.encode(pcmData)
		
		print("Opus Data")
		var opusSize = opusEncoded.size()
		print(opusSize)
		
		$PcmSize.text = "PCM  Size: %1.1f kB" % [pcmSize as float/1024.0]
		$OpusSize.text = "Opus Size: %1.1f kB" % [opusSize as float/1024.0]
		$CompressionRatio.text = "%1.3fx smaller" % [(pcmSize as float / opusSize as float)]
		
		update_opus_buttons()


func _on_DecodeButton_pressed():
	if not opusEncoded.empty():
		var pcm = $OpusDecoder.decode(opusEncoded)
		print(pcm)
		print(pcm.size())
		
		opusEncoded.resize(0)
		
		var sample = AudioStreamSample.new()
		sample.format = AudioStreamSample.FORMAT_16_BITS
		sample.mix_rate = 44100
		sample.stereo = true
		sample.data = pcm
		sample.save_to_wav("opus_decoded.wav")
		
		$AudioStreamPlayer.stream = sample
		$AudioStreamPlayer.play()
		
		update_opus_buttons()
