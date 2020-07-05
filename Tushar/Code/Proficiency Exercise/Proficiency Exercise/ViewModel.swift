//
//  ViewModel.swift
//  Proficiency Exercise
//
//  Created by Tushar on 05/07/20.
//  Copyright © 2020 Tushar. All rights reserved.
//

import Foundation

class ViewModel : NSObject {
    var title :String?
    var desc :String?
    var image :String?
    
    init(mObj :Model) {
        self.title = mObj.title
        self.desc = mObj.description
        self.image = mObj.image
    }
}
