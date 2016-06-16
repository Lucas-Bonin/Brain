//
//  FixedCollors.swift
//  Brain TV
//
//  Created by Jessica Oliveira on 15/06/16.
//  Copyright © 2016 Lucas Bonin. All rights reserved.
//

import Foundation
import UIKit

struct FixedColors {
    
    static let FEMALE_COLOR = UIColor(red: 206/255, green: 113/255, blue: 225/255, alpha: 1.0)
    static let MALE_COLOR = UIColor(red: 128/255, green: 182/255, blue: 244/255, alpha: 1.0)
    static let DISABLE_COLOR = UIColor(red: 67/255, green: 65/255, blue: 61/255, alpha: 1.0)
    
    
    static func getColorBy(typeId:Int)-> UIColor{
        switch typeId {
        // pink Color
        case 1: return UIColor(red: 216/255, green: 148/255, blue: 236/255, alpha: 1.0)
        // blue Color
        case 2: return UIColor(red: 149/255, green: 198/255, blue: 222/255, alpha: 1.0)
        // orange Color
        case 3: return UIColor(red: 249/255, green: 186/255, blue: 116/255, alpha: 1.0)
        // green Color
        case 4: return UIColor(red: 186/255, green: 211/255, blue: 107/255, alpha: 1.0)
        //without collor
        case 5: return UIColor(red: 252/255, green: 223/255, blue: 62/255, alpha: 1.0)
            // yellow Color
            
        default: return UIColor(red: 245/255, green: 227/255, blue: 137/255, alpha: 1.0)
        }
    }
    
}