//
//  RecordSoundsVC.swift
//  PitchPerfect
//
//  Created by Andy on 16/4/18.
//  Copyright © 2016年 Xinyi Xu. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsVC: UIViewController, AVAudioRecorderDelegate {
    // MARK: IBOutlets
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordButton: UIButton!
    
    // MARK: Variables
    var audioRecorder: AVAudioRecorder!
    
    // MARK: RecordingState
    enum RecordingState {
        case Recording, NotRecording
    }
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureUI(.NotRecording)
    }

    
    func configureUI(recordingState: RecordingState) {
        switch recordingState {
        case .Recording:
            recordButton.enabled = false
            stopRecordButton.enabled = true
            recordingLabel.text = "Recording in progress"
        case .NotRecording:
            recordButton.enabled = true
            stopRecordButton.enabled = false
            recordingLabel.text = "Tap to Record"
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print("AVAudioRecoder finished saving recording")
            performSegueWithIdentifier("stopRecording", sender: recorder.url)
        } else {
            print("Saving of recording failed")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
            case "stopRecording":
            let playSoundsVC = segue.destinationViewController as! PlaySoundsVC
            playSoundsVC.soundFilePath = sender as! NSURL
        default: break
        }
    }
    
    // MARK: IBActions
    @IBAction func recordAudio(sender: AnyObject) {
        print("record button pressed")
        configureUI(.Recording)
        
        let docPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let fileName = "recordedAudio.wav"
        let filePath = NSURL.fileURLWithPathComponents([docPath, fileName])
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(sender: AnyObject) {
        print("stop recording button pressed")
        configureUI(.NotRecording)
        
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
        print(audioRecorder.url)
    }
}