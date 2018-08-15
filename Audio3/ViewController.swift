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
   
    var memos : [Memo] = []
    
    var audioPlayer : AVAudioPlayer!
    var audioFile : URL!
    let MAX_VOLUME : Float = 10.0
    let timePlayerSelector: Selector = #selector(ViewController.updateSlider)
    
    @IBOutlet weak var memoTableView: UITableView!
    @IBOutlet weak var lblCurrentTime: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnPause: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var slVolume: UISlider!
    @IBOutlet weak var slider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()

        audioFile = Bundle.main.url(forResource: "런스위프트", withExtension : "m4a")
        print(audioFile)
        initPlay()
        slider.maximumValue = Float(audioPlayer.duration)
        _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.updateSlider), userInfo: nil, repeats: true)
    }

    func initPlay() {
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: audioFile)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnPlayAudio(_ sender: UIButton) {
        
        audioPlayer.play()
        setPlayButtons(false, pause: true, Stop: true)
   
        
    }

    @IBAction func btnPauseAudio(_ sender: UIButton) {
        
        //audioPlayer.pause()
        //audioPlayer.currentTime = 0
        
        audioPlayer.pause()
        
        setPlayButtons(true, pause: false, Stop: true)
        
        
        
    }
    
    @IBAction func btnStopAudio(_ sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        lblCurrentTime.text = convertNSTimeInterval2String(0)
        setPlayButtons(true, pause: false, Stop: false)
        
    }
    
    @IBAction func slChangeVolume(_ sender: UISlider) {
        audioPlayer.volume = slVolume.value
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
       
        setPlayButtons(true, pause: false, Stop: false)
    }
    
    @IBAction func changeAudioTime(_ sender: Any) {
        
        audioPlayer.play()
        audioPlayer.currentTime = TimeInterval(slider.value)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        setPlayButtons(false, pause: true, Stop: true)
        
    }
    
    @objc func updateSlider() {
        lblCurrentTime.text = convertNSTimeInterval2String(audioPlayer.currentTime)
        slider.value = 
            Float(audioPlayer.currentTime)
        //NSLog("Hi", args:CVarArgType...)
    }
    @IBAction func addBookmark(_ sender: UIBarButtonItem) {
        memos.append(Memo(memoText: nil, Title: lblCurrentTime.text))
        self.memoTableView.reloadData()
    }
}


extension ViewController: memoTableViewCellDelegate {
    func didSaveMemo() {
    }
    func didBtnPlayTime() {
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarkCell", for: indexPath)
        
        guard let myCell = cell as? memoTableViewCell else{
            return cell
        }
        let memo = memos[indexPath.row]
        myCell.setMemo(memo: memo)
        myCell.delegate = self
        return myCell
    }
}


