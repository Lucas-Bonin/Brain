//
//  BoardDataItem.swift
//  Brain TV
//
//  Created by Lucas Bonin on 6/19/16.
//  Copyright © 2016 Lucas Bonin. All rights reserved.
//

import UIKit

class BoardDataItem: NSObject, NSCoding {
    
    
    //MARK: Propriedades
    var boardName: String!
    var backgroundImage: UIImage!
    var previewImage: UIImage?
    
    var postIt: [PostItDataItem]?
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(boardName, forKey: "boardName")
        aCoder.encodeObject(backgroundImage, forKey: "image")
        aCoder.encodeObject(previewImage, forKey: "prevImage")

        aCoder.encodeObject(postIt, forKey: "postIt")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        
        boardName = aDecoder.decodeObjectForKey("boardName") as! String
        backgroundImage = aDecoder.decodeObjectForKey("image") as! UIImage
        previewImage = aDecoder.decodeObjectForKey("prevImage") as? UIImage
        postIt = aDecoder.decodeObjectForKey("postIt") as? [PostItDataItem]
    }
    
    init(boardName: String, bkgImage: UIImage, postIt: [PostItDataItem]){
        self.boardName = boardName
        self.backgroundImage = bkgImage
        self.postIt = postIt
    }
}
