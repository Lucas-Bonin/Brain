//
//  BoardCollectionViewController.swift
//  Brain TV
//
//  Created by Lucas Bonin on 6/17/16.
//  Copyright © 2016 Lucas Bonin. All rights reserved.
//

import UIKit

class BoardCollectionViewController: UICollectionViewController {
    //TODO: Fazer o load das boards salvas
    
    private let firstCell = 0
    
    //MARK: DataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // Mudar se tiver mais de um tipo de board
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Numero de boards salvas
        return 6
    }
    
    // Conteudo da view
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(DataItemCollectionViewCell.reuseIdentifier, forIndexPath: indexPath) as! DataItemCollectionViewCell
        
        if indexPath.row == firstCell{
            cell.imageBoard.image = UIImage(named:"deleteButton")
            return cell
        }
        
        cell.imageBoard.image = UIImage(named: "cursor")
        
        cell.textBoard.text = "Imagem \(indexPath.row)"
        
        return cell
    }
    
    // Titulo do header
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: DataItemHeaderView.reuseHeaderIdentifier, forIndexPath: indexPath) as! DataItemHeaderView
        
        headerView.headerText.text = "Primeira section"
        
        return headerView
    }
    
    //MARK: Delegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == firstCell{
            print("Abrir tela de selecao")
            performSegueWithIdentifier("showEditBoardViewController", sender: self)
        }else{
            print("Abrir Board Salva")
        }
    }
    
    //MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("passar parametros para board")
    }
    
}
