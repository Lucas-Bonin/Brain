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
    
    private let firstCell = 0
    
    @IBOutlet weak var imagePreview: UIImageView!
    
    //MARK: DataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // Mudar se tiver mais de um tipo de board
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Numero de boards salvas
        return 6
    }
    
    // Conteudo da view
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(DataItemCollectionViewCell.reuseIdentifier, forIndexPath: indexPath) as! DataItemCollectionViewCell
        
        if indexPath.row == firstCell{
            cell.imageBoard.image = UIImage(named:"deleteButton")
            cell.textBoard.text = "New Board"
            return cell
        }
        
        
        cell.imageBoard.image = UIImage(named: "small")
        
        cell.textBoard.text = "Imagem \(indexPath.row)"
        
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
            performSegueWithIdentifier("showEditBoardViewController", sender: self)
        }else{
            
            performSegueWithIdentifier(BoardViewController.segueIdentifier, sender: self)
            
            print("Abrir Board Salva")
        }
    }
    
    func collectionView(collectionView: UICollectionView, didUpdateFocusInContext context: UICollectionViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        
        guard let index = context.nextFocusedIndexPath?.row else {return}
        
        let image = index % 2 == 0 ? UIImage(named: "small") : UIImage(named: "deleteButton")

        imagePreview.image = image
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        print("Passou imagem \(indexPath.row)")
    }
    
    
    //MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("passar parametros para board")
    }

}
