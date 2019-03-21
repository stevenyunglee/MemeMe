//
//  CollectionViewController.swift
//  MemeMe Practice
//
//  Created by Lee, Steve on 4/9/18.
//  Copyright © 2018 Steve Lee. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewcontroller: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        load()
        collectionView?.reloadData()
    }
    
    func load() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCell", for: indexPath) as! CollectionViewCell
        let meme = self.memes[indexPath.row]
        cell.collectionImageView.image = meme.memedImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let createdMemeViewController = storyboard?.instantiateViewController(withIdentifier: "CreatedMemeViewController") as! CreatedMemeViewController
        let meme = self.memes[indexPath.row]
        createdMemeViewController.memedImage = meme.memedImage
        navigationController?.pushViewController(createdMemeViewController, animated: true)
    }
    
    
}
