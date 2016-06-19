//
//  MasterEditBoardViewController.swift
//  Brain TV
//
//  Created by Lucas Bonin on 6/18/16.
//  Copyright © 2016 Lucas Bonin. All rights reserved.
//

import UIKit

// Protocolo para mudar imagem da DetailView quando escolher outro background
protocol BoardSelectionDelegate: class{
    func boardSelected(newBoard: BackgroundDataItem)
}

class MasterEditBoardViewController: UIViewController {
    
    weak var boardDelegate: BoardSelectionDelegate?
    
    let detailBoardIdentifier = "showDetailEditBoardVewController"
    
    // Recebendo os backgrounds
    private let backgrounds = BackgroundDataItem.images
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK: Delegates e DataSource
extension MasterEditBoardViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return backgrounds.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(MasterEditBoardTableViewCell.reuseHeaderIdentifier) as! MasterEditBoardTableViewCell
        
        cell.boardLabel.text = backgrounds[indexPath.row].title
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Encontra splitView
        guard let editSplitView = splitViewController as? EditSplitViewController else {
            print("Nao achou splitView")
            return
        }
        
        // Muda o foco
        editSplitView.updateFocusToDetailViewController()
        
        //performSegueWithIdentifier(detailBoardIdentifier, sender: self)
    }
    
    func tableView(tableView: UITableView, didUpdateFocusInContext context: UITableViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        // Verifica se a view a ser focada pertence a tableView
        guard let nextFocusedView = context.nextFocusedView where nextFocusedView.isDescendantOfView(tableView) else {
            print("foco de outra view selecionada")
            return
        }
        guard let indexPath = context.nextFocusedIndexPath else { return }
        
        // Atualiza imagem na outra tela
        boardDelegate?.boardSelected(backgrounds[indexPath.row])
    }
    
    
}
