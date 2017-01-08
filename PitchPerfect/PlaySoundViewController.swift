//
//  PlaySoundViewController.swift
//  PitchPerfect
//
//  Created by 진형탁 on 2017. 1. 1..
//  Copyright © 2017년 Boostcamp. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var highPitchButton: UIButton!
    @IBOutlet weak var lowPitchButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var playbackSlider: UISlider!
    
    var recordedAudioURL: URL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var sliderTimer = Timer()
    var stopTimer: Timer!
    var delayInSeconds: Double = 0
    
    enum ButtonType: Int { case fast = 0, slow, highPitch, lowPitch, echo, reverb }
   
    @IBAction func playSoundForButton (_ sender: UIButton) {
        switch(ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .highPitch:
            playSound(pitch: 1000)
        case .lowPitch:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
        configureUI(.playing)
        startSliderTimer()
    }
    
    @IBAction func stopButtonPressed (_ sender: UIButton) {
        stopAudio()
        sliderTimer.invalidate()
        playbackSlider.value = 0
        delayInSeconds = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playbackSlider.minimumValue = 0
        playbackSlider.isContinuous = true
        
        configureUI(.notPlaying)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // fire timer for slider
    func startSliderTimer() {
        if (!sliderTimer.isValid) {
            sliderTimer = Timer.scheduledTimer(timeInterval: delayInSeconds, target: self, selector: #selector(activeSliderTimer(_:)), userInfo: nil, repeats: true)
            sliderTimer.fire()
        }
    }
    
    // change label on view
    func activeSliderTimer(_ timer: Timer) {
        playbackSlider.value = Float(currentTime())
    }
    
    // get play current time
    func currentTime() -> TimeInterval {
        let nodeTime: AVAudioTime = audioPlayerNode.lastRenderTime!
        let playTime: AVAudioTime = audioPlayerNode.playerTime(forNodeTime: nodeTime)!
        return Double(Double(playTime.sampleTime) / playTime.sampleRate)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
