//
//  DetailEditBoardViewController.swift
//  Brain TV
//
//  Created by Lucas Bonin on 6/18/16.
//  Copyright © 2016 Lucas Bonin. All rights reserved.
//

import UIKit

class DetailEditBoardViewController: UIViewController {
    

    @IBOutlet weak var boardImage: UIImageView!

    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var inputBoardName: UITextField!
    
    let boardSegueIdentifier = "showBoardViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMasterDelegate()
        
        // Texto default a board
        inputBoardName.text = "Board"
        
        // View de foco
        viewToFocus = inputBoardName
        
    }
    
    
    // Mudar view de foco
    var viewToFocus: UIView? = nil {
        didSet {
            if viewToFocus != nil {
                self.setNeedsFocusUpdate();
                self.updateFocusIfNeeded();
            }
        }
    }
    
    override weak var preferredFocusedView: UIView? {
        if viewToFocus != nil {
            return viewToFocus;
        } else {
            return super.preferredFocusedView;
        }
    }
    
    
    private func setMasterDelegate(){
    
        // Encontrar master view
        guard let splitView = splitViewController else{
            print("Nao achou nenhum view controller")
            return
        }
        guard let navigation = splitView.viewControllers.first as? UINavigationController else{
            print("nao achou a view controller correta")
            return
        }
        guard let masterView = navigation.viewControllers.first as? MasterEditBoardViewController else {
            print("Nao achou a view controller no navigation")
            return
        }
        
        masterView.boardDelegate = self
    }
    
    //MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == boardSegueIdentifier{
            if let viewController = segue.destinationViewController as? BoardViewController{
                if let image = boardImage.image, text = inputBoardName.text{
                    viewController.backgroundImage = image
                    viewController.boardTitle = text
                }
            }
        }
    }
    
}

extension DetailEditBoardViewController: BoardSelectionDelegate{
    
    // Atualiza imagem
    func boardSelected(newBoard: BackgroundDataItem) {
        boardImage.image = newBoard.image
    }
}
