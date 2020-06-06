# Godot-Opus
> libOpus for Godot


Once installed, remeber to activate the plug in inside of Godot:
Project -> Project Settings -> Plugins
Then chance "Opus Codec" to Active

This will add two new nodes to Godot:
- `OpusEncoder`
  - `encode(pcmData: PoolByteArray) -> PoolByteArray`
- `OpusDecoder`
  - `decode(opusPackets: PoolByteArray) -> PoolByteArray`

## Demos
A demo showing the round trip from PCM -> Opus -> PCM can be seen here:
https://github.com/Godot-Opus/libopus-gdnative-demo

And a demo showing how to implement a very simple VOIP system using Godot-Opus can be seen here:
https://github.com/Godot-Opus/godot-voip-opus-demo
