//
//  BoardDataItem.swift
//  Brain TV
//
//  Created by Lucas Bonin on 6/19/16.
//  Copyright © 2016 Lucas Bonin. All rights reserved.
//

import UIKit

class PostItDataItem: NSObject, NSCoding {
    
    //MARK: Propriedades
    var color: Int!
    var text: String!
    var originPosition: CGPoint!
    
    //MARK: Metodos
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(color, forKey: "color")
        aCoder.encodeObject(text, forKey: "text")
        
        // Transformar CGPoint
        let valuePosition = NSValue(CGPoint: originPosition)

        aCoder.encodeObject(valuePosition, forKey: "position")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        
        color = aDecoder.decodeObjectForKey("color") as! Int
        text = aDecoder.decodeObjectForKey("text") as! String
        
        let valuePosition = aDecoder.decodeObjectForKey("position") as! NSValue
        
        originPosition = valuePosition.CGPointValue()
        
    }
    
    init(color: Int, text: String, position: CGPoint){
        super.init()
        
        self.color = color
        self.text = text
        self.originPosition = position
    }
}
