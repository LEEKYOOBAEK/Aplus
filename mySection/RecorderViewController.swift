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
                saveButton.isEnabled = true
                
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
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func save(_ sender: Any) {
        numberOfRecords += 1
    
        //alert로 저장 or 삭제
        let alert = UIAlertController(title: "음성 파일을 저장할까요?", message: "", preferredStyle: .alert)          //alert 형식으로 나타나도록 + 메시지
        
        
        //alert에서 '저장' 클릭하면 저장 후 파일 목록화면으로
        let saveAction = UIAlertAction(title: "저장", style:.default)
        { (action) in
            
            //stop audio recording
            self.audioRecorder.stop()        //녹음 멈춤
            self.audioRecorder = nil         //녹음 종료
            
            self.progressTimer.invalidate()      //녹음 저장하면 타이머 무효화
            
            UserDefaults.standard.set(numberOfRecords, forKey: "myRecordFileNumber")
            self.dismiss(animated: true, completion: nil)
            
            //새로운 recording을 얻었기 때문
            self.dismiss(animated: true, completion: nil)       //모달로 연결 했을 때 이전 화면으로 돌아가기
        }
        
        
        
        //alert에서 '삭제' 클릭하면 파일 삭제
        let deleteAction = UIAlertAction(title: "삭제", style: .default)
        { (action) in
            //삭제 다시 물어보는 alert로
            let alert2 = UIAlertController(title: "녹음 삭제", message: "음성파일\(numberOfRecords)을(를) 삭제 하겠습니까?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "취소", style: .default)  //창닫기
            let realdelAction = UIAlertAction(title: "삭제", style: .default)
            { (action) in
                do {
                    try FileManager.default.removeItem(at:self.selectedFilePath.appendingPathComponent("\(numberOfRecords).m4a"))
                    print("삭제할 파일은\(self.selectedFilePath.appendingPathComponent("\(numberOfRecords).m4a"))")
                }catch{
                    print("cannot delete")
                    return
                }

                self.dismiss(animated: true, completion: nil)
                
            }
            alert2.addAction(cancelAction)
            alert2.addAction(realdelAction)
            self.present(alert2, animated: true, completion: nil)
            
            //            let alert2 = UIAlertController(title: "녹음 삭제", message: "\(self.alert.TextField?[0].text)을(를) 삭제 하겠습니까?", preferredStyle: .alert)
        }
        
        alert.addAction(saveAction)     //'저장'액션 추가
        alert.addAction(deleteAction)   //'삭제'액션 추가
        self.present(alert, animated: true, completion: nil)    //alert 나타나도록
        
        
        self.audioRecorder.pause()      //'삭제'누르면 녹음 중지
        self.startBtn.setTitle("Start Recording", for: .normal)   //버튼이름 바뀜
        
        //
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.isEnabled = false
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
