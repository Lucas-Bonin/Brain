//
//  PostItView.swift
//  Brain TV
//
//  Created by Lucas Bonin on 6/14/16.
//  Copyright © 2016 Lucas Bonin. All rights reserved.
//

import UIKit

enum AnimationState{
    case Idle
    case Shaking
    case Highlighting
}

class PostItView: UIView {
    var textLabel: UILabel
    private var deleteButton: DeleteButtonView
    
    var viewState: AnimationState = .Idle
    
    override init(frame: CGRect) {
        
        // config label
        textLabel = UILabel(frame: CGRectMake(0,0, frame.height,frame.height))
        textLabel.textAlignment = .Center
        textLabel.font = textLabel.font.fontWithSize(20)
        textLabel.numberOfLines = 5
        textLabel.font = UIFont(name: "SFUIText-Bold", size: 22)
        print("Familia Fonte: \(textLabel.font.familyName), Nome Fonte: \(textLabel.font.fontName)")
        
        // Adiciona botao para excluir view
        deleteButton = DeleteButtonView(frame: CGRectMake(0,0, (frame.height/4), (frame.height/4)))
        deleteButton.hidden = true
        deleteButton.center = CGPoint(x: 0,y: 0)
        deleteButton.backgroundColor = UIColor.blueColor()
        
        super.init(frame: frame)
        
        deleteButton.delegate = self

        
        self.addSubview(deleteButton)
        self.addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Animacoes na view
    func highlightView(){
        
        viewState = .Highlighting
        
        self.superview?.bringSubviewToFront(self)
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.transform = CGAffineTransformMakeScale(1.2, 1.2)
        })
    }
    
    func hideView(){
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.transform = CGAffineTransformMakeScale(1.0, 1.0)
        })
        
        deleteButton.hidden = true
        
        viewState = .Idle
    }
    
    func shakeView(){
        if viewState != .Highlighting{
            //print("Animacao cancelada, estado da view = \(viewState)")
            return
        }
        deleteButton.hidden = false
        viewState = .Shaking
        
    }
    
    func stopShake(){
        print("Para de mexer view")
    }
    
}

// Extension para delegates
extension PostItView: DeleteButtonDelegate{
    func deleteView() {
        print("Deleta view")
        self.removeFromSuperview()
    }
}
