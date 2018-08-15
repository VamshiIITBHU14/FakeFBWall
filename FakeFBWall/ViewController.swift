//
//  ViewController.swift
//  FakeFBWall
//
//  Created by Vamshi Krishna on 18/07/18.
//  Copyright © 2018 Vamshi Krishna. All rights reserved.
//

import UIKit

var reactionaArrayByUser = [Reaction]()
var reactionaArrayByCommenter = [Reaction]()

class ViewController: UIViewController  ,UITextViewDelegate, UITableViewDelegate, UITableViewDataSource,  UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSLayoutManagerDelegate, UITextFieldDelegate{
    
    
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var statusTextView: UITextView!
    
    var activeIndexPath = IndexPath()
    @IBOutlet weak var reactionSummary: ReactionSummary!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var addCommentButton: UIButton!
    @IBOutlet weak var widthConstraintOfReactionSummary: NSLayoutConstraint!
    @IBOutlet weak var heightConstraintOfStatusTextView: NSLayoutConstraint!
    var commentsCount = 0
    var rowHeight = 60
    @IBOutlet weak var profileImageView: UIImageView!
    var commentsArray = [CommentModel]()
    var indexPathForReactSummary : IndexPath?
    var indexPathForUserImage : IndexPath?
    var isFromCTV : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
        imagePicker.delegate = self
        
        reactionaArrayByUser = [Reaction.facebook.like, Reaction.facebook.love, Reaction.facebook.wow]
        
        commentsTableView.estimatedRowHeight = 80
        commentsTableView.rowHeight = UITableViewAutomaticDimension
        
        
        statusTextView.translatesAutoresizingMaskIntoConstraints = false
        statusTextView.delegate = self
        statusTextView.isScrollEnabled = false
        
        statusTextView.text = "Type Your Status here"
        
        textViewDidChange(statusTextView)
        
        addCommentButton.layer.cornerRadius = 6
        addCommentButton.layer.masksToBounds = true
        saveButton.layer.masksToBounds = true
        saveButton.layer.cornerRadius = 6
        
        activeIndexPath = IndexPath(row: 0 , section: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reactionSummary.reactions = reactionaArrayByUser
        widthConstraintOfReactionSummary.constant = CGFloat(reactionSummary.reactions.count * 21)
        
        if indexPathForReactSummary != nil{
            var commentData = commentsArray[(indexPathForReactSummary?.row)!]
            commentData.reactsArray = reactionaArrayByCommenter
            commentsArray[(indexPathForReactSummary?.row)!] = commentData
            commentsTableView.reloadRows(at: [indexPathForReactSummary!], with: .fade)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2
        profileImageView.layer.masksToBounds = true
        
        if let headerView = commentsTableView.tableHeaderView {
            
            let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height + heightConstraintOfStatusTextView.constant - 50
            var headerFrame = headerView.frame
            
            if height != headerFrame.size.height {
                headerFrame.size.height = height
                headerView.frame = headerFrame
                commentsTableView.tableHeaderView = headerView
            }
        }
    }
    
    @IBAction func uploadProfileImage(_ sender: Any) {
        isFromCTV = false
        picUploadAlert()
    }
    
    func picUploadAlert(){
        let alertController = UIAlertController(title: "Hello!", message: "Choose an option to upload picture", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Gallery", style: .default) { (action:UIAlertAction) in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let action2 = UIAlertAction(title: "Camera", style: .default) { (action:UIAlertAction) in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let action3 = UIAlertAction(title: "Cancel", style: .destructive) { (action:UIAlertAction) in
        }
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if isFromCTV{
                if indexPathForUserImage != nil{
                    var commentData = commentsArray[(indexPathForUserImage?.row)!]
                    commentData.userImage = pickedImage
                    commentsArray[(indexPathForUserImage?.row)!] = commentData
                    commentsTableView.reloadRows(at: [indexPathForUserImage!], with: .fade)
                }
            } else{
                profileImageView.contentMode = .scaleAspectFill
                profileImageView.image = pickedImage
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reactionSummaryButtonTapped(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "SelectRVC") as! ReactionsViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    //MARK: -TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentsTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CommentCell
        cell.selectionStyle = .none
        
        cell.commentTextView.delegate = self
        cell.commentTextView.layoutManager.delegate = self
        cell.commentTextView.tag = indexPath.row + 600
        cell.commentTextView.text = commentsArray[indexPath.row].userComment
        
        cell.nameTF.tag = indexPath.row + 700
        cell.nameTF.text = commentsArray[indexPath.row].userName
        cell.nameTF.delegate = self
        cell.nameTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        if commentsArray[indexPath.row].reactsArray.count == 0{
            commentsArray[indexPath.row].reactsArray = [Reaction.facebook.like]
        }
        
        cell.reactSummaryView.reactions = commentsArray[indexPath.row].reactsArray
        cell.widthConOfRS.constant = CGFloat(commentsArray[indexPath.row].reactsArray.count * 21)
        
        cell.reactButton.tag = indexPath.row + 800
        cell.reactButton.addTarget(self, action: #selector(cellReactTapped), for: .touchUpInside)
        
        cell.userImage.image = commentsArray[indexPath.row].userImage
        cell.userImage.tag = indexPath.row + 200
        
        
        cell.userImageButton.addTarget(self, action: #selector(changeCommentPic), for: .touchUpInside)
        cell.userImageButton.tag = indexPath.row + 900
        
        return cell
    }
    
    @objc func cellReactTapped(_ sender : UIButton){
        let indexPath = IndexPath(row: sender.tag-800, section: 0)
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "SelectRVC") as! ReactionsViewController
        controller.isFromCTV = true
        indexPathForReactSummary = indexPath
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func changeCommentPic(_ sender : UIButton){
        isFromCTV = true
        picUploadAlert()
        let indexPath = IndexPath(row: sender.tag - 900, section: 0)
        indexPathForUserImage = indexPath
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    //MARK: -UITextField
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        activeIndexPath = IndexPath(row: textField.tag - 700, section: 0)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeIndexPath = IndexPath(row: textField.tag - 700, section: 0)
        textField.text = commentsArray[activeIndexPath.row].userName
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        commentsArray[activeIndexPath.row].userName = textField.text!
        commentsTableView.reloadRows(at: [activeIndexPath], with: .fade)
    }
    
    //MARK: -UITextView
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView == statusTextView{
            let size = CGSize(width: view.frame.width, height: .infinity)
            let estimatedSize = textView.sizeThatFits(size)
            heightConstraintOfStatusTextView.constant = estimatedSize.height
        } else{
            activeIndexPath = IndexPath(row: textView.tag - 600, section: 0)
            UIView.setAnimationsEnabled(false)
            commentsTableView.beginUpdates()
            commentsTableView.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView == statusTextView{
            
        } else{
            activeIndexPath = IndexPath(row: textView.tag - 600, section: 0)
            textView.text = commentsArray[activeIndexPath.row].userComment
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == statusTextView{
            
        } else{
            commentsArray[activeIndexPath.row].userComment = textView.text
            commentsTableView.reloadRows(at: [activeIndexPath], with: .fade)
        }
    }
    
    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return 3
    }
    
    //MARK: -UIButton Actions
    
    func generateImageForGallery(tableView:UITableView) ->UIImage{
        UIGraphicsBeginImageContext(tableView.contentSize)
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        tableView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let row = tableView.numberOfRows(inSection: 0)
        let numberofRowthatShowinscreen = 4
        let scrollCount = row / numberofRowthatShowinscreen
        
        for i in 0..<scrollCount{
            tableView.scrollToRow(at: IndexPath(row: (i) * (numberofRowthatShowinscreen), section: 0), at: .top, animated: false)
            tableView.layer.render(in: UIGraphicsGetCurrentContext()!)
        }
       
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return image;
    }
    
    @IBAction func saveTapped(_ sender: Any) {
          UIImageWriteToSavedPhotosAlbum(generateImageForGallery(tableView: commentsTableView), self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction func addCommentTapped(_ sender: Any) {
        
        commentsCount = commentsCount + 1
        let comment = CommentModel(userName: "UserName", userComment: "Enter the Comment Here", reactsArray: [Reaction.facebook.like], userImage: UIImage(named: "dummyUser")!)
        commentsArray.append(comment)
        let indexPath = IndexPath(row: commentsCount-1, section: 0)
        commentsTableView.insertRows(at: [indexPath], with: .bottom)
        
        commentsTableView.reloadData()
        commentsTableView.scrollToBottom()
    }
    
    //MARK: - Add image to Library
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
}

