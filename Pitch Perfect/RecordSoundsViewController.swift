//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Charlesf on 3/06/15.
//  Copyright (c) 2015 com.ATT. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
// Outlets - used to access properties of the labal and buttons
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    //Declared Globally
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
// Sets up the initial state of teh lable and buttons when app loads
    override func viewDidAppear(animated: Bool) {
       stopButton.hidden = true
       recordButton.enabled = true
       recordingInProgress.text = "Tap Microphone to Record"
    }

// When the resord button is tapped:
//   1) Changes the state of the lable and buttons
//   2) Sets the file path for the new audio file
//   3) Creates a delegate to send file to second scene
//   4) Records by calling audioRecorder.record()
    @IBAction func recordAudio(sender: UIButton) {
        recordingInProgress.text = "Recording in progress."
        stopButton.hidden = false
        recordButton.enabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        // println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()
    }
    
// Saves audio file and moves to second scene.
// Error message if recording fails.
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag){
            // save audio file
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            // move to second scene
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else {
                println("Recording failed")
                stopButton.hidden = true
                recordButton.enabled = true
            }
    }
    
// Prepares file for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }

// Stop recording
    @IBAction func stopRecording(sender: UIButton) {
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}