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
    @IBOutlet weak var boardTitleLabel: UILabel!
    
    @IBOutlet weak var boardBackground: UIImageView!
    
    let unwindSegueIdentifier = "unwindToMenuBoardViewController"
    
    var selectedView: UIView?
    var highlightedView: PostItView?
    
    var customViewMaster: PostItDataItem?
    
    var dellButton = false

    //cursor
    var cursorView = UIImageView()
    
    //MARK: Propriedades para customizar board
    var customBoard = BoardDataItem(boardName: "", bkgImage: UIImage(), postIt: [PostItDataItem]())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralInit()
        
        cursorInit()
        
        customBoardInit()
        
        // Mudar comportamento padrao do botao MENU
        let tapRecognizer = UITapGestureRecognizer(target: self, action:#selector(BoardViewController.tapGestureMenu(_:)))
        tapRecognizer.allowedPressTypes = [NSNumber(integer: UIPressType.Menu.rawValue)]
        self.view.addGestureRecognizer(tapRecognizer)

    }
    
    private func customBoardInit(){
        
        self.boardBackground.image = customBoard.backgroundImage
        self.boardTitleLabel.text = customBoard.boardName
        
        guard let postItItems = customBoard.postIt else {return}
    
        for index in 0..<postItItems.count{
            createPostIt(postItItems[index])
        }
    }
    
    private func createPostIt(postIt: PostItDataItem){
        
        let size = CGSizeMake(self.view.layer.frame.height/6, self.view.layer.frame.height/6)
        
        let customView = PostItView(frame: CGRect(origin: postIt.originPosition, size: size))
        
        customView.backgroundColor = FixedColors.getColorBy(postIt.color)
        if(postIt.color == 5){
            customView.layer.shadowOpacity = 0
        }
        
        customView.textLabel.text = postIt.text
        customView.colorNumber = postIt.color
        
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
        
    }

    private func cursorInit(){
        cursorView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 64.0, height: 64.0))
        cursorView.center = CGPointMake(CGRectGetMidX(UIScreen.mainScreen().bounds), CGRectGetMidY(UIScreen.mainScreen().bounds))
        cursorView.image =  UIImage(named: "pin")
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
            
            // Define ponta do cursor
            
            let point = CGPointMake(cursorView.frame.minX, cursorView.frame.maxY)
            if let tappedView = self.view.overlapHitTest(point, withEvent: nil) as? PostItView{
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
        let point = CGPointMake(cursorView.frame.minX, cursorView.frame.maxY)
        guard let tappedView = self.view.overlapHitTest(point, withEvent: nil) else {return}
        
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
    
    //MARK: Screenshot
    func screenShotMethod() -> UIImage {
        
        // Esconde o cursor
        self.cursorView.alpha = 0

        
        // Tira uma screenshot da tela
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Necessario diminuir o tamanho da imagem
        let newWidth: CGFloat = 500
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.cursorView.alpha = 1

        
        return newImage
        
    }
    
    //MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        screenShotMethod()
        
        var newPostItItems = [PostItDataItem]()
        
        // Separa todas as subviews que sao PostItView
        let newSubviews = self.view.subviews.filter{$0 is PostItView} as! [PostItView]
        
        // Cria um novo vetor com todas as postIt que estao na tela
        for index in 0..<newSubviews.count{
            let postItData = PostItDataItem(color: newSubviews[index].colorNumber, text: newSubviews[index].textLabel.text!, position: newSubviews[index].frame.origin)
            newPostItItems.append(postItData)
        }
        self.customBoard.postIt = newPostItItems
        
        //Adiciona uma imagem preview para saber o estado da Board antes de abri-la
        let image = screenShotMethod()
        self.customBoard.previewImage = image
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
                
                let point = CGPointMake(x, y)
                
                // Cria um objeto com as informacoes do novo postIt
                let customView = PostItDataItem(color: 2, text: text!, position: point)
                self.customViewMaster = customView
                
            }
            
            //change color
            if(element.identifier == CustomElementType.IntCollor.rawValue){
                let number = element.value as? Int
                
                guard let customView = self.customViewMaster else {return}
                customView.color = number
                
                //Somente quando tiver a cor e o texto, cria o postIt
                self.createPostIt(customView)

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

