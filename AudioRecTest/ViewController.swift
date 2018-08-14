//
//  ViewController.swift
//  AudioRecTest
//
//  Created by CAUAD04 on 2018. 8. 7..
//  Copyright © 2018년 CAUAD04. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation


var numberOfRecords:Int = 0

var titles:[String]?

class ViewController: UIViewController, AVAudioRecorderDelegate {
    
    let timeRecordSelector:Selector = #selector(ViewController.updateRecordTime)        //녹음 타이머를 위한 상수
    
    var recordingSession:AVAudioSession!
    var audioRecorder:AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    
    var progressTimer: Timer!       //타이머를 위한 변수
    
    var delegate:RecStoredTableViewController?
    
    
    
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var buttonLabel: UIButton!
    
    @IBAction func record(_ sender: Any)
    {
        //Check if we have an active recorder
        if audioRecorder == nil
        {
            numberOfRecords += 1
            let filename = getDirectory().appendingPathComponent("\(numberOfRecords).m4a")      //파일이 저장되는 url + 파일이름
            
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000,AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            //Start audio recording
            do{
                
                saveButton.isEnabled = true         //녹음 시작버튼 누르면 저장 버튼 활성화
                
                audioRecorder = try AVAudioRecorder(url: filename, settings: settings)
                audioRecorder.delegate = self     //??
                audioRecorder.record()  //녹음
                
                buttonLabel.setTitle("Stop Recording", for: .normal)        //버튼이름 바뀜
                progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timeRecordSelector, userInfo: nil, repeats: true)       //녹음시간 타이머
            }
            catch
            {
                displayAlert(title: "Ups!", message: "Recording failed")        //녹음 시 오류가 떴을 경우
            }
        }else        //녹음기 작동중이면   //이어서 녹음
        {
            if audioRecorder.isRecording == true{
                do{
                    audioRecorder.pause()
                    recordPlayButton.isEnabled = true       //플레이버튼 활성화
                    
                    let tmp = FileManager.default.temporaryDirectory
                    
                    buttonLabel.setTitle("Start Recording", for: .normal)       //버튼이름 바뀜
                }
            }
            else if audioRecorder.isRecording == false{
                do{
                    audioRecorder.record()
                    recordPlayButton.isEnabled = false      //플레이버튼 비활성화
                    
                    buttonLabel.setTitle("Stop Recording", for: .normal)        //버튼이름 바뀜
                }
                
            }
            
        }
    }
    
    @IBOutlet weak var saveButton: UIButton!
    
    
    //Save 버튼 클릭 - 파일 저장 + (이전 화면으로 이동) + alert로 저장 or 삭제
    @IBAction func recordSaveButton(_ sender: Any)
    {
        
        print(numberOfRecords)      //녹음 개수 프린트

        //alert로 저장 or 삭제
        let alert = UIAlertController(title: "녹음 파일을 저장할까요?", message: "", preferredStyle: .alert)          //alert 형식으로 나타나도록 + 메시지
        
//        alert.addAction(UIAlertAction(title: NSLocalizedString("저장", comment: "저장 action"), style: .default, handler: { _ in
//            NSLog("The \"저장\" alert occured.")
//        }))
        
        //alert텍스트
        alert.addTextField { (textField) in
            textField.placeholder = "음성녹음 이름"
                       
        }
        
        //alert에서 '저장' 클릭하면 저장 후 파일 목록화면으로
        let saveAction = UIAlertAction(title: "저장", style:.default)
        { (action) in
           
            //stop audio recording
            self.audioRecorder.stop()        //녹음 멈춤
            self.audioRecorder = nil         //녹음 종료
            
            self.progressTimer.invalidate()      //녹음 저장하면 타이머 무효화
            
            if alert.textFields?[0].text == "" {
                let title1 = "음성녹음\(numberOfRecords)"
                titles?.append(title1)
            }else{
                let title1 = alert.textFields?[0].text
                titles?.append(title1!)
            }
            
            //이름도 저장
            
            UserDefaults.standard.set(numberOfRecords, forKey: "myNumber")
             //새로운 recording을 얻었기 때문
            self.dismiss(animated: true, completion: nil)       //모달로 연결 했을 때 이전 화면으로 돌아가기
        }
        
//        let alert2 = UIAlertController(title: "녹음 삭제", message: "\(alert.textFields?[0].text)을(를) 삭제 하겠습니까?", preferredStyle: .alert)
        
        
        //alert에서 '삭제' 클릭하면 파일 삭제
        let deleteAction = UIAlertAction(title: "삭제", style: .default)
        { (action) in
            //삭제 다시 물어보는 alert로
            let alert2 = UIAlertController(title: "녹음 삭제", message: "\(String(describing: alert.textFields![0].text))을(를) 삭제 하겠습니까?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "취소", style: .default)  //창닫기
            let realdelAction = UIAlertAction(title: "삭제", style: .default)
            { (action) in
                self.audioRecorder.stop()
                self.audioRecorder.deleteRecording()        //파일 삭제코딩
                
                
                
               
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
        self.buttonLabel.setTitle("Start Recording", for: .normal)   //버튼이름 바뀜

        
//        self.navigationController?.popViewController(animated: true)        //show로 연결 했을 때 이전 화면으로 돌아가기
        
    }
    
    
    @IBOutlet weak var recordPlayButton: UIButton!
    
    @IBAction func replay(_ sender: Any) {
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        saveButton.isEnabled = false        //처음에는 저장 버튼 비활성화
        recordPlayButton.isEnabled = false      //처음에는 플레이 버튼 비활성화
        
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
