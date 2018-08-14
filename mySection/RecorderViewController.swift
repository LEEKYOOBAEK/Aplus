//
//  RecorderViewController.swift
//  mySection
//
//  Created by CAUAD05 on 2018. 8. 11..
//  Copyright © 2018년 ahnYeLim. All rights reserved.
//

import UIKit
import AVFoundation

var numberOfRecords:Int = 0

class RecorderViewController: UIViewController, AVAudioRecorderDelegate {
    let timeRecordSelector:Selector = #selector(RecorderViewController.updateRecordTime)
    var recordingSession:AVAudioSession!
    var audioRecorder:AVAudioRecorder!
    
    var progressTimer: Timer!
    
    var selectedFilePath:URL!

    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var currentTime: UILabel!
    
    @IBAction func record(_ sender: Any) {
        if audioRecorder == nil {
           
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000,AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            do{
                audioRecorder = try AVAudioRecorder(url: selectedFilePath.appendingPathComponent("\(numberOfRecords + 1).m4a"), settings: settings)
                audioRecorder.delegate = self as AVAudioRecorderDelegate
                audioRecorder.record()
                
                startBtn.setTitle("Stop Recording", for: .normal)
                progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:timeRecordSelector, userInfo:nil, repeats:true)
            }catch {
                displayAlert(title: "Error", message: "Recording failed")
            }
        } else {
            if audioRecorder.isRecording == true {
                do { audioRecorder.pause()
                    startBtn.setTitle("Start Recording", for: .normal)
                    
                }
            }else if audioRecorder.isRecording == false {
                do{
                    audioRecorder.record()
                    startBtn.setTitle("Stop Recording", for: .normal)
                }
            }
        }
    }
    
    @IBAction func save(_ sender: Any) {
        numberOfRecords += 1
        
        audioRecorder.stop()
        audioRecorder = nil
        
        progressTimer.invalidate()
        
        UserDefaults.standard.set(numberOfRecords, forKey: "myRecordFileNumber")
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("selectedFilePath는\(selectedFilePath)")
        
        if let fileNumber = UserDefaults.standard.object(forKey: "myRecordFileNumber") as? Int {
            numberOfRecords = fileNumber
        }

        // Do any additional setup after loading the view.
        
        recordingSession = AVAudioSession.sharedInstance()
        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
            if hasPermission{
                print("Accepted")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getFilePath(fileNumber:Int)-> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = path[0]
        let filePath = documentDirectory.appendingPathComponent("\(fileNumber).m4a")
        return filePath
    }
   
    func displayAlert(title:String, message:String)
    {
        let alert = UIAlertController(title: title , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func convertNSTimeIntervalToString(_ time:TimeInterval) -> String {
        
        let min = Int(time/60)
        let sec = Int(time.truncatingRemainder(dividingBy: 60))
        let strTime = String(format: "%02d:%02d", min, sec)
        return strTime
        
    }
    
    @objc func updateRecordTime() {
        currentTime.text = convertNSTimeIntervalToString(audioRecorder.currentTime)
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
