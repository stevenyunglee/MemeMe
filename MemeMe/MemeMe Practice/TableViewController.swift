//
//  TableViewController.swift
//  MemeMe Practice
//
//  Created by Lee, Steve on 4/8/18.
//  Copyright © 2018 Steve Lee. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {

    var memes: [Meme]!

    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        load()
        tableView.reloadData()
    }
    
    func load() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.rowHeight = 100.0
        return self.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
        let meme = self.memes[indexPath.row]
        // Set the name and image
        cell.textLabel?.text = "\(meme.topText)" + " " + "\(meme.bottomText)"
        cell.imageView?.image = meme.memedImage
        cell.imageView?.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let createdMemeViewController = storyboard?.instantiateViewController(withIdentifier: "CreatedMemeViewController") as! CreatedMemeViewController
        let meme = self.memes[indexPath.row]
        createdMemeViewController.memedImage = meme.memedImage
        navigationController?.pushViewController(createdMemeViewController, animated: true)

    }
    
}
