//
//  PostItContent.swift
//  Brain Remote
//
//  Created by Lucas Bonin on 6/15/16.
//  Copyright © 2016 Lucas Bonin. All rights reserved.
//

import Foundation


class PostItContent : NSObject, NSCoding{
 
    var color: Int!
    var text: String!

    private static let colorKey = "color"
    private static let textKey = "text"

    required init (coder: NSCoder){
        self.color = coder.decodeObjectForKey(PostItContent.colorKey) as! Int
        self.text = coder.decodeObjectForKey(PostItContent.textKey) as! String
    }

    init(color: Int, text: String){
        self.color = color
        self.text = text
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(color, forKey: PostItContent.colorKey)
        aCoder.encodeObject(text, forKey: PostItContent.textKey)

    }
}
 