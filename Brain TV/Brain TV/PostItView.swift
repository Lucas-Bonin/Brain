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
    var colorNumber: Int = 0
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
        
        super.init(frame: frame)
        
        //config shadow
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOffset = CGSize(width: 4.0, height: 4.0);
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOpacity = 0.5;
        
        
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

            self.layer.shadowOffset = CGSize(width: 10.0, height: 10.0);
        })
    }
    
    func hideView(){
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.transform = CGAffineTransformMakeScale(1.0, 1.0)
            
            self.layer.shadowOffset = CGSize(width: 4.0, height: 4.0);
        })
        
        deleteButton.hidden = true
        self.layer.removeAnimationForKey("shaking")

        
        viewState = .Idle
    }
    
    func shakeView(){
        if viewState != .Highlighting{
            //print("Animacao cancelada, estado da view = \(viewState)")
            self.shakeIcons((self.layer))
            return
        }
        deleteButton.hidden = false
        viewState = .Shaking
        
    }
    
    func shakeIcons(layer: CALayer) {
        let shakeAnim = CABasicAnimation(keyPath: "transform.rotation")
        shakeAnim.duration = 0.05
        shakeAnim.repeatCount = 2
        shakeAnim.autoreverses = true
        let startAngle: Float = (-2) * 3.14159/180
        let stopAngle = -startAngle
        shakeAnim.fromValue = NSNumber(float: startAngle)
        shakeAnim.toValue = NSNumber(float: 3 * stopAngle)
        shakeAnim.autoreverses = true
        shakeAnim.duration = 0.2
        shakeAnim.repeatCount = 10000
        shakeAnim.timeOffset = 290 * drand48()
        
        layer.addAnimation(shakeAnim, forKey:"shaking")
    }
    
    
    func stopShake(){
        self.layer.removeAnimationForKey("shaking")

    }
    
}

// Extension para delegates
extension PostItView: DeleteButtonDelegate{
    
    func deleteView() {
        print("Deleta view")
        //animation
        UIView.animateWithDuration(1, animations: {
            self.alpha = 0.1
            self.transform = CGAffineTransformMakeScale(0.1, 0.1)

        }) { _ in
            self.removeFromSuperview()
        }

    }
}
