# Godot-Opus
**libOpus for Godot**

Ecode and Decode Opus to and from raw PCM data. This results in huge compression ratios, especially for audio data containing mostly speech. Often well over 100x compression.

This is intended to allow for transmittion of auto data over the internet from inside Godot, with an eye toward eventually enabling real-time VOIP.

This is early in development, so it currently only supports whole audio encode and decode. This is not intended yet to be used for real-time streaming audio.

## Supported Platforms:
Currently [libopus-gdnative](https://github.com/Godot-Opus/libopus-gdnative) is compiled for these platforms:
- Windows x64
- Arm64-v8a (Android)
- Linux/X11 x64
- OSX x64

There's no reason it can't be compiled for 32bit platforms, I just haven't.

The reason it's not compiled for iOS is that I don't have any Apple products with wich to compile it. If any OSX developer would like to help get this compiled for that platform please get in touch!


## Usage
Once installed, remember to activate the plug in inside of Godot:

> Project -> Project Settings -> Plugins

Then change "***Opus Codec***" to Active

This will add two new nodes to Godot:
- `OpusEncoder`
  - `encode(pcmData: PoolByteArray) -> PoolByteArray`
- `OpusDecoder`
  - `decode(opusPackets: PoolByteArray) -> PoolByteArray`

## Demos
### Trivial
A demo showing the round trip from PCM -> Opus -> PCM can be seen in the Trivial demo included in this project, under `example/`.

It shows how to locally recording audio, encode it, decode it, and play it back.

**How to use:**
1) Press record button
2) Talk or what ever
3) Press stop
4) Press Encode
5) Press Decode/Player

### VOIP
And a demo showing how to implement a very simple VOIP system using Godot-Opus can be seen here:
https://github.com/Godot-Opus/godot-voip-opus-demo
