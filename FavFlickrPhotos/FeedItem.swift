//
//  FeedItem.swift
//  FavFlickrPhotos
//
//  Created by Koss on 05/03/16.
//  Copyright © 2016 mine. All rights reserved.
//

import Foundation

class FeedItem {
    let title: String
    let imageURL: NSURL
    let saveDate: NSDate
    
    init (title: String, imageURL: NSURL, saveDate: NSDate) {
        self.title = title
        self.imageURL = imageURL
        self.saveDate = saveDate
    }
    
   /* func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.title, forKey: "itemTitle")
        aCoder.encodeObject(self.imageURL, forKey: "itemURL")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let storedTitle = aDecoder.decodeObjectForKey("itemTitle") as? String
        let storedURL = aDecoder.decodeObjectForKey("itemURL") as? NSURL
        
        guard storedTitle != nil && storedURL != nil else {
            return nil
        }
        self.init(title: storedTitle!, imageURL: storedURL!, saveDate: saveDate)
        
        
    }*/
    
    
}