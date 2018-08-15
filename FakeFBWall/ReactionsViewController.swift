//
//  ReactionsViewController.swift
//  FakeFBWall
//
//  Created by Vamshi Krishna on 23/07/18.
//  Copyright © 2018 Vamshi Krishna. All rights reserved.
//

import UIKit

class ReactionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var dataSourceNames = [String]()
    var selectedData = [String]()
    var dummyArray = [Reaction]()
    var dummyArrayCell = [Reaction]()
    var dummyDictionary  = [String : Reaction]()
    var isFromCTV : Bool = false
    

    @IBOutlet weak var reactionsTableView: UITableView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if isFromCTV{
            dummyArrayCell = reactionaArrayByCommenter
            reactionaArrayByCommenter = []
        } else{
            dummyArray = reactionaArrayByUser
            reactionaArrayByUser = []
        }
        
        dummyDictionary["like"] = Reaction.facebook.like
        dummyDictionary["love"] = Reaction.facebook.love
        dummyDictionary["haha"] = Reaction.facebook.haha
        dummyDictionary["wow"] = Reaction.facebook.wow
        dummyDictionary["sad"] = Reaction.facebook.sad
        dummyDictionary["angry"] = Reaction.facebook.angry
        
        reactionsTableView.dataSource = self
        reactionsTableView.delegate = self
        dataSourceNames = ["like", "love", "haha", "wow", "sad", "angry"]
        reactionsTableView.isScrollEnabled = false
    
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceNames.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reactionsTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        let label = cell.viewWithTag(101) as! UILabel
        label.text = dataSourceNames[indexPath.row]
        
        let imageView = cell.viewWithTag(102) as! UIImageView
        imageView.image = UIImage(named:dataSourceNames[indexPath.row])
        
        if selectedData.contains(dataSourceNames[indexPath.row]) {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedData.contains(dataSourceNames[indexPath.row]) {
           
            if let existingIndex = selectedData.index(of: dataSourceNames[indexPath.row]){
                 selectedData.remove(at: existingIndex)
            }
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else {
            selectedData.append(dataSourceNames[indexPath.row])
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        print(selectedData)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        if isFromCTV{
            reactionaArrayByCommenter = dummyArrayCell
        } else{
            reactionaArrayByUser = dummyArray
        }
       
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        if !isFromCTV{
            if selectedData.count == 0{
                reactionaArrayByUser = Reaction.facebook.all
            } else{
                for item in selectedData{
                    reactionaArrayByUser.append(dummyDictionary[item]!)
                }
            }
        } else{
            for item in selectedData{
                reactionaArrayByCommenter.append(dummyDictionary[item]!)
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
}
