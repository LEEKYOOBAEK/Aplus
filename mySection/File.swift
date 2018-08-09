//
//  File.swift
//  mySection
//
//  Created by CAUAD05 on 2018. 8. 8..
//  Copyright © 2018년 ahnYeLim. All rights reserved.
//

import Foundation
import UIKit

class RecordFile {
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
    
}
