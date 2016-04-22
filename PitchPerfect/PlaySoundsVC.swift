//
//  PlaySoundsVC.swift
//  PitchPerfect
//
//  Created by Andy Xu on 16/4/20.
//  Copyright © 2016年 Xinyi Xu. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsVC: UIViewController {
    // MARK: IBOutlets
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var darthVaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var originalDurationLabel: UILabel!
    
    // MARK: Variables
    var soundFilePath: NSURL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: NSTimer!
    
    // MARK: ButtonType
    enum ButtonType: Int { case Slow = 0, Fast, Chipmunk, Vader, Echo, Reverb}

    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("PlaySoundsVC loaded")
        let audioPlayer = try! AVAudioPlayer(contentsOfURL: soundFilePath)
        let duration = audioPlayer.duration
        originalDurationLabel.text = String(format:"%.2f", duration) + " seconds"
        
        setupAudio()
        configureUI(false)
    }
    
    // MARK: IBActions
    @IBAction func playSoundForButton(sender: UIButton) {
        print("Play Sound Button Pressed")
        switch (ButtonType(rawValue: sender.tag)!) {
        case .Slow:
            playSound(rate: 0.5)
        case .Fast:
            playSound(rate: 1.5)
        case .Chipmunk:
            playSound(pitch: 1000)
        case .Vader:
            playSound(pitch: -1000)
        case .Echo:
            playSound(echo: true)
        case .Reverb:
            playSound(reverb: true)
        }
        configureUI(true)
    }
    
    @IBAction func stopButtonPressed(sender: AnyObject) {
        print("Stop Audio Button Pressed")
        stopAudio()
    }
}