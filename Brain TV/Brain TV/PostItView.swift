//
//  PostItView.swift
//  Brain TV
//
//  Created by Lucas Bonin on 6/14/16.
//  Copyright © 2016 Lucas Bonin. All rights reserved.
//

import UIKit

class PostItView: UIView {
    var textLabel: UILabel
    
    var isMovable = false
    
//    var delegate:DragDelegate!
    
    override init(frame: CGRect) {
        
        
        
        textLabel = UILabel(frame: CGRectMake(0,0,500,500))
        textLabel.textAlignment = .Center
        textLabel.font = textLabel.font.fontWithSize(70)
        
        super.init(frame: frame)
        
        self.addSubview(textLabel)
        
        //funcoes para reconhecimento de gestos
       // let recognizer = UIPanGestureRecognizer(target: self, action: #selector(PostItView.handleGesture(_:)))
      //  let tapRecognizer = UITapGestureRecognizer(target: self, action:#selector(PostItView.tapGesture(_:)))
        
        //recognizer.delegate = self
        self.userInteractionEnabled = true
      //  self.addGestureRecognizer(tapRecognizer)
     //   self.addGestureRecognizer(recognizer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func canBecomeFocused() -> Bool {
        //   print("PODE SER FOCADO ?")
        return false
    }
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        
        if context.previouslyFocusedView === self
        {
            
            
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                context.previouslyFocusedView?.transform = CGAffineTransformMakeScale(1.0, 1.0)
            })
        }
        
        if context.nextFocusedView === self
        {
            
            //quando a view for focada, passar ele para frente
            self.superview?.bringSubviewToFront(self)
            
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                context.nextFocusedView?.transform = CGAffineTransformMakeScale(1.2, 1.2)
            })
        }
        
    }
    
    func handleGesture(recognizer: UIPanGestureRecognizer){
        // print("Gesto")
        
        if(!isMovable){
            return
        }
        
        let translation = recognizer.translationInView(self.superview!)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPointZero, inView: self)
    }
    
    func tapGesture(recognizer: UITapGestureRecognizer){
        if self.focused {
            self.isMovable = !self.isMovable
            
        }
        
//        if let dragDelegate = delegate {
//            dragDelegate.isDragging(isMovable)
//        }
        print("tocou na tela")
    }
}
