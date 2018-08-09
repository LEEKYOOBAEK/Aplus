//
//  ViewController.swift
//  AudioRecTest
//
//  Created by CAUAD04 on 2018. 8. 7..
//  Copyright © 2018년 CAUAD04. All rights reserved.
//

import UIKit
import AVFoundation


var numberOfRecords:Int = 0

class ViewController: UIViewController, AVAudioRecorderDelegate {
    
    let timeRecordSelector:Selector = #selector(ViewController.updateRecordTime)        //녹음 타이머를 위한 상수
    
    var recordingSession:AVAudioSession!
    var audioRecorder:AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    
    var progressTimer: Timer!       //타이머를 위한 변수
    
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var buttonLabel: UIButton!
    
    @IBAction func record(_ sender: Any)
    {
        //Check if we have an active recorder
        if audioRecorder == nil
        {
            
            let filename = getDirectory().appendingPathComponent("\(numberOfRecords).m4a")
            
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000,AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            //Start audio recording
            do{
                
                audioRecorder = try AVAudioRecorder(url: filename, settings: settings)
                audioRecorder.delegate = self as AVAudioRecorderDelegate    //??
                audioRecorder.record()  //녹음
                
                buttonLabel.setTitle("Stop Recording", for: .normal)        //버튼이름 바뀜
                progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timeRecordSelector, userInfo: nil, repeats: true)       //녹음시간 타이머
            }
            catch
            {
                displayAlert(title: "Ups!", message: "Recording failed")        //녹음 시 오류가 떴을 경우
            }
        }else
        {
            audioRecorder.pause()       //녹음 중지
            
//            audioRecorder = nil
            
            
            buttonLabel.setTitle("Start Recording", for: .normal)       //버튼이름 바뀜
            
        }
    }
    
    //Save 버튼 클릭 - 파일 저장 + 이전 화면으로 이동
    @IBAction func recordSaveButton(_ sender: Any)
    {
        numberOfRecords += 1
        print(numberOfRecords)      //녹음 개수 프린트
        
        //stop audio recording
        audioRecorder.stop()        //녹음 멈춤
        audioRecorder = nil         //녹음 종료
        
        progressTimer.invalidate()      //녹음 저장하면 타이머 무효화
        
        UserDefaults.standard.set(numberOfRecords, forKey: "myNumber")          //???
        //            myTableView.reloadData()        //새로운 recording을 얻었기 때문
        
        
        self.navigationController?.popViewController(animated: true)        //이전 화면으로 돌아가기
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
              
        //settig up session
        recordingSession = AVAudioSession.sharedInstance()
        
        if let number:Int = UserDefaults.standard.object(forKey: "myNumber") as? Int
        {
            numberOfRecords = number
        }
        
        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in            //오디오사용 off시 사용허락받기
            if hasPermission
            {
                print("Accepted")
            }
        }
    }
    
    //Function that gets path to directory
    func getDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask) // 도큐먼트 디렉토리 가져오는 것 (숙어처럼 사용)
        let documentDirectory = paths[0]        //첫번째 것 //배열형태 반환 - 인덱스 0번째에만 값이 저장되기 때문에 인덱스 0값만 불러온다.
        return documentDirectory
    }
    
    //Function that displays an alert
    func displayAlert(title:String, message:String)
    {
        let alert = UIAlertController(title: title , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    //
    func convertNSTimeIntervalToString(_ time:TimeInterval) -> String {
        
        let min = Int(time/60)
        let sec = Int(time.truncatingRemainder(dividingBy: 60))
        let strTime = String(format: "%02d:%02d", min, sec)
        return strTime
        
    }
    
    @objc func updateRecordTime() {
        currentTimeLabel.text = convertNSTimeIntervalToString(audioRecorder.currentTime)
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//                                                                                                                                                                                                                                                                                                                                                                                                                                     
//    }

}
