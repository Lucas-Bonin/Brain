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
    
    
    @IBOutlet weak var postitView: UIView!
    
    @IBOutlet weak var textView: UITextView!
    
    var number = 10
    
    
    @IBAction func sendMassage(sender: AnyObject) {
        
        // Nao manda mensagem sem texto
        if self.textView.text == ""{
         return
        }
        
        // Primeiro encaminha resposta para o custom controller
        VgcManager.elements.custom[CustomElementType.TextMessage.rawValue]!.value = textView.text
        VgcManager.elements.custom[CustomElementType.IntCollor.rawValue]!.value = number
        
        // Envia mensagem
        VgcManager.peripheral.sendElementState(VgcManager.elements.custom[CustomElementType.TextMessage.rawValue]!)
        //Send collor id
        VgcManager.peripheral.sendElementState(VgcManager.elements.custom[CustomElementType.IntCollor.rawValue]!)
        
        //clean the text view
        self.textView.text = ""
        
    }
    
    //change selected collor
    @IBAction func purpleCollor(sender: AnyObject) {
        self.postitView.backgroundColor = FixedColor.getColorBy(1)
        self.number = 1
    }
    
    @IBAction func blueCollor(sender: AnyObject) {
        self.postitView.backgroundColor = FixedColor.getColorBy(2)
        self.number = 2
        
    }
    
    @IBAction func orangeCollor(sender: AnyObject) {
        self.postitView.backgroundColor = FixedColor.getColorBy(3)
        self.number = 3
        
    }
    
    @IBAction func greenCollor(sender: AnyObject) {
        self.postitView.backgroundColor = FixedColor.getColorBy(4)
        self.number = 4
        
    }
    
    @IBAction func yellowCollor(sender: AnyObject) {
        self.postitView.backgroundColor = FixedColor.getColorBy(10)
        self.number = 10
        
    }
    
    @IBAction func withoutCollor(sender: AnyObject) {
        self.postitView.backgroundColor = FixedColor.getColorBy(5)
        self.number = 5
        
    }
    
    override func viewDidLoad() {
        
        textView.becomeFirstResponder()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SendPostItViewController.peripheralDidDisconnect(_:)), name: VgcPeripheralDidDisconnectNotification, object: nil)

    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)

    }

    
}

// Notificacoes para o controle
extension SendPostItViewController{
    func peripheralDidDisconnect(notification: NSNotification){
        print("\n\n\nControle desconectado\n\n\n");
        print(navigationController)
        navigationController?.popToRootViewControllerAnimated(true)
    }

}