//
//  SendPostItViewController.swift
//  Brain Remote
//
//  Created by Lucas Bonin on 6/14/16.
//  Copyright © 2016 Lucas Bonin. All rights reserved.
//

import UIKit
import Foundation

import VirtualGameController

class SendPostItViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    
    @IBAction func sendMassage(sender: AnyObject) {
        
        // Primeiro encaminha resposta para o custom controller
        VgcManager.elements.custom[CustomElementType.TextMessage.rawValue]!.value = textField.text!
        
        //TODO: Mandar uma mensagem do tipo DataMessage
//        var value: Int = 323
//        VgcManager.elements.custom[CustomElementType.DataMessage.rawValue]!.value = NSData(bytes: &value, length: sizeof(Int))
        
        // Envia mensagem
        VgcManager.peripheral.sendElementState(VgcManager.elements.custom[CustomElementType.TextMessage.rawValue]!)
        
    }
    
}