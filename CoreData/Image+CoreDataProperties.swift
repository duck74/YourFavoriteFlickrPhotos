//
//  Image+CoreDataProperties.swift
//  FavFlickrPhotos
//
//  Created by Koss on 05/03/16.
//  Copyright © 2016 mine. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Image {

    @NSManaged var date: NSDate?
    @NSManaged var title: String?
    @NSManaged var imageURL: String?

}
