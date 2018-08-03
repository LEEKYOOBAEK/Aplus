//
//  ViewController.swift
//  AudioBackground
//
//  Created by CAUAD06 on 2018. 8. 3..
//  Copyright © 2018년 CAUAD06. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var player:AVAudioPlayer = AVAudioPlayer()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        do{
            let audioPath  = Bundle.main.path(forResource: "조윤지 미팅어플", ofType: "m4a")
            try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
        
        } catch {
            //process error
            
            
        }
        let session = AVAudioSession.sharedInstance()
        
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
        }
        catch {
            
        }
        
        
        player.play()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

