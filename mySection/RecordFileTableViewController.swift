//
//  RecordFileTableViewController.swift
//  mySection
//
//  Created by CAUAD05 on 2018. 8. 11..
//  Copyright © 2018년 ahnYeLim. All rights reserved.
//

import UIKit


class RecordFileTableViewController: UITableViewController {
    
    var selectedFilePath:URL!
    var selectedFolderName:String!
    


    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
       
    }
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        self.tableView.reloadData()
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
        do{
            let dirContent = try FileManager.default.contentsOfDirectory(at: selectedFilePath, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
            let count = dirContent.count
            return count
        }catch {
            print("Error")
            return 0

        }
       
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = selectedFolderName + "." + String(indexPath.row + 1)
        

        // Configure the cell...

        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//
//
//
//
//    }
//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextViewController = segue.destination as? RecordPlayViewController
        let selectedIndexPath = self.tableView.indexPathForSelectedRow
        if let indexPath = selectedIndexPath {
            do{
                let dirContent = try FileManager.default.contentsOfDirectory(at: selectedFilePath, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
                let filePath = dirContent[indexPath.row]
                nextViewController?.willPlayFilePath = filePath
            }catch {
                return
            }
            
        }
    }

    
    @IBAction func moveRecorder(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "recorder") as? RecorderViewController {
            vc.selectedFilePath = self.selectedFilePath
           present(vc, animated: true, completion: nil)
        }
}
    
    
    
    func getFilePath(fileNumber:Int)-> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = path[0]
        let filePath = documentDirectory.appendingPathComponent("\(fileNumber).m4a")
        return filePath
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
