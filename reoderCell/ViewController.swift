//
//  ViewController.swift
//  reoderCell
//
//  Created by CAUAD04 on 2018. 8. 6..
//  Copyright © 2018년 CAUAD04. All rights reserved.
//

import UIKit


class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    var array = ["one", "two", "three", "four", "five"]

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return array.count
    }
    
    //셀에 array배열
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = array[indexPath.row]
        return cell!
    }
    
    //Allows reodering cells
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        let item = array[sourceIndexPath.row]
        array.remove(at: sourceIndexPath.row)   //원래 있던 곳에서 제거
        array.insert(item, at: destinationIndexPath.row)    //옮긴 곳에 삽입
    }
    
    //edit 삭제
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if  editingStyle == UITableViewCellEditingStyle.delete
        {
            array.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    //체크박스 선택하고 해제
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        }else
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
    }
    
    
    @IBAction func edit(_ sender: Any)
    {
        myTableView.isEditing = !myTableView.isEditing
        switch myTableView.isEditing {
        case true:
            editButton.title = "done"
        case false:
            editButton.title = "edit"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}



