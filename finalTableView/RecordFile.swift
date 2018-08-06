//
//  File.swift
//  finalTableView
//
//  Created by CAUAD05 on 2018. 7. 30..
//  Copyright © 2018년 ahnYeLim. All rights reserved.
//

import Foundation
import UIKit

class RecordFile {
    var name:String
    var subTitle:String?
    var coverImage:UIImage?
    
    init(name:String, subTitle:String?, coverImage:UIImage?) {
        self.name = name
        self.coverImage = coverImage
        self.subTitle = subTitle
    }
    
}
