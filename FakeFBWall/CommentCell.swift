//
//  CommentCell.swift
//  FakeFBWall
//
//  Created by Vamshi Krishna on 05/08/18.
//  Copyright © 2018 Vamshi Krishna. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    var indexPathCommentCell : IndexPath?
    @IBOutlet weak var widthConOfRS: NSLayoutConstraint!
    @IBOutlet weak var userImageButton: UIButton!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var reactButton: UIButton!
    @IBOutlet weak var reactSummaryView: ReactionSummary!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var commentTextView: UITextView!
    
    override func layoutSubviews() {
        userImage.layer.cornerRadius = userImage.frame.size.height/2
        userImage.layer.masksToBounds = true
        userImage.contentMode = .scaleAspectFill
        
        reactSummaryView.layer.cornerRadius = reactSummaryView.frame.size.height/2
        reactSummaryView.layer.masksToBounds = true
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        commentTextView.layer.cornerRadius = 12
        commentTextView.layer.masksToBounds = true
        commentTextView.textContainerInset = UIEdgeInsets(top: 0, left: 8, bottom: 12, right: 8)
        commentTextView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        nameTF.layer.cornerRadius = 12
        nameTF.layer.masksToBounds = true
        nameTF.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        nameTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: nameTF.frame.height))
        nameTF.leftViewMode = .always
   
    }
}

struct CommentModel{
    var userName : String
    var userComment : String
    var reactsArray : [Reaction]
    var userImage : UIImage
    
    init(userName:String, userComment:String, reactsArray:[Reaction], userImage:UIImage){
        self.userName = userName
        self.userComment = userComment
        self.reactsArray = reactsArray
        self.userImage = userImage
    }
}
