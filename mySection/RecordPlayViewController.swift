//
//  RecordPlayViewController.swift
//  mySection
//
//  Created by CAUAD05 on 2018. 8. 12..
//  Copyright © 2018년 ahnYeLim. All rights reserved.
//

import UIKit
import AVFoundation

class RecordPlayViewController: UIViewController {
    var willPlayFilePath:URL?
    var audioPlayer:AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        do{
            audioPlayer = try AVAudioPlayer(contentsOf: (willPlayFilePath)!)
            audioPlayer.play()
        } catch let error as NSError{
            print("Error-initPlay:\(error)")

        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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



