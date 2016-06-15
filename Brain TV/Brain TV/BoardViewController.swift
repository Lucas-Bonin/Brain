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
    
    var selectedView: UIView?
    var customViewMaster = UIView()
    
    //cursor
    var cursorView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralInit()
        
        cursorInit()
        

    }
    
    private func cursorInit(){
        cursorView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 64.0, height: 64.0))
        cursorView.center = CGPointMake(CGRectGetMidX(UIScreen.mainScreen().bounds), CGRectGetMidY(UIScreen.mainScreen().bounds))
        cursorView.image =  UIImage(named: "cursor")
        cursorView.backgroundColor = UIColor.redColor()
        cursorView.hidden = false
        view.addSubview(cursorView)
        
        // Cria um recognizer para o cursor
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(BoardViewController.panGesture(_:)))
        let tapRecognizer = UITapGestureRecognizer(target: self, action:#selector(BoardViewController.tapGesture(_:)))
        
        self.view.addGestureRecognizer(tapRecognizer)
        self.view.addGestureRecognizer(recognizer)
    }
    
    private func centralInit(){
        
        // Inicializa Central
        VgcManager.startAs(.Central, appIdentifier: "bRainLucas", customElements: CustomElements(), customMappings: CustomMappings(), includesPeerToPeer: true)
        
        // Notificacoes quando um controle conectar ou desconectar
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector (BoardViewController.controllerDidConnect(_:)), name: VgcControllerDidConnectNotification, object: nil)
    }
    
    //MARK: Controle do cursor
    
    func panGesture(recognizer: UIPanGestureRecognizer){
        
        let translation = recognizer.translationInView(cursorView)
        
        // Mover view que estiver selecionada
        if let sView = selectedView{
            self.view.bringSubviewToFront(sView)
            
            sView.center = CGPoint(x:sView.center.x + translation.x, y:sView.center.y + translation.y)
        }
        
        self.view.bringSubviewToFront(cursorView)
        
        cursorView.center = CGPoint(x:cursorView.center.x + translation.x, y:cursorView.center.y + translation.y)
        
        recognizer.setTranslation(CGPointZero, inView: cursorView)
    }
    
    func tapGesture(recognizer: UIPanGestureRecognizer){
        
        // Se houver um click e uma view ja estiver selecionada
        if selectedView != nil{
            //TODO: Fazer alguma animacao na view quando desselecionada
            selectedView = nil
            return
        }
        
        // Verifica se existe alguma view no ponto clicado
        if let tappedView = self.view.hitTest(cursorView.frame.origin, withEvent: nil){
            if tappedView != self.view{
                //TODO: Fazer uma animacao para a view selecionada
                selectedView = tappedView
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
        
        //no exemplo o código abaixo está aqui. Como não consegui testar não sei se faz diferença
        
        //Value Handler for custom controls
        Elements.customElements.valueChangedHandler = { [unowned self](controller, element) in
            
            if (element.identifier == CustomElementType.TextMessage.rawValue) {
                print("recebeu mensagem de texto:\n");
                let text = element.value as? String
                print(text!)
                
                let x = (CGFloat)(arc4random_uniform(400))
                let y = (CGFloat)(arc4random_uniform(550))
                
                let customView = PostItView(frame: CGRect(x: x , y: y, width: self.view.layer.frame.height/6, height: self.view.layer.frame.height/6))
                
                customView.backgroundColor = FixedColors.getColorBy(10)
                
                //config shdow
                customView.layer.shadowColor = UIColor.blackColor().CGColor
                customView.layer.shadowOffset = CGSize(width: 4.0, height: 4.0);
                customView.layer.shadowRadius = 5.0;
                customView.layer.shadowOpacity = 0.5;
                
                customView.textLabel.text = text
                
                //change to animations
                customView.alpha = 0.0
                customView.textLabel.alpha = 0.0
                
                customView.transform = CGAffineTransformMakeScale(0.2, 0.2)
                
                //animation
                UIView.animateWithDuration(1, animations: {
                    customView.alpha = 1.0
                    customView.textLabel.alpha = 1.0
                    
                    customView.transform = CGAffineTransformMakeScale(1.0, 1.0)
                })
                
                self.view.addSubview(customView)
                self.customViewMaster = customView
                
            }
            //change collor
            if(element.identifier == CustomElementType.IntCollor.rawValue){
                let number = element.value as? Int
                self.customViewMaster.backgroundColor = FixedColors.getColorBy(number!)
            }
            
            
            //TODO: Receber Data ao inves de String
            
            if (element.identifier == CustomElementType.DataMessage.rawValue){
                print("Recebeu mensagem do tipo Data")
                
                print(element.value)
            }
        }

  
        
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
