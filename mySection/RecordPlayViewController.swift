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
    
    
    var memos : [Memo] = []
    var willPlayFilePath:URL?
    var audioPlayer:AVAudioPlayer!
    let MAX_VOLUME : Float = 10.0
    let timePlayerSelector: Selector = #selector(RecordPlayViewController.updateSlider)
    
    @IBOutlet weak var btnbackPage: UIBarButtonItem!
    @IBOutlet weak var memoTableView: UITableView!
    @IBOutlet weak var btnForward: UIButton!
    @IBOutlet weak var btnBackward: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnPause: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var lblCurrentTime: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var lblSpeed: UILabel!
    @IBOutlet weak var slSpeed: UISlider!
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        didMemoView()
        
        initPlay()
        audioPlayer.enableRate = true
        slider.maximumValue = Float(audioPlayer.duration)
        _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(RecordPlayViewController.updateSlider), userInfo: nil, repeats: true)
        

        do{
            audioPlayer = try AVAudioPlayer(contentsOf: (willPlayFilePath)!)
            //audioPlayer.play()
        } catch let error as NSError{
            print("Error-initPlay:\(error)")

        }

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
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
        
        
        
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
        audioPlayer.volume = 10.0
        
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
    
    @IBAction func slChangeSpeed(_ sender: UIButton) {
        lblSpeed.text = String(format: "Speed: %.2f", slSpeed.value)
        audioPlayer.rate = slSpeed.value
    }
    
    
    @IBAction func btnBackwardAudio(_ sender: UIButton) {
        audioPlayer.play()
        audioPlayer.currentTime -= 5.0
    }
    
    @IBAction func btnForwardAudio(_ sender: UIButton) {
        audioPlayer.play()
        audioPlayer.currentTime += 5.0
    }
    
    
    @IBAction func addBookmark(_ sender: UIBarButtonItem) {
        didSaveMemo()
        didMemoView()
        memos.append(Memo(memoText: "", Title: lblCurrentTime.text))
        
        self.memoTableView.reloadData()
    }

    @IBAction func backPage(_ sender: UIBarButtonItem) {
        let backItem = btnbackPage
        navigationItem.backBarButtonItem = backItem; self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
        audioPlayer.pause()
    }
    
    func didBtnPlayTime(_ sender: memoTableViewCell) {
        var realtime:Int?
        
        //        if memos[0].Title?.components(separatedBy: ":").count == 3 {
        //            let hour = Int((memos[0].Title?.components(separatedBy: ":")[0])!)!
        //            let min = Int((memos[0].Title?.components(separatedBy: ":")[1])!)!
        //            let sec = Int((memos[0].Title?.components(separatedBy: ":")[2])!)!
        //            let time = hour * 3600 + min * 60 + sec
        //            realtime = time
        //        } else {
        //            let min = Int((memos[0].Title?.components(separatedBy: ":")[0])!)!
        //            let sec = Int((memos[0].Title?.components(separatedBy: ":")[1])!)!
        //            let time = min * 60 + sec
        //            realtime = time
        //        }
        
        if memos[0].Title?.components(separatedBy: ":").count == 3 {
            let hour = Int((memos[0].Title?.components(separatedBy: ":")[0])!)!
            let min = Int((memos[0].Title?.components(separatedBy: ":")[1])!)!
            let sec = Int((memos[0].Title?.components(separatedBy: ":")[2])!)!
            let time = hour * 3600 + min * 60 + sec
            realtime = time
        } else {
            let min = Int((memos[0].Title?.components(separatedBy: ":")[0])!)!
            let sec = Int((memos[0].Title?.components(separatedBy: ":")[1])!)!
            let time = min * 60 + sec
            realtime = time
        }
        
        audioPlayer.stop()
        audioPlayer.currentTime = Double(realtime!)
        setPlayButtons(true, pause: false, Stop: false)
        
        
        
        
        
        
        
        // let aaa:TimeInterval = 13.0
        // sender.btnMemoTime.titleLabel?.text
        // audioPlayer.stop()
        // audioPlayer.play(atTime: aaa)
        
        
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


extension RecordPlayViewController: memoTableViewCellDelegate {
    func didMemoTextField(_ sender: memoTableViewCell) {
        guard let indexPath = memoTableView.indexPath(for: sender) else { return }
        memos[indexPath.row].memoText = sender.memoTextField.text
    }
    
    func didMemoView() {
    }
    func didSaveMemo() {
    }
    /*
     func didBtnPlayTime(_ sender: memoTableViewCell) {
     // let aaa:TimeInterval = 13.0
     // sender.btnMemoTime.titleLabel?.text
     // audioPlayer.stop()
     // audioPlayer.play(atTime: aaa)
     let aaa = ViewController()
     print(memos.)
     }
     */
}


extension RecordPlayViewController: UITableViewDelegate, UITableViewDataSource {
    
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





/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */
