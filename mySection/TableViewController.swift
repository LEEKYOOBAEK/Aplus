//
//  TableViewController.swift
//  mySection
//
//  Created by CAUAD05 on 2018. 8. 8..
//  Copyright © 2018년 ahnYeLim. All rights reserved.
//

import UIKit


class TableViewController: UITableViewController {
    
    struct Section {
        var sectionName:String
        var records:[RecordFile]
    }
    
    var sectionArray:[Section] = [Section(sectionName: "폴더", records:[]),Section(sectionName: "음성녹음", records:[])]
    
    func saveData() {
        let filePath = getFilePath(fileName: "recordFiles.dat")
        NSKeyedArchiver.archiveRootObject(sectionArray[0].records, toFile: filePath)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //파일 저장할 저장소의 경로
        let filePath = getFilePath(fileName: "recordFiles.dat")
        
        if FileManager.default.fileExists(atPath: filePath) {
            if let records = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [RecordFile] {
                //파일 저장소에 저장한 파일이 있으면 불러오기
                self.sectionArray[0].records = records
            } else{
                return
                
            }
            
        }

    }

    @IBAction func addFolder(_ sender: Any) {
        let alert = UIAlertController(title: "폴더 생성", message: "폴더의 이름을 넣어주세요", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "폴더 이름"
        }
       
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if alert.textFields?[0].text == "" {
                let record1 = RecordFile(fileName: "음성녹음\(self.sectionArray[0].records.count + 1)", fileSubtitle: nil, fileDate: 0, fileLength: 0)
                self.sectionArray[0].records.append(record1)
            }else {
                let record1 = RecordFile(fileName: (alert.textFields?[0].text)!, fileSubtitle: nil, fileDate: 0, fileLength: 0)
                self.sectionArray[0].records.append(record1)
            }
            self.saveData()
            self.tableView.reloadData()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion:nil)
    
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sectionArray[section].records.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        guard let myCell = cell as? MyTableViewCell else{
            return cell
        }
        myCell.recordName.text = sectionArray[indexPath.section].records[indexPath.row].fileName

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionArray[section].sectionName
    }
    
    //파일 삭제하는 코드
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            sectionArray[0].records.remove(at: indexPath.row)
            saveData()
            tableView.reloadData()
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var recordName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
