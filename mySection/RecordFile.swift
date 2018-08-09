//
//  RecordFile.swift
//  mySection
//
//  Created by CAUAD05 on 2018. 8. 8..
//  Copyright © 2018년 ahnYeLim. All rights reserved.
//

import Foundation
import UIKit

class RecordFile:NSObject, NSCoding {
    var fileName:String?
    var fileSubtitle:String?
    var fileDate:Int
    var fileLength:Int
    
    init(fileName:String?, fileSubtitle:String?, fileDate:Int, fileLength:Int) {
        self.fileName = fileName
        self.fileSubtitle = fileSubtitle
        self.fileDate = fileDate
        self.fileLength = fileLength
    }
    convenience init(fileName:String?, fileSubtitle:String?) {
        self.init(fileName: fileName, fileSubtitle: fileSubtitle, fileDate: 0, fileLength: 0)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.fileName, forKey:"fileName")
        aCoder.encode(self.fileSubtitle, forKey:"fileSubtitle")
        aCoder.encode(self.fileDate, forKey:"fileDate")
        aCoder.encode(self.fileLength, forKey:"fileLength")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
         self.fileSubtitle = aDecoder.decodeObject(forKey:"fileSubtitle") as? String
         self.fileName = aDecoder.decodeObject(forKey:"fileName") as? String
         self.fileDate = aDecoder.decodeObject(forKey:"fileDate") as! Int
         self.fileLength = aDecoder.decodeObject(forKey:"fileLength") as! Int
        }

    
}
    

