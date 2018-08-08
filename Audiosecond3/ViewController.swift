//
//  ViewController.swift
//  Audiosecond3
//
//  Created by CAUAD06 on 2018. 8. 3..
//  Copyright © 2018년 CAUAD06. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController, AVAudioPlayerDelegate  , AVAudioRecorderDelegate {
    
    
    var audioPlayer : AVAudioPlayer!
    
    var audioFile : URL!
          
    let MAX_VOlUME : Float = 10.0
    
    var progressTimer : Timer!
    
    var repeatTimer = Timer()
    
    let timePlayerSelector:Selector = #selector(ViewController.updatePlayTime)
    let timeRecordSelector:Selector = #selector(ViewController.updateRecordTime)
    


 
    @IBOutlet weak var btnBackward: UIButton!
    @IBOutlet weak var btnForward: UIButton!
    
    @IBOutlet weak var slSpeed: UISlider!
    @IBOutlet weak var lblSpeed: UILabel!
    @IBOutlet weak var pvProgressPlay: UIProgressView!
    @IBOutlet weak var lblCurrentTime: UILabel!
   
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnPause: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var slVolume: UISlider!
    
    @IBOutlet weak var btnRecord: UIButton!
    @IBOutlet weak var lblRecordTime: UILabel!
    
    var audioRecorder : AVAudioRecorder!
    var isRecordMode = false
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    
        selectAudioFile()
        if !isRecordMode{
        initPlay()
        btnRecord.isEnabled = false
        lblRecordTime.isEnabled = false
        audioPlayer.enableRate = true
         
            
    }else {
    initRecord()
    }
    
        
    }
    
    func selectAudioFile() {
        if !isRecordMode {
            audioFile = Bundle.main.url(forResource: "조윤지 미팅어플", withExtension : "m4a")
        }else {
            let documentDirectory = FileManager.default.urls(for : .documentDirectory, in: .userDomainMask)[0]
            audioFile = documentDirectory.appendingPathComponent("recordFile.m4a")
        }
    }
    
    func initRecord() {
        
        let recordSettings = [
            AVFormatIDKey : NSNumber(value: kAudioFormatAppleLossless as UInt32),
            AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey : 320000,
            AVNumberOfChannelsKey : 2,
        AVSampleRateKey : 44100.0] as [String: Any]
        do {
            audioRecorder = try AVAudioRecorder(url : audioFile, settings: recordSettings)
        } catch let error as NSError {
            print("Error-initRecord : \(error)")
        }
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        
        slVolume.value = 1.0
        audioPlayer.volume = slVolume.value
        lblEndTime.text = convertNSTimeInterval2String(0)
        lblCurrentTime.text = convertNSTimeInterval2String(0)
        setPlayButtons(false, pause: false, stop: false)
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        }catch let error as NSError {
            print(" Error-setCategory : \(error)")
        }
        do {
            try session.setActive(true)
        }catch let error as NSError {
            print("Error-setActive: \(error)")
        }
        
    }
    @objc func audioRouteChanged(note: Notification) {
        if let userInfo = note.userInfo {
            if let reason = userInfo[AVAudioSessionRouteChangeReasonKey] as? Int  {
                if reason == AVAudioSessionRouteChangeReason.oldDeviceUnavailable.hashValue {
                    // headphones plugged out
                    audioPlayer.stop()
                }
            }
        }
    }
    
    //오디오 재생을 위한 초기화
    func initPlay() {
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf : audioFile)
        } catch let error as NSError {
            print("Error-initPlay : \(error)")
        }//오디오 파일이 없을 때에 대비하여 try-catch문을 사용한다
        slVolume.maximumValue = MAX_VOlUME
        slVolume.value = 1.0
        pvProgressPlay.progress = 0
        
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
        audioPlayer.volume = slVolume.value
       
        lblEndTime.text = convertNSTimeInterval2String(audioPlayer.duration)
        lblCurrentTime.text = convertNSTimeInterval2String(0)
        setPlayButtons(true, pause: false, stop: false)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .duckOthers)
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(audioRouteChanged), name: .AVAudioSessionRouteChange, object: nil)
    }
    func setPlayButtons(_ play:Bool, pause: Bool, stop: Bool) {
        btnPlay.isEnabled = play
        btnPause.isEnabled = pause
        btnStop.isEnabled = stop
    }
    
    
    func convertNSTimeInterval2String(_ time:TimeInterval) -> String {
        
        let min = Int(time/60)
        let sec = Int(time.truncatingRemainder(dividingBy: 60))
        let strTime = String(format: "%02d:%02d", min, sec)
        return strTime
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnPlayAudio(_ sender: UIButton) {
        
        audioPlayer.play()
        setPlayButtons(false, pause: true, stop: true)
        progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timePlayerSelector, userInfo: nil, repeats: true)
    }
    
    @IBAction func btnPauseAudio(_ sender: UIButton) {
        
        audioPlayer.pause()
        setPlayButtons(true, pause: false, stop: true)
        progressTimer.invalidate()
    }
    
    @objc func updatePlayTime() {
        lblCurrentTime.text = convertNSTimeInterval2String(audioPlayer.currentTime)
        pvProgressPlay.progress = Float(audioPlayer.currentTime/audioPlayer.duration)
    }
    @IBAction func btnStopAudio(_ sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        lblCurrentTime.text = convertNSTimeInterval2String(0)
        setPlayButtons(true, pause: false, stop: false)
        progressTimer.invalidate()
        
    }
    @IBAction func slChangeVolume(_ sender: UISlider) {
        audioPlayer.volume = slVolume.value
        
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        progressTimer.invalidate()
    
        setPlayButtons(true, pause: false, stop: false)
    }
    @IBAction func swRecordMode(_ sender: UISwitch) {
    
        if sender.isOn {
            audioPlayer.stop()
            audioPlayer.currentTime = 0
            lblRecordTime!.text = convertNSTimeInterval2String(0)
            isRecordMode = true
            btnRecord.isEnabled = true
            lblRecordTime.isEnabled = true
        } else {
            isRecordMode = false
            btnRecord.isEnabled = false
            lblRecordTime.isEnabled = false
            lblRecordTime.text = convertNSTimeInterval2String(0)
            
        }
        selectAudioFile()
        if !isRecordMode {
            initPlay()
            
        }else {
            initRecord()
        }
    }
    @IBAction func btnRecord(_ sender: UIButton) {
        if sender.titleLabel?.text == "Record"{
            audioRecorder.record()
            sender.setTitle("Stop", for: UIControlState())
            progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:timeRecordSelector, userInfo: nil, repeats: true)
        }else {
            audioRecorder.stop()
            progressTimer.invalidate()
            sender.setTitle("Record", for: UIControlState())
            btnPlay.isEnabled = true
            initPlay()
            
        }
    }
    @objc func updateRecordTime() {
    lblRecordTime.text = convertNSTimeInterval2String(audioRecorder.currentTime)
    }
    
// 배속기능
    @IBAction func btnSpeedAudio(_ sender: UIButton) {
        
        lblSpeed.text = String(format: "Speed: %.2f", slSpeed.value)
        
        audioPlayer.rate = slSpeed.value
    }
    
    @IBAction func btnForwardAudio(_ sender: UIButton) {
        audioPlayer.play()
        audioPlayer.currentTime += 5.0
        
        
    }
    @IBAction func btnBackwardAudio(_ sender: UIButton) {
        audioPlayer.play()
        audioPlayer.currentTime -= 5.0
        
    }
   
}
