//
//  BoardManager.swift
//  Brain TV
//
//  Created by Lucas Bonin on 6/19/16.
//  Copyright © 2016 Lucas Bonin. All rights reserved.
//

import Foundation

class BoardManager{
    static let sharedInstance = BoardManager()
    private init(){}
    
    
    private let boardKey = "boardsSaved"
    private let userDefautls = NSUserDefaults.standardUserDefaults()
    
    func saveBoard(boards: [BoardDataItem]){
        
        let encodedData = NSKeyedArchiver.archivedDataWithRootObject(boards)
        userDefautls.setObject(encodedData, forKey: boardKey)
    }
    
    func loadBoard() -> [BoardDataItem]?{
        
        guard let decodedNSData = userDefautls.objectForKey(boardKey) as? NSData, let boards = NSKeyedUnarchiver.unarchiveObjectWithData(decodedNSData) as? [BoardDataItem] else{
            print("Nao achou nenhum valor salvo")
            return nil
        }
        
        print(boards)
        
        return boards
    }
}