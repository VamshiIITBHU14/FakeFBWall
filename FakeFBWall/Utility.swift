//
//  Utility.swift
//  FakeFBWall
//
//  Created by Vamshi Krishna on 18/07/18.
//  Copyright © 2018 Vamshi Krishna. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    static func returnRGBColor(r:CGFloat, g:CGFloat, b:CGFloat, alpha:CGFloat) -> UIColor{
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: alpha)
    }
}

extension UITableView {
    
    func scrollToBottom(){
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections - 1) - 1,
                section: self.numberOfSections - 1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func scrollToTop() {
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
}


extension UITableView {
    var capturedImage : UIImage {
        UIGraphicsBeginImageContext(contentSize);
        scrollToRow(at: NSIndexPath(row: 0, section: 0) as IndexPath, at:     UITableViewScrollPosition.top, animated: false)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let row = numberOfRows(inSection: 0)
        let numberofRowthatShowinscreen = 4
        let scrollCount = row / numberofRowthatShowinscreen
        
        for i in 0 ..< scrollCount  {
            scrollToRow(at: NSIndexPath(row: (i+1)*numberofRowthatShowinscreen, section: 0) as     IndexPath, at: UITableViewScrollPosition.top, animated: false)
            layer.render(in: UIGraphicsGetCurrentContext()!)
        }
        
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return image;
    }
}
