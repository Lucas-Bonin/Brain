//
//  BoardMenuViewController.swift
//  Brain TV
//
//  Created by Lucas Bonin on 6/17/16.
//  Copyright © 2016 Lucas Bonin. All rights reserved.
//

import UIKit

class BoardMenuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    //TODO: Fazer o load das boards salvas
    
    let segueBoardIdentifier = "showBoardViewController"
    let segueEditBoardIdentifier = "showEditBoardViewController"
    
    private let firstCell = 0
    private var boardsSaved = [BoardDataItem]()
    
    @IBOutlet weak var imagePreview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load das boards salvas
        if let boards = BoardManager.sharedInstance.loadBoard(){
            boardsSaved = boards
        }
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
            cell.imageBoard.image = UIImage(named: "deleteButton")
            cell.textBoard.text = "New Board"
            return cell
        }
        
        
        cell.imageBoard.image = boardsSaved[indexPath.row - 1].backgroundImage
        
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
            print("Abrir tela de selecao")
            performSegueWithIdentifier(segueEditBoardIdentifier, sender: self)
        }else{
            
            //performSegueWithIdentifier(segueBoardIdentifier, sender: self)
            
            print("Abrir Board Salva")
        }
    }
    
    func collectionView(collectionView: UICollectionView, didUpdateFocusInContext context: UICollectionViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        
        guard let index = context.nextFocusedIndexPath?.row else {return}
        
        if(index == firstCell){
            imagePreview.image = UIImage(named: "deleteButton")
            return
        }
        
        imagePreview.image = boardsSaved[index - 1].backgroundImage
    }

    //MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("passar parametros para board")
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        
    }
    
    

}
