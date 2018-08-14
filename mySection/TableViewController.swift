//
//  TableViewController.swift
//  mySection
//
//  Created by CAUAD05 on 2018. 8. 8..
//  Copyright © 2018년 ahnYeLim. All rights reserved.
//

import UIKit



class TableViewController: UITableViewController {
    
    var folderSection:[String] = []
    var recordFileSection:[RecordFile] = []
    
    var folderCount:Int = 0
    let basicFolder = createFolder(fileName: "BasicFolder")
    
    
   
    
    
//    func saveData() {
//        let filePath = getFilePath(fileName: "recordFiles.dat")
//        NSKeyedArchiver.archiveRootObject(sectionArray[0].records, toFile: filePath)
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.reloadData()
        
       
       if let newFolder = UserDefaults.standard.object(forKey: "myFolder") as? [String] {
            self.folderSection = newFolder
        }
        
        self.folderCount = UserDefaults.standard.integer(forKey: "forderNumber")
        print("폴더 수는 \(folderCount)")
        
        

    }

    @IBAction func addFolder(_ sender: Any) {
        let alert = UIAlertController(title: "폴더 생성", message: "폴더의 이름을 넣어주세요", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "폴더 이름"
        }
       
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if alert.textFields?[0].text == "" {
                self.folderSection.append("Folder\(self.folderSection.count + 1)")
            }else {
                self.folderSection.append((alert.textFields?[0].text)!)
            }
//            self.saveData()
            UserDefaults.standard.set(self.folderSection, forKey: "myFolder")
            self.folderCount += 1
            UserDefaults.standard.set(self.folderCount, forKey: "forderNumber")
            let newFilePath = createFolder(fileName: "folder\(self.folderCount)")
            self.tableView.reloadData()
            print("새로운 폴더명은 \(newFilePath)")
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
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return folderSection.count
            
        }else {
            do{
                let dirContent = try FileManager.default.contentsOfDirectory(at:basicFolder, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
                let count = dirContent.count
                return count
            }catch {
                print("Error")
                return 0
                
            }
        }

    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        guard let myCell = cell as? MyTableViewCell else{
            return cell
        }
        if indexPath.section == 0 {
            myCell.recordName.text = folderSection[indexPath.row]
        }else {
            myCell.recordName.text = "음성녹음\(indexPath.row + 1)"
        }

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "폴더"
        }else  {
            return "음성파일"
        }
      
        
    }
    
    //파일 삭제하는 코드
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            
            if indexPath.section == 0 {
                folderSection.remove(at: indexPath.row)
            } else {
                
            }
            UserDefaults.standard.set(folderSection, forKey: "myFolder")
            tableView.reloadData()
        }
    }
    
    @IBAction func moveRecorder(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "recorder") as? RecorderViewController {
            vc.selectedFilePath = basicFolder
            present(vc, animated: true, completion: nil)
            
    }
    }
    

    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "recordPlayer") as? RecordPlayViewController{
                do {
                    let dirContent = try FileManager.default.contentsOfDirectory(at: basicFolder, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
                    let filePath = dirContent[indexPath.row]
                    vc.willPlayFilePath = filePath
            }catch{
                return
            }
                self.navigationController?.show(vc, sender: nil)
            }
            
//            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "")as? GreenViewController {
//                vc.labelStr = ""
//                self.present(vc,animated: true, completion:nil)
//            }
            
            } else if indexPath.section == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "recordView") as? RecordFileTableViewController {
                let path = getFilePath()
                let selectPath = path.appendingPathComponent("folder\(indexPath.row + 1)")
                vc.selectedFilePath = selectPath
                vc.selectedFolderName = self.folderSection[indexPath.row]
                self.navigationController?.show(vc, sender: nil)
                }
        }
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let nextViewController = segue.destination as? RecordPlayViewController
//        let selectedIndexPath = self.tableView.indexPathForSelectedRow
//        if let indexPath = selectedIndexPath {
//            nextViewController?.selectedFilePath = getFilePath(fileNumber: )
//        }
//    }
    
//    func getFilePath(fileNumber:Int)-> URL {
//        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let documentDirectory = path[0]
//        let filePath = documentDirectory.appendingPathComponent("\(fileNumber).m4a")
//        return filePath
//    }

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
