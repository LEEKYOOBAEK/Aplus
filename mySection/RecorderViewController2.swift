////
////  RecorderViewController2.swift
////  mySection
////
////  Created by CAUAD05 on 2018. 8. 12..
////  Copyright © 2018년 ahnYeLim. All rights reserved.
////
//
//import UIKit
//import AVFoundation
//
//var numberOfRecords2:Int = 0
//
//class RecorderViewController2: UIViewController,AVAudioRecorderDelegate {
//    
//    var recordingSession:AVAudioSession!
//    var audioRecorder:AVAudioRecorder!
//    let timeRecordSelector:Selector = #selector(RecorderViewController.updateRecordTime)
//    var progressTimer: Timer!
//    
//
//    @IBOutlet weak var currentTime: UILabel!
//    @IBOutlet weak var startBtn: UIButton!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        recordingSession = AVAudioSession.sharedInstance()
//        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
//            if hasPermission{
//                print("Accepted")
//            }
//        }
//}
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    @IBAction func record(_ sender: Any) {
//        //check if we have an active recorder
//        if audioRecorder == nil{
//            numberOfRecords += 1
//            let filename = getFilePath(fileNumber: numberOfRecords)
//            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000,AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
//            do{
//                audioRecorder = try AVAudioRecorder(url: filename, settings: settings)
//                audioRecorder.delegate = self
//                audioRecorder.record()
//                startBtn.setTitle("Stop Recording", for: .normal)
//            }catch {
//                disPlayAlert(title: "Error", message: "Recording Failed")
//            }
//        }else{
//            if audioRecorder.isRecording == true{
//                do {audioRecorder.pause()
//                    startBtn.setTitle("Start Recording", for: .normal) }
//            }else if audioRecorder.isRecording == false {
//                do{
//                    audioRecorder.record()
//                    startBtn.setTitle("Stop Recording", for: .normal)
//                }
//            }
//        }
//    }
//    
//    @IBAction func save(_ sender: Any) {
//        audioRecorder.stop()
//        audioRecorder = nil
//        
//        UserDefaults.standard.set(numberOfRecords, forKey: "myRecordFileNumber")
//        self.dismiss(animated: true, completion: nil)
//    }
//    
//   //Function that gets path to directory
//    func getFilePath(fileNumber:Int)-> URL {
//        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let documentDirectory = path[0]
//        let filePath = documentDirectory.appendingPathComponent("\(fileNumber).m4a")
//        return filePath
//    }
//    //function that displays an alert
//    func disPlayAlert(title:String, message:String){
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
//        present(alert, animated: true, completion: nil)
//    }
//    
//    func convertNSTimeIntervalToString(_ time:TimeInterval) -> String {
//        
//        let min = Int(time/60)
//        let sec = Int(time.truncatingRemainder(dividingBy: 60))
//        let strTime = String(format: "%02d:%02d", min, sec)
//        return strTime
//        
//    }
//    
//    @objc func updateRecordTime() {
//        currentTime.text = convertNSTimeIntervalToString(audioRecorder.currentTime)
//    }
// 
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
