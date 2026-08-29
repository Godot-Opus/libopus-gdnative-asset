# Godot-Opus
**libOpus for Godot 4**

Encode and decode Opus to and from raw PCM audio data. This results in huge compression ratios, especially for audio containing mostly speech: often well over 100x.

This enables transmission of voice audio over the internet from inside Godot, including true real-time streaming VOIP (push-to-talk).

Looking for the Godot 3.x version? It lives on the [`godot3` branch](../../tree/godot3).

## Supported Platforms
[libopus-gdnative](https://github.com/Godot-Opus/libopus-gdnative) is a GDExtension compiled for:
- Windows x86_64
- Linux x86_64
- macOS universal (x86_64 + arm64)
- Android arm64

## Installing
Install through the Godot Asset Library, or extract `addons/opus/` into your project by hand. No plugin activation is needed; GDExtensions load automatically. Requires Godot 4.1 or newer.

Two new node types appear in the Create Node dialog:
- `OpusEncoderNode`
- `OpusDecoderNode`

## Usage

### Whole-clip
Encode a complete recording in one call, decode it in one call:
```gdscript
var opusPackets: PackedByteArray = $OpusEncoder.encode(pcmData)
var pcm: PackedByteArray = $OpusDecoder.decode(opusPackets)
```

### Streaming (push-to-talk)
A per-frame API sits between `AudioEffectCapture` and `AudioStreamGenerator` for real-time voice. Sender:
```gdscript
encoder.push_audio(capture.get_buffer(capture.get_frames_available()))
while encoder.has_packet():
	send_packet.rpc(encoder.pop_packet())
```
Receiver, per packet:
```gdscript
playback.push_buffer(decoder.decode_frame(packet))
```
The project mix rate must match the encoder's `sample_rate` (48kHz by default): set `audio/driver/mix_rate=48000`.

Both nodes expose `sample_rate`, `channels`, and (encoder only) `bit_rate` and `application` properties. See the [libopus-gdnative README](https://github.com/Godot-Opus/libopus-gdnative) for the full API.

## Demos
### Trivial
This repository is itself a Godot project: clone it and open it to run the example under `example/`, which shows the whole-clip round trip: record from the mic, encode, decode, play back. (The Asset Library download ships only `addons/opus/`, so it does not include the example.)

1. Press Record, talk, press Stop
2. Press Encode
3. Press Decode/Play

It also has a live stream loopback toggle that runs your mic through the streaming API (capture, encode, decode, playback) in real time. Use headphones, or the mic will feed back.

### VOIP
A demo of real VOIP between two machines, in both whole-clip and live streaming modes:
https://github.com/Godot-Opus/libopus-gdnative-voip-demo
