//
//  ViewController.swift
//  Audio3
//
//  Created by CAUAD06 on 2018. 8. 3..
//  Copyright © 2018년 CAUAD06. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {

    var audioPlayer : AVAudioPlayer!
    var audioFile : URL!
    
    let MAX_VOLUME : Float = 10.0
    
    var progressTimer : Timer!
    
    let timePlayerSelector: Selector = #selector(ViewController.updatePlayTime)
    
    
    @IBOutlet weak var pvProgressPlay: UIProgressView!
    @IBOutlet weak var lblCurrentTime: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnPause: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var slVolume: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        audioFile = Bundle.main.url(forResource: "조윤지 미팅어플", withExtension : "m4a")
        initPlay()
    }
    
    func initPlay() {
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: audioFile)
        } catch let error as NSError {
            print("Error-initPlay: \(error)")
        }
        
        slVolume.maximumValue = MAX_VOLUME
        slVolume.value = 1.0
        pvProgressPlay.progress = 0
        
        
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
        audioPlayer.volume = slVolume.value
        
        lblEndTime.text = convertNSTimeInterval2String(audioPlayer.duration)
        lblCurrentTime.text = convertNSTimeInterval2String(0)
        setPlayButtons(true, pause: false, Stop: false)
        /*
        btnPlay.isEnabled = true
        btnPause.isEnabled = false
        btnStop.isEnabled = false
        */
    }
    
    func setPlayButtons(_ play:Bool, pause:Bool, Stop:Bool) {
        btnPlay.isEnabled = play
        btnPause.isEnabled = pause
        btnStop.isEnabled = Stop
    }
    
    func convertNSTimeInterval2String(_ time:TimeInterval)-> String {
        let min = Int(time/60)
        let sec = Int(time.truncatingRemainder(dividingBy: 60))
        let strTime =  String(format : "%02d:%02d", min, sec)
        return strTime
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnPlayAudio(_ sender: UIButton) {
        
        audioPlayer.play()
        setPlayButtons(false, pause: true, Stop: true)
        progressTimer = Timer.scheduledTimer(timeInterval: 0.1,target: self, selector: timePlayerSelector, userInfo: nil, repeats: true)
        
    }
    
    @objc func updatePlayTime() {
        lblCurrentTime.text = convertNSTimeInterval2String(audioPlayer.currentTime)
        pvProgressPlay.progress = Float(audioPlayer.currentTime/audioPlayer.duration)
    }
    
    @IBAction func btnPauseAudio(_ sender: UIButton) {
        
        audioPlayer.pause()
        audioPlayer.currentTime = 0
        lblCurrentTime.text = convertNSTimeInterval2String(0)
        setPlayButtons(true, pause: false, Stop: true)
        progressTimer.invalidate()
        
        
    }
    @IBAction func btnStopAudio(_ sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        lblCurrentTime.text = convertNSTimeInterval2String(0)
        setPlayButtons(true, pause: false, Stop: false)
        progressTimer.invalidate()
    }
    
    @IBAction func slChangeVolume(_ sender: UISlider) {
        audioPlayer.volume = slVolume.value
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        progressTimer.invalidate()
        setPlayButtons(true, pause: false, Stop: false)
    }
}

