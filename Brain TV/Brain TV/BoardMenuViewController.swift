//
//  BoardMenuViewController.swift
//  Brain TV
//
//  Created by Lucas Bonin on 6/17/16.
//  Copyright © 2016 Lucas Bonin. All rights reserved.
//

import UIKit
import GameController
import VirtualGameController

class BoardMenuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {
    //TODO: Fazer o load das boards salvas
    
    let segueBoardIdentifier = "MenuToBoardViewController"
    let segueEditBoardIdentifier = "showEditBoardViewController"
    
    private let firstCell = 0
    private var boardsSaved = [BoardDataItem]()
    private var focusedCollectionViewCell: DataItemCollectionViewCell?
    
    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var imagePreview: UIImageView!
    
    override func didReceiveMemoryWarning() {
        print("\n\n\nRecebeu memory warning\n\n\n")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Inicializa Central
        VgcManager.startAs(.Central, appIdentifier: "bRainLucas", customElements: CustomElements(), customMappings: CustomMappings(), includesPeerToPeer: true)
        
        // Load das boards salvas
        if let boards = BoardManager.sharedInstance.loadBoard(){
            boardsSaved = boards
        }
        
        // Adiciona um gesture recognizer na collection view
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(BoardMenuViewController.handleLongPress(_:)))
        lpgr.delegate = self
        self.menuCollectionView.addGestureRecognizer(lpgr)
    }
    
    
    //MARK: DataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // Mudar se tiver mais de um tipo de board
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Boards salvas + view para criacao de uma nova board
        return boardsSaved.count + 1
    }
    
    // Conteudo da view
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(DataItemCollectionViewCell.reuseIdentifier, forIndexPath: indexPath) as! DataItemCollectionViewCell
        
        if indexPath.row == firstCell{
            cell.imageBoard.image = UIImage(named: "plus")
            cell.textBoard.text = "New Board"
            return cell
        }
        
        
        cell.imageBoard.image = boardsSaved[indexPath.row - 1].previewImage
        
        cell.textBoard.text = boardsSaved[indexPath.row - 1].boardName
        
        return cell
    }
    
    // Titulo do header
//    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: DataItemHeaderView.reuseHeaderIdentifier, forIndexPath: indexPath) as! DataItemHeaderView
//        
//        headerView.headerText.text = "Primeira section"
//        
//        return headerView
//    }
    
    //MARK: Delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == firstCell{
            
            performSegueWithIdentifier(segueEditBoardIdentifier, sender: self)
        }else{
            
            // Passando a celula atual como sender
            performSegueWithIdentifier(segueBoardIdentifier, sender: self.menuCollectionView.cellForItemAtIndexPath(indexPath))
        }
    }
    
    func collectionView(collectionView: UICollectionView, didUpdateFocusInContext context: UICollectionViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        
        guard let indexPath = context.nextFocusedIndexPath else {return}
        
        self.focusedCollectionViewCell = self.menuCollectionView.cellForItemAtIndexPath(indexPath) as? DataItemCollectionViewCell
        
        if(indexPath.row == firstCell){
            imagePreview.image = UIImage(named:"Brainstorm")
            return
        }
        
        imagePreview.image = boardsSaved[indexPath.row - 1].backgroundImage
    }

    //MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueBoardIdentifier{
            
            guard let viewController = segue.destinationViewController as? BoardViewController else{return}
            guard let cell = sender as? UICollectionViewCell else{return}
            guard let index = self.menuCollectionView.indexPathForCell(cell) else {return}
            
            viewController.customBoard = boardsSaved[index.row - 1]
        }
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        
        
        // Salva board quando voltar para a tela principal
        guard let viewController = segue.sourceViewController as? BoardViewController else {return}
        let newBoard = viewController.customBoard
        
        for index in 0..<boardsSaved.count{
            if boardsSaved[index] == newBoard{
                boardsSaved.removeAtIndex(index)
                break
            }
        }
        
        boardsSaved.insert(newBoard, atIndex: 0)
        
        
        BoardManager.sharedInstance.saveBoard(boardsSaved)
        
        
        let reloadCollection = NSBlockOperation {
            self.menuCollectionView.reloadData()
            // Resolve problema de nao aparecer o ultimo elemento
            self.menuCollectionView.reloadItemsAtIndexPaths(self.menuCollectionView.indexPathsForVisibleItems())
        }
        
        NSOperationQueue.mainQueue().addOperation(reloadCollection)
    
    }
    
    //MARK: Gestures
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        print("long press")
        guard let cell = self.focusedCollectionViewCell else {return}
        guard let indexPath = self.menuCollectionView.indexPathForCell(cell) else {return}
        
        if indexPath.row == firstCell{
            return
        }
        
        // Mostra um Alert view
//        let title = ""
//        let message = ""
        let cancelButtonTitle = "Cancel"
        let deleteButtonTitle = "Delete"
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
        
        // Create the actions.
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .Cancel) { _ in
        }
        
        let deleteAction = UIAlertAction(title: deleteButtonTitle, style: .Destructive) { _ in
            
            // Deleta board
            self.boardsSaved.removeAtIndex(indexPath.row - 1)
            BoardManager.sharedInstance.saveBoard(self.boardsSaved)
            self.menuCollectionView.reloadData()
            
        }
        
        // Add the actions.
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
}
