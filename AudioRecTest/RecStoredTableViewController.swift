//
//  RecStoredTableViewController.swift
//  AudioRecTest
//
//  Created by CAUAD04 on 2018. 8. 7..
//  Copyright © 2018년 CAUAD04. All rights reserved.
//

import UIKit
import AVFoundation


class RecStoredTableViewController: UITableViewController {
    
    var audioPlayer:AVAudioPlayer!
    
        
    @IBOutlet var myTableView: UITableView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let number:Int = UserDefaults.standard.object(forKey: "myNumber") as? Int        //viewDidLoad에서 파일 불러와야 처음 들어갔을 떄 파일 뜸
        {
            numberOfRecords = number
        }
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        myTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //Function that gets path to directory
    func getDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask) // 도큐먼트 디렉토리 가져오는 것 (숙어처럼 사용)
        let documentDirectory = paths[0]        //첫번째 것 //배열형태 반환 - 인덱스 0번째에만 값이 저장되기 때문에 인덱스 0값만 불러온다.
        return documentDirectory
    }
    
    
    //Setting up table view
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return numberOfRecords      //셀의 개수 = 레코드 수
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "음성녹음" + String(indexPath.row + 1)        //녹음후 녹음파일 이름(첫번째 인덱스가 0이기 때문에 +1 해준다)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let path = getDirectory().appendingPathComponent("\(indexPath.row + 1).m4a")

        do          //테이블 뷰 셀에 녹음된 파일 입히고 누르면 플레이
        {
            audioPlayer = try AVAudioPlayer(contentsOf: path)
            audioPlayer.play()
        }
        catch
        {

        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?)       //값을 전달push
//    {
//        var numOfRecords = numberOfRecords
//    }
//

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


