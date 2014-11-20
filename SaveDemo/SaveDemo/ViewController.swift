//
//  ViewController.swift
//  SaveDemo
//
//  Created by Paul O'Neill on 11/13/14.
//  Copyright (c) 2014 Paul O'Neill. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate {

    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        }
        else {
            return nil
        }
        }()

    
    // Create the table view as soon as this class loads
    var logTableView = UITableView(frame: CGRectZero, style: .Plain)
    
    // Create an empty array of Courses
    var courses = [Course]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        Course.createInManagedObjectContext(self.managedObjectContext!, title: "1st Item", text: "This is my first log item")
        Course.createInManagedObjectContext(self.managedObjectContext!, title: "2nd Item", text: "This is my second log item")
        Course.createInManagedObjectContext(self.managedObjectContext!, title: "3rd Item", text: "This is my third log item")
        Course.createInManagedObjectContext(self.managedObjectContext!, title: "4th Item", text: "This is my fourth log item")
        Course.createInManagedObjectContext(self.managedObjectContext!, title: "5th Item", text: "This is my fifth log item")
        Course.createInManagedObjectContext(self.managedObjectContext!, title: "6th Item", text: "This is my sixth log item")
        */
        
        // Store the full frame in a temporary variable
        var viewFrame = self.view.frame
        
        // Adjust it down by 20 points
        viewFrame.origin.y += 20
        
        // Reduce the total height by 20 points
        viewFrame.size.height -= 20
        
        // Set the logTableview's frame to equal our temporary variable with the full size of the view
        // adjusted to account for the status bar height
        logTableView.frame = viewFrame
        
        // Add the table view to this view controller's view
        self.view.addSubview(logTableView)
        
        // Here, we tell the table view that we intend to use a cell we're going to call "LogCell"
        // This will be associated with the standard UITableViewCell class for now
        logTableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "LogCell")
        
        // This tells the table view that it should get it's data from this class, ViewController
        logTableView.dataSource = self
        
        // This tells the table view that it should get it's data from this class, ViewController
        logTableView.dataSource = self
        logTableView.delegate = self
        
        fetchCourse()
        
        // Add in the "+" button at the bottom
        let addButton = UIButton(frame: CGRectMake(0, UIScreen.mainScreen().bounds.size.height - 44, UIScreen.mainScreen().bounds.size.width, 44))
        addButton.setTitle("Add", forState: .Normal)
        addButton.backgroundColor = UIColor(red: 0.5, green: 0.9, blue: 0.5, alpha: 1.0)
        addButton.addTarget(self, action: "addNewItem", forControlEvents: .TouchUpInside)
        self.view.addSubview(addButton)
        
        // Reduce the total height by 20 points for the status bar, and 44 points for the bottom button
        viewFrame.size.height -= (20 + addButton.frame.size.height)
        
    }
    
    
    func fetchCourse() {
        let fetchRequest = NSFetchRequest(entityName: "Course")
        
        // Create a sort descriptor object that sorts on the "title"
        // property of the Core Data object
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        // Set the list of sort descriptors in the fetch request,
        // so it includes the sort descriptor
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Course] {
            courses = fetchResults
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LogCell") as UITableViewCell
        
        cell.textLabel.text = "\(courses[indexPath.row].title)"
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == .Delete ) {
            // Find the Course object the user is trying to delete
            let CourseToDelete = courses[indexPath.row]
            
            // Delete it from the managedObjectContext
            managedObjectContext?.deleteObject(CourseToDelete)
            
            // Refresh the table view to indicate that it's deleted
            self.fetchCourse()
            
            // Tell the table view to animate out that row
            [logTableView .deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)]
            save()
        }
    }
    
    
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let aCourse = courses[indexPath.row]
        let alert = UIAlertView(title: aCourse.title, message: aCourse.author, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK")
        alert.show()
    }
    
    // MARK: UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let cancelButtonIndex = 0
        let saveButtonIndex = 1
        
        switch (buttonIndex, alertView.tag) {
        case (saveButtonIndex, addItemAlertViewTag):
            if let alertTextField = alertView.textFieldAtIndex(0) {
                println("Save new item \(alertTextField.text)")
                saveNewItem(alertTextField.text)
            }
        default:
            println("Default case, do nothing")
        }
    }
    
    func saveNewItem(title : String) {
        // Create the new course
        var newCourse = Course.createInManagedObjectContext(self.managedObjectContext!, title: title, text: "")
        
        // Update the array containing the table view row data
        self.fetchCourse()
        
        // Animate in the new row
        // Use Swift's find() function to figure out the index of the newLogItem
        // after it's been added and sorted in our logItems array
        if let newItemIndex = find(courses, newCourse) {
            // Create an NSIndexPath from the newItemIndex
            let newLogItemIndexPath = NSIndexPath(forRow: newItemIndex, inSection: 0)
            // Animate in the insertion of this row
            logTableView.insertRowsAtIndexPaths([ newLogItemIndexPath ], withRowAnimation: .Automatic)
        }
        
        save()
    }
    
    func save() {
        var error : NSError?
        if(managedObjectContext!.save(&error) ) {
            println(error?.localizedDescription)
        }
    }
    
    // SWIPE TO DELETE
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    let addItemAlertViewTag = 0
    let addItemTextAlertViewTag = 2
    func addNewItem() {
        var titlePrompt = UIAlertView(title: "Enter Title", message: "", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Done")
        titlePrompt.alertViewStyle = .PlainTextInput
        titlePrompt.tag = addItemAlertViewTag
        titlePrompt.show()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

