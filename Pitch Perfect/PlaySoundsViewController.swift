//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Charles Fox on 3/06/15.
//  Copyright (c) 2015 com.ATT. All rights reserved.
//

import UIKit
import AVFoundation


class PlaySoundsViewController: UIViewController {
    
//Global variables
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

// On view load, set up the audioPlayer
    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

// Function to set up audioPlayer to play sound clip from the
// beginning by stopping/resetting both players.  Accepts a
// parameter playSpeed for the fast/slow speeds
    func playSounds (playSpeed: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = playSpeed
        audioPlayer.play()
    }

// Calls playSounds and passes slow speed value as parameter
    @IBAction func playSoundSlow(sender: UIButton) {
        // println("snail speed")
        playSounds(0.5)
     }

// Calls playSounds and passes fast speed value as parameter
    @IBAction func playSoundFast(sender: UIButton) {
        // println("rabbit speed")
        playSounds(2.0)
    }

// Stop buttong resets both players
    @IBAction func stopPlaying(sender: UIButton) {
        // println("stop playng")
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }

// Sets up audioPlayer to play audio at variable pitches.
// Accepts a pitch parameter
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
// Calls playAudioWithVariablePitch and passes it high pitch value
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
// Calls playAudioWithVariablePitch and passes it low pitch value
    @IBAction func playDarthVader(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
}
