//
//  DataController.swift
//  FavFlickrPhotos
//
//  Created by Koss on 05/03/16.
//  Copyright © 2016 mine. All rights reserved.
//

import Foundation
import CoreData

class DataController    {
    //create instance of the context
    let managedObjectContext: NSManagedObjectContext
    //supply that context
    init(moc: NSManagedObjectContext) {
        self.managedObjectContext = moc
    }
    
    //setup objects in the storage
    convenience init?() {
        //create reference to model file, when compile model file will be a momd file
        guard let modelURL = NSBundle.mainBundle().URLForResource("FavFlickrPhotos", withExtension: "momd") else {
            return nil
        }
        //will encapsulate the loaded model
        guard let mom = NSManagedObjectModel(contentsOfURL: modelURL) else {
            return nil
        }
        //create persistence coordinator
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        //from the create managed context
        let moc = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        //assign it to the context
        moc.persistentStoreCoordinator = psc
        
        //setup persistence storage itself, where file gets stored, it is a user file, we want it to get backed up,
        //so it is stored in the .DocumentDirectory
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let persistantStoreFileURL = urls[0].URLByAppendingPathComponent("Bookmarks.sqlite")
        
        do {
            //add file to storage as SQL Type
            try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: persistantStoreFileURL, options: nil)
        } catch {
            fatalError("Error adding store.")
        }
        self.init(moc: moc)
    }
    
    //add feed to our document, store a tag and image in the db
    func addImageToDB(feed : FeedItem) {
        //add new image and properties
        let newImage = NSEntityDescription.insertNewObjectForEntityForName("Image", inManagedObjectContext: self.managedObjectContext) as! Image
        
        //set title and URL  and date from seccion struct
        newImage.title = feed.title
        newImage.imageURL = feed.imageURL.absoluteString
        newImage.date = feed.saveDate
        //print(newImage.title)
        print("image saved to db")
        do {
            //after making changes, save has to be called
            try self.managedObjectContext.save()
        } catch {
            fatalError("couldn't save context")
        }
    }
}