//
//  DeleteButtonView.swift
//  Brain TV
//
//  Created by Lucas Bonin on 6/16/16.
//  Copyright © 2016 Lucas Bonin. All rights reserved.
//

import UIKit

// Protocolo para destruir view quando clicar no botao
protocol DeleteButtonDelegate: class{
    func deleteView()
}

class DeleteButtonView: UIImageView {
    
    // Weak para evitar "retain cycles"
    weak var delegate: DeleteButtonDelegate?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.image = UIImage(named: "deleteButton")
        self.userInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func destroyView(){
        delegate?.deleteView()
    }
}
