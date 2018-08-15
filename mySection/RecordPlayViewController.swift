//
//  RecordPlayViewController.swift
//  mySection
//
//  Created by CAUAD05 on 2018. 8. 12..
//  Copyright © 2018년 ahnYeLim. All rights reserved.
//

import UIKit
import AVFoundation

class RecordPlayViewController: UIViewController, AVAudioPlayerDelegate {
    
    
    var willPlayFilePath:URL?
    var audioPlayer:AVAudioPlayer!
    let MAX_VOLUME : Float = 10.0
    let timePlayerSelector: Selector = #selector(RecordPlayViewController.updateSlider)
    
    @IBOutlet weak var btnForward: UIButton!
    @IBOutlet weak var btnBackward: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnPause: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var lblCurrentTime: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var slVolume: UISlider!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initPlay()
        slider.maximumValue = Float(audioPlayer.duration)
        _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(RecordPlayViewController.updateSlider), userInfo: nil, repeats: true)
        print(willPlayFilePath)

        do{
            audioPlayer = try AVAudioPlayer(contentsOf: (willPlayFilePath)!)
            //audioPlayer.play()
        } catch let error as NSError{
            print("Error-initPlay:\(error)")

        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initPlay() {
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: (willPlayFilePath)!)
        } catch let error as NSError {
            print("Error-initPlay: \(error)")
        }
        
        slVolume.maximumValue = MAX_VOLUME
        slVolume.value = 1.0
        
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
        audioPlayer.volume = slVolume.value
        
        lblEndTime.text = convertNSTimeInterval2String(audioPlayer.duration)
        lblCurrentTime.text = convertNSTimeInterval2String(0)
        setPlayButtons(true, pause: false, Stop: false)
    }
    
    func setPlayButtons(_ play:Bool, pause:Bool, Stop:Bool) {
        btnPlay.isEnabled = play
        btnPause.isEnabled = pause
        btnStop.isEnabled = Stop
    }
    
    func convertNSTimeInterval2String(_ time:TimeInterval)-> String {
        let hour = Int(time/3600)
        let min = Int(time/60) % 60
        let sec = Int(time.truncatingRemainder(dividingBy: 60))
        if hour > 0 {
            return String(format: "%01d:%02d:%02d",hour, min, sec)
        }else {
            return String(format: "%02d:%02d", min, sec)
        }
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        setPlayButtons(true, pause: false, Stop: false)
    }
    
    @objc func updateSlider() {
        lblCurrentTime.text = convertNSTimeInterval2String(audioPlayer.currentTime)
        slider.value =
            Float(audioPlayer.currentTime)
        //NSLog("Hi", args:CVarArgType...)
    }
    
    @IBAction func btnPlayAudio(_ sender: UIButton) {
        audioPlayer.play()
        setPlayButtons(false, pause: true, Stop: true)
    }
    @IBAction func btnPauseAudio(_ sender: UIButton) {
        audioPlayer.pause()
        setPlayButtons(true, pause: false, Stop: true)
    }
    @IBAction func btnStopAudio(_ sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        lblCurrentTime.text = convertNSTimeInterval2String(0)
        setPlayButtons(true, pause: false, Stop: false)
    }
    @IBAction func changeAudioTime(_ sender: Any) {
        audioPlayer.play()
        audioPlayer.currentTime = TimeInterval(slider.value)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        setPlayButtons(false, pause: true, Stop: true)
    }
    
    @IBAction func btnBackwardAudio(_ sender: UIButton) {
        audioPlayer.play()
        audioPlayer.currentTime -= 5.0
    }
    
    @IBAction func btnForwardAudio(_ sender: UIButton) {
        audioPlayer.play()
        audioPlayer.currentTime += 5.0
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



