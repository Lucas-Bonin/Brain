//
//  DataItemCollectionViewCell.swift
//  Brain TV
//
//  Created by Lucas Bonin on 6/17/16.
//  Copyright © 2016 Lucas Bonin. All rights reserved.
//

import UIKit

class DataItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageBoard: UIImageView!
    
    @IBOutlet weak var textBoard: UILabel!
    
    static let reuseIdentifier = "BoardCollectionCell"
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        
        // Animacao quando celular for focada
        if(self == context.nextFocusedView){
            coordinator.addCoordinatedAnimations({

                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.transform = CGAffineTransformMakeScale(1.2, 1.2)
                    
                    self.layer.shadowColor = UIColor.blackColor().CGColor
                    self.layer.shadowOffset = CGSize(width: 10.0, height: 10.0);
                    self.layer.shadowRadius = 5.0;
                    self.layer.shadowOpacity = 0.5;
                })
                
            }, completion: nil)
         
        // Animacao quando celula deixar de ser focada
        }else if (self == context.previouslyFocusedView){
            coordinator.addCoordinatedAnimations({
        
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.transform = CGAffineTransformMakeScale(1.0, 1.0)
                    self.layer.shadowColor = UIColor.blackColor().CGColor
                    self.layer.shadowOffset = CGSize(width: 4.0, height: 4.0);
                    self.layer.shadowRadius = 5.0;
                    self.layer.shadowOpacity = 0.5;
                })
                
            }, completion: nil)
        }
    }

}
