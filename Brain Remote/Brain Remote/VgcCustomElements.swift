//
//  VgcCustomElements.swift
//  Brain TV
//
//  Created by Lucas Bonin on 6/14/16.
//  Copyright © 2016 Lucas Bonin. All rights reserved.
//

import Foundation
import VirtualGameController


public enum CustomElementType: Int {
    
    case TextMessage = 50
    case DataMessage = 51
    case IntCollor   = 52

    
}

public class CustomElements: CustomElementsSuperclass {
    
    override init() {
        
        super.init()
        
        // Cria todos os customElemets
        
        //TODO: Criar novo elemento que recebe um DATA
        customProfileElements = [
            CustomElement(name: "Text Message", dataType: .String, type:CustomElementType.TextMessage.rawValue),
            CustomElement(name: "Data Message", dataType: .Data, type:CustomElementType.DataMessage.rawValue),
            CustomElement(name: "Int Collor", dataType: .Int, type:CustomElementType.IntCollor.rawValue)
            
        ]
        
    }
    
}