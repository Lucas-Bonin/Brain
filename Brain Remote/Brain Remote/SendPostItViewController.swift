//
//  SendPostItViewController.swift
//  Brain Remote
//
//  Created by Lucas Bonin on 6/14/16.
//  Copyright © 2016 Lucas Bonin. All rights reserved.
//

import UIKit
import VirtualGameController

class SendPostItViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    
    @IBAction func sendMassage(sender: AnyObject) {
        
        //TODO: Mandar um Data com o texto e a cor excolhida pelo usuario
        
        // Primeiro encaminha resposta para o custom controller
        VgcManager.elements.custom[CustomElementType.TextMessage.rawValue]!.value = textField.text!
        
        // Envia mensagem
        VgcManager.peripheral.sendElementState(VgcManager.elements.custom[CustomElementType.TextMessage.rawValue]!)
        
    }
    
}