//
//  BoardViewController.swift
//  Brain TV
//
//  Created by Lucas Bonin on 6/14/16.
//  Copyright © 2016 Lucas Bonin. All rights reserved.
//

import UIKit
import VirtualGameController

class BoardViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralInit()
    }
    
    private func centralInit(){
        
        // Inicializa Central
        VgcManager.startAs(.Central, appIdentifier: "bRain", customElements: CustomElements(), customMappings: CustomMappings(), includesPeerToPeer: true)
        
        // Notificacoes quando um controle conectar ou desconectar
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector (BoardViewController.controllerDidConnect(_:)), name: VgcControllerDidConnectNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector (BoardViewController.controllerDidDisconnect(_:)), name: VgcControllerDidDisconnectNotification, object: nil)
        
        //Handler para os controles
        Elements.customElements.valueChangedHandler = { [unowned self](controller, element) in
            
            //TODO: Receber Data ao inves de String
            if (element.identifier == CustomElementType.TextMessage.rawValue) {
                print("recebeu mensagem de texto:\n");
                let text = element.value as? String
                print(text!)
                
                // Instancia um novo PostIt ao receber uma
                let customView = PostItView(frame: CGRect(x: (CGFloat)(arc4random_uniform(1920)), y: (CGFloat)(arc4random_uniform(1080)), width: 500, height: 500))
                customView.backgroundColor = UIColor(red: (CGFloat)(drand48()), green: (CGFloat)(drand48()), blue: (CGFloat)(drand48()), alpha: 1)
                customView.textLabel.text = text
                //customView.delegate = self
                self.view.addSubview(customView)
            }
        }
    }
    
    //MARK: Notificacoes do controle
    func controllerDidConnect(notification: NSNotification){
        
        // Verifica se eh um Vcgontroller
        guard let newController: VgcController = notification.object as? VgcController
            else{
                return
        }
        
        print("Novo controle conectado: \(newController.deviceInfo.vendorName)")
    }
    
    
    func controllerDidDisconnect(notification: NSNotification){
        
        // Verifica se eh um Vcgontroller
        guard let newController: VgcController = notification.object as? VgcController
            else{
                return
        }
        
        print("Controle desconectado: \(newController.deviceInfo.vendorName)")
    }
}
