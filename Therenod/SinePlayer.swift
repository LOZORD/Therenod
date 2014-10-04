//
//  SinePlayer.swift
//  Therenod
//
//  Created by Leo Rudberg on 10/4/14.
//  Copyright (c) 2014 LeoAndRitvik. All rights reserved.
//
import AVFoundation

class SinePlayer{
    // store persistent objects
    var ae:AVAudioEngine
    var player:AVAudioPlayerNode
    var mixer:AVAudioMixerNode
    var buffer:AVAudioPCMBuffer

    init(){
        // initialize objects
        ae = AVAudioEngine()
        player = AVAudioPlayerNode()
        mixer = ae.mainMixerNode;
        buffer = AVAudioPCMBuffer(PCMFormat: player.outputFormatForBus(0), frameCapacity: 100)
        buffer.frameLength = 100

        // generate sine wave
        var sr:Float = Float(mixer.outputFormatForBus(0).sampleRate)
        var n_channels = mixer.outputFormatForBus(0).channelCount

        for var i = 0; i < Int(buffer.frameLength); i+=Int(n_channels) {
            var val = sinf(441.0*Float(i)*2*Float(M_PI)/sr)

            buffer.floatChannelData.memory[i] = val * 0.5
        }

        // setup audio engine
        ae.attachNode(player)
        ae.connect(player, to: mixer, format: player.outputFormatForBus(0))
        ae.startAndReturnError(nil)

        // play player and buffer
        player.play()
        player.scheduleBuffer(buffer, atTime: nil, options: .Loops, completionHandler: nil)
    }
}
