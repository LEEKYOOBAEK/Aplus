//
//  MainTableViewController.swift
//  finalTableView
//
//  Created by CAUAD05 on 2018. 7. 28..
//  Copyright © 2018년 ahnYeLim. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
var records:[RecordFile] = []
   
    @IBAction func plusFolder(_ sender: Any) {
        let alert = UIAlertController(title: "폴더 생성", message: "폴더의 이름을 넣어주세요", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "폴더 이름"
        }

        alert.addTextField { (textField2) in
            textField2.placeholder = "subtitle"
        }


        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if alert.textFields?[0].text == "" {
                let recordFile1 = RecordFile(name:"음성녹음\(self.records.count + 1)", subTitle: "subtitle", coverImage: nil)
                 self.records.append(recordFile1)

            }else {
                let recordFile1 = RecordFile(name: (alert.textFields?[0].text)!, subTitle: alert.textFields?[1].text, coverImage: nil)
                self.records.append(recordFile1)
            }
            
//           if let folderName = alert.textFields?[0].text {
//                let recordFile1 = RecordFile(name:folderName, subTitle: alert.textFields?[1].text, coverImage: nil)
//                self.records.append(recordFile1)
//            }
            
           
            self.tableView.reloadData()

            }

        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        }

            
            
            
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
//        let recordFile1 = RecordFile(name: "한국사", subTitle:"화 456 한미라 교수님", coverImage:nil)
//        let recordFile2 = RecordFile(name: "유기화학", subTitle: "월1,수12 이종찬교수님", coverImage: nil)
//        let recordFile3 = RecordFile(name: "일반물리",subTitle:"화34 남형주교수님", coverImage: nil)
//        let recordFile4 = RecordFile(name: "의약의 역사",subTitle:"금 345 정병욱 교수님", coverImage: nil)
//        let recordFile5 = RecordFile(name: "음성녹음1",subTitle: "무기녹음", coverImage: nil)
//
//        records.append(recordFile1)
//         records.append(recordFile2)
//         records.append(recordFile3)
//         records.append(recordFile4)
//         records.append(recordFile5)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return records.count
    }
    
    //파일 삭제하는 코드
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            records.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
   
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        guard let myCell = cell as? MyTableViewCell else {
            return cell
        }
        let recordFile = records[indexPath.row]
        myCell.recordName.text = recordFile.name

        if let coverImage = recordFile.coverImage {
            myCell.coverImage.image = coverImage
        }
        
        if let recordSubtitle = recordFile.subTitle {
            myCell.recordSubtitle.text = recordSubtitle
        }
       

        return cell
    }

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let vc = segue.destination as? DetailTableViewController
        let selectedIndexPath = self.tableView.indexPathForSelectedRow
        
        if let indexPath = selectedIndexPath {
            vc?.selectedFile = records[indexPath.row]
        }
    }

}
    



class MyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var recordName: UILabel!
    @IBOutlet weak var recordSubtitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

