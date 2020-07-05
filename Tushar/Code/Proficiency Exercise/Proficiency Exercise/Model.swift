//
//  Model.swift
//  Proficiency Exercise
//
//  Created by Tushar on 05/07/20.
//  Copyright © 2020 Tushar. All rights reserved.
//

import Foundation

class Model {
    var title :String!
    var image :String!
    var description :String!
    
    init?(dictionary : JSONDictionary) {
        guard let title = dictionary["title"] as? String,
            let image = dictionary["imageHref"] as? String,
            let description = dictionary["description"] as? String else {
                return nil
        }
        self.title = title
        self.image = image
        self.description = description
    }
}
