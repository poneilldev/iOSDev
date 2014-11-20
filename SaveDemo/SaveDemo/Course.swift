//
//  Course.swift
//  SaveDemo
//
//  Created by Paul O'Neill on 11/13/14.
//  Copyright (c) 2014 Paul O'Neill. All rights reserved.
//

import Foundation
import CoreData

class Course: NSManagedObject {

    @NSManaged var author: String
    @NSManaged var title: String
    @NSManaged var releaseDate: NSDate
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, title: String, text: String) -> Course {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Course", inManagedObjectContext: moc) as Course
        newItem.title = title
        newItem.author = text
        
        return newItem
    }

}


