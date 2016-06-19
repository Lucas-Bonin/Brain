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
    
    @IBOutlet weak var boardBackground: UIImageView!
    
    let unwindSegueIdentifier = "unwindToMenuBoardViewController"
    
    var selectedView: UIView?
    var highlightedView: PostItView?
    
    var customViewMaster = UIView()
    
    var dellButton = false

    //cursor
    var cursorView = UIImageView()
    
    //MARK: Propriedades para customizar board
    var backgroundImage = UIImage()
    var boardTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralInit()
        
        cursorInit()
        
        self.boardBackground.image = backgroundImage
        
        // Esconde a navigation bar
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.title = boardTitle
        
        // Mudar comportamento padrao do botao MENU
        let tapRecognizer = UITapGestureRecognizer(target: self, action:#selector(BoardViewController.tapGestureMenu(_:)))
        tapRecognizer.allowedPressTypes = [NSNumber(integer: UIPressType.Menu.rawValue)]
        self.view.addGestureRecognizer(tapRecognizer)

    }
    
    private func cursorInit(){
        cursorView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 64.0, height: 64.0))
        cursorView.center = CGPointMake(CGRectGetMidX(UIScreen.mainScreen().bounds), CGRectGetMidY(UIScreen.mainScreen().bounds))
        cursorView.image =  UIImage(named: "cursor")
//        cursorView.backgroundColor = UIColor.redColor()
        cursorView.hidden = false
        view.addSubview(cursorView)
        
        // Cria recognizer para o cursor
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(BoardViewController.panGesture(_:)))
        let tapRecognizer = UITapGestureRecognizer(target: self, action:#selector(BoardViewController.tapGesture(_:)))
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action:#selector (BoardViewController.longPressGesture(_:)))
        
        self.view.addGestureRecognizer(longPressRecognizer)
        self.view.addGestureRecognizer(tapRecognizer)
        self.view.addGestureRecognizer(recognizer)
    }
    
    
    //MARK: Controle do cursor
    
    func panGesture(recognizer: UIPanGestureRecognizer){
        
        let translation = recognizer.translationInView(cursorView)
        
        // Mover view que estiver selecionada
        if let sView = selectedView{
            self.view.bringSubviewToFront(sView)
            
            sView.center = CGPoint(x:sView.center.x + translation.x, y:sView.center.y + translation.y)
        }else{
            
            // Destaca view que o cursor esta passando por cima
            if let tappedView = self.view.overlapHitTest(cursorView.frame.origin, withEvent: nil) as? PostItView{
                if tappedView != highlightedView{
                    highlightedView?.hideView()
                    tappedView.highlightView()
                    highlightedView = tappedView
                }
            }else{
                if(self.dellButton == false){
                    highlightedView?.hideView()
                    highlightedView = nil
                }
            }
        }
        
        self.view.bringSubviewToFront(cursorView)
        
        cursorView.center = CGPoint(x:cursorView.center.x + translation.x, y:cursorView.center.y + translation.y)
        
        recognizer.setTranslation(CGPointZero, inView: cursorView)
    }
    
    func tapGestureMenu(recognizer: UITapGestureRecognizer){
        //TODO: Dar um aviso ao usuario antes de ir para a tela inicial
        self.performSegueWithIdentifier(unwindSegueIdentifier, sender: self)
    }
    
    func tapGesture(recognizer: UITapGestureRecognizer){
        
        print(recognizer.allowedPressTypes)
        
        
        // Se houver um click e uma view ja estiver selecionada
        if selectedView != nil{
            //TODO: Fazer alguma animacao na view quando desselecionada
            selectedView = nil
            return
        }
        
        // Verifica se existe alguma view no ponto clicado
        guard let tappedView = self.view.overlapHitTest(cursorView.frame.origin, withEvent: nil) else {return}
        
        if tappedView == self.view{
            // Tira o foco da view em destaque
            highlightedView?.hideView()
            highlightedView = nil
            self.dellButton = false
            return
        }
        
        if let postItView = tappedView as? PostItView{
            selectedView = postItView
            return
        }
        
        if let delButton = tappedView as? DeleteButtonView{
            delButton.destroyView()
            self.dellButton = false
        }
    }
    
    func longPressGesture(recognizer: UILongPressGestureRecognizer){
        print("Reconheceu um long press")
        if let tappedView = self.view.overlapHitTest(cursorView.frame.origin, withEvent: nil) as? PostItView{
            tappedView.shakeView()
            self.dellButton = true
            
        }

    }
    
    
}


// Funcoes para VirtualGameController
extension BoardViewController{
    private func centralInit(){
        
        // Inicializa Central
        VgcManager.startAs(.Central, appIdentifier: "bRainLucas", customElements: CustomElements(), customMappings: CustomMappings(), includesPeerToPeer: true)
        
        // Notificacoes quando um controle conectar ou desconectar
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector (BoardViewController.controllerDidConnect(_:)), name: VgcControllerDidConnectNotification, object: nil)
        
        //Handler para customControl
        Elements.customElements.valueChangedHandler = { [unowned self](controller, element) in
            
            if (element.identifier == CustomElementType.TextMessage.rawValue) {
                print("recebeu mensagem de texto:\n");
                let text = element.value as? String
                print(text!)
                
                let x = (CGFloat)(arc4random_uniform(400))
                let y = (CGFloat)(arc4random_uniform(550))
                
                let customView = PostItView(frame: CGRect(x: x , y: y, width: self.view.layer.frame.height/6, height: self.view.layer.frame.height/6))
                
                customView.backgroundColor = FixedColors.getColorBy(10)
                
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
                if(number == 5){
                    self.customViewMaster.layer.shadowOpacity = 0
                }
            }
            
            
            
            if (element.identifier == CustomElementType.DataMessage.rawValue){
                print("Recebeu mensagem do tipo Data")
                
                print(element.value)
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

// Funcao para reconhecer subviews quando clicar na tela
extension UIView {
    func overlapHitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        
        if !self.userInteractionEnabled || self.hidden || self.alpha == 0 {
            return nil
        }
        
        var hitView: UIView? = self
        if !self.pointInside(point, withEvent: event) {
            if self.clipsToBounds {
                return nil
            } else {
                hitView = nil
            }
        }
        
        for subview in self.subviews.reverse() {
            let insideSubview = self.convertPoint(point, toView: subview)
            if let sview = subview.overlapHitTest(insideSubview, withEvent: event) {
                return sview
            }
        }
        return hitView
    }
}

