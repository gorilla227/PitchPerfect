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
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopRecordButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: AnyObject) {
        print("record button pressed")
        recordingLabel.text = "Recording in progress"
        recordButton.enabled = false
        stopRecordButton.enabled = true
        
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
        recordingLabel.text = "Tap to Record"
        recordButton.enabled = true
        stopRecordButton.enabled = false
        
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
        print(audioRecorder.url)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print("AVAudioRecoder finished saving recording")
            self.performSegueWithIdentifier("stopRecording", sender: recorder.url)
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
}

