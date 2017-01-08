//
//  RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by 진형탁 on 2016. 12. 31..
//  Copyright © 2016년 Boostcamp. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder!
    let dateFormatter = DateFormatter()
    var timer = Timer()
    let timeInterval : TimeInterval = 0.1 // 0.1 second
    var timeCount : TimeInterval = 0.0
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func recordAudio(_ sender: Any) {
        // to change view or UI
        startTimer()
        stopRecordingButton.isEnabled = true
        recordingButton.isEnabled = false
        
        // to record voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wmv"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        // to change view
        stopTimer()
        recordingLabel.text = "Tap to Record"
        recordingButton.isEnabled = true
        stopRecordingButton.isEnabled = false
        
        // to stop record function
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url) // 여기서 stopRecording은 storyboard에서 segue
        } else {
            print("recoding was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL // set URL to PlaySoundViewController
        }
    }
    
    // fire timer
    func startTimer() {
        if (!timer.isValid) { //prevent more than one timer on the thread
            recordingLabel.text = timeString(time: timeCount)
            timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(activeTimer(_:)), userInfo: nil, repeats: true)
            timer.fire()
        }
    }
    
    // chang label on view
    func activeTimer(_ timer: Timer) {
        timeCount = timeCount + timeInterval
        recordingLabel.text = timeString(time: timeCount)
    }
    
    func stopTimer() {
        timer.invalidate()
        timeCount = 0.0
    }
    
    // set time formatting
    func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = time - Double(minutes) * 60
        let secondsFraction = seconds - Double(Int(seconds))
        return String(format:"%02i:%02i.%01i", minutes, Int(seconds), Int(secondsFraction * 10.0))
    }
}

