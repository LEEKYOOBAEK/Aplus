//
//  ViewController.swift
//  soldOut
//
//  Created by CAUAD06 on 2018. 7. 30..
//  Copyright © 2018년 CAUAD06. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVAudioPlayerDelegate {

    var audioPlayer : AVAudioPlayer!
    var audioFile : URL!
    
    let MAX_VOLUME : Float = 10.0
    
    var progressTimer : Timer!
    let timePlayerSelector:Selector = #selector(ViewController.updatePlayTime)
    
    
  
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
        
        audioFile = Bundle.main.url(forResource: "조윤지 미팅어플", withExtension: "m4a")
        initPlay()
    }
    func initPlay() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFile)
        } catch let error as NSError {
            print("Error-initPlay : \(error)")
        }
        slVolume.maximumValue = MAX_VOLUME
        slVolume.value = 1.0
        pvProgressPlay.progress = 0
        //슬라이더(slVolume)의 최대 볼륨을 상수 MAX_VOLUME인 10.0으로 초기화합니다.
        //슬라이더의 볼륨을 1.0으로 초기화합니다
        //프로그레스 뷰 의 진행을 0 으로 초기화 합니다
        
        //?? 원래는 pvProgressView
       
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
        audioPlayer.volume = slVolume.value
        //audioPlater 의 델리게이트를 self로 합니다
        //prepateToPlay()를 실행합니다
        //audioPlayer의볼륨을 방금 앞에서 초기화한 슬라이더의 볼륨 값 1.0으로 초기화합니다.
        
        lblEndTime.text = convertNSTimeInterval2String(_time: audioPlayer.duration)
        lblCurrentTime.text = convertNSTimeInterval2String(_time: 0)
        setPlayButtons(true, pause: false, stop: false)
    }
    
    func setPlayButtons(_ play:Bool,pause:Bool, stop:Bool) {
        btnPlay.isEnabled = play
        btnPause.isEnabled = pause
        btnStop.isEnabled = stop
    }

    func convertNSTimeInterval2String(_time:TimeInterval) -> String {
        let min = Int(_time/60)
        let sec = Int(_time.truncatingRemainder(dividingBy:60))
        let strTime = String(format : "%d:%d", min, sec)
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
    
    func updatePlayTime(){
        lblCurrentTime.text = convertNSTimeInterval2String(_time: audioPlayer.currentTime)
        pvProgressPlay.progress = Float(audioPlayer.currentTime/audioPlayer.duration)
    }
    @IBAction func btnPauseAudio(_ sender: UIButton) {
        audioPlayer.pause()
        audioPlayer.currentTime = 0
        lblCurrentTime.text = convertNSTimeInterval2String(_time: 0)
        setPlayButtons(true, pause: false, stop: true)
        progressTimer.invalidate()
    }
    @IBAction func btnStopAudio(_ sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        lblCurrentTime.text = convertNSTimeInterval2String(_time: 0)
        setPlayButtons(true, pause: false, stop: false)
        progressTimer.invalidate()
    }
    
    @IBAction func slChangeVolume(_ sender: UISlider) {
        audioPlayer.volume = slVolume.value
    }
    func audioPlayerDidFinishPlaying(_player:AVAudioPlayer, successfully flag:Bool) {
        progressTimer.invalidate()
        setPlayButtons(true, pause: false, stop: false)
    }
    
}

