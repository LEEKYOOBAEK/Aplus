//
//  memoTableViewCell.swift
//  Audio3
//
//  Created by CAUAD06 on 2018. 8. 14..
//  Copyright © 2018년 CAUAD06. All rights reserved.
//

import UIKit
import AVFoundation

protocol memoTableViewCellDelegate {
    func didBtnPlayTime()
    func didSaveMemo()
}


class memoTableViewCell: UITableViewCell, AVAudioPlayerDelegate {

    var audioPlayer: AVAudioPlayer!
  
    @IBOutlet weak var btnMemoTime: UIButton!
    @IBOutlet weak var memoTextField: UITextField!

    var delegate: memoTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    //
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setMemo(memo: Memo) {
        memoTextField.text = memo.memoText
        btnMemoTime.setTitle(memo.Title,for: .normal)
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
    
    @IBAction func btnPlayTime(_ sender: Any) {
        delegate?.didBtnPlayTime()
    }
    @IBAction func saveMemo(_ sender: Any) {
        
        
        UserDefaults.standard.object(forKey: "MemoText")
        
        
        delegate?.didSaveMemo()
    }
}
