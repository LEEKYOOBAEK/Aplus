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
    func didBtnPlayTime(_ sender: memoTableViewCell)
    func didSaveMemo()
    func didMemoView()
    func didMemoTextField(_ sender: memoTableViewCell)
}


class memoTableViewCell: UITableViewCell, AVAudioPlayerDelegate {

    var audioPlayer: AVAudioPlayer!
    var delegate: memoTableViewCellDelegate?
    var memohaza :String?
    @IBOutlet weak var btnMemoTime: UIButton!
    @IBOutlet weak var memoTextField: UITextField!

    @IBAction func memoTextField(_ sender: UITextField) {
        delegate?.didMemoTextField(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    //
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
       // print("I`m selected")
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
    func memoView() {
        if let memo1 = UserDefaults.standard.object(forKey: "memogaza") as? String{
            memoTextField.text = memo1
            delegate?.didMemoView()
        }
    }
    @IBAction func btnPlayTime(_ sender: Any) {
        
        delegate?.didBtnPlayTime(self)
    }
    
    @IBAction func saveMemo(_ sender: Any) {
        self.memohaza = memoTextField.text!
        UserDefaults.standard.set(self.memohaza, forKey: "memogaza")
        memoView()
        print(memoTextField.text)
        delegate?.didSaveMemo()
        
        
    }
}
