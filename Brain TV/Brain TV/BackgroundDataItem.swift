//
//  BackgroundDataItem.swift
//  Brain TV
//
//  Created by Lucas Bonin on 6/18/16.
//  Copyright © 2016 Lucas Bonin. All rights reserved.
//

import UIKit

struct BackgroundDataItem{
    
    //MARK: Propriedades
    let title: String
    let image: UIImage?
    
}

//Images
extension BackgroundDataItem{
    static var images: [BackgroundDataItem] = {
        return [
            BackgroundDataItem(title: "t1", image: UIImage(named: "megapisos_morumbi_pisos_laminados_durafloor_way_patina_bege")),
            BackgroundDataItem(title: "t2", image: UIImage(named: "megapisos_morumbi_pisos_laminados_durafloor_way_patina_branca")),
            BackgroundDataItem(title: "t3", image: UIImage(named: "megapisos_morumbi_pisos_laminados_durafloor_way_patina_perola"))
        ]
    }()
}