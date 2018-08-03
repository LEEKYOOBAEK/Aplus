//
//  ViewController.swift
//  Alert
//
//  Created by CAUAD06 on 2018. 8. 2..
//  Copyright © 2018년 CAUAD06. All rights reserved.
//https://www.youtube.com/watch?v=1Y1mZUTvWuo 참고자료


// style 에서 [cancel, destructive, default] = [서로 글씨체와 색이 다른것 뿐]
// 캔슬 : 진한 블루 글자, 디스트럭티브 : 진한 검은 텍스트

import UIKit
import Foundation


class ViewController: UIViewController {

    @IBAction func onAlertTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "새로운 폴더 이름을 지어주세요", message: "A+ 받기를 응원합니다 ", preferredStyle: .alert)
        // 타이틀이나 메세지 부분에 아무것도 넣고도 보이고도 싶지않으면 닐 입력. 빈칸 만 넣으려면... "" 이거 넣으면 되려나
        alert.addTextField { (textField) in
            textField.placeholder = "MY PLACEHOLDER HERE"
            textField.keyboardType = .numberPad
        }
        
        
        
        //여기까지 눌러서 띄우는거
        let action1 = UIAlertAction(title: "My Action 1", style: .default) { (action) in
            print(" This is action1")
            print(alert.textFields?.first?.text)
        }
        let action2 = UIAlertAction(title: "MY ACTION 2", style: .cancel) {(action) in
            print("This is Action2")
        }
        let action3 = UIAlertAction(title: "MY Action 3", style: .destructive) {(action) in
        print("DELETING ALL YOUR DATA")
            
        }
        
        alert.addAction(action3)
        alert.addAction(action2)
        alert.addAction(action1)
        //위 엘럴트 세개(액션 1,2,3) 순서가 실제 보여지는 순서이다
        //style 은 말그대로 진짜 스타일
        present(alert, animated:true, completion:nil)
        
    }
    
    
    //액션시트가 바로 아래 부분인데/ 액션시트에는 택스트 필드를 넣으면 크랙이 일어난다
    @IBAction func onActionSheetTapped(_ sender: Any) {
        
        let sheet = UIAlertController(title: "My title here", message: "My message", preferredStyle: .actionSheet)
        present(sheet, animated:true, completion:nil)
        let action1 = UIAlertAction(title: "My Action 1", style: .default) { (action) in
            print(" This is action1")
    }
    sheet.addAction(action1)
    present(sheet, animated:true, completion:nil)
}

}
