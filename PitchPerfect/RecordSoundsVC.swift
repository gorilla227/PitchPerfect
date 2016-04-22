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
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureUI(false)
    }
    
    func configureUI(isRecording: Bool) {
        recordButton.enabled = !isRecording
        stopRecordButton.enabled = isRecording
        recordingLabel.text = isRecording ? "Recording in progress" : "Tap to Record"
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
        configureUI(true)
        
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
        configureUI(false)
        
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
        print(audioRecorder.url)
    }
}