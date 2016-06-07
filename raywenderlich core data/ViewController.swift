//
//  ViewController.swift
//  raywenderlich core data
//
//  Created by Arsalan on 03/06/2016.
//  Copyright © 2016 Arsalan. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate,UISearchDisplayDelegate{
    // tem string to hold data
    //    var names = [String]()
    
    @IBOutlet weak var searchbarcontroller: UIView!
    // coredata
    var people = [NSManagedObject]()
    
    @IBOutlet weak var tableView: UITableView!  
    
    
    
    @IBAction func addName(sender: AnyObject) {
        
        
        
        
        let alert = UIAlertController(title: "New Name",  message: "Add a new name",  preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .Default,
                                       handler: { (action:UIAlertAction) -> Void in
                                        let textField = alert.textFields!.first
                                        
                                        self.saveName(textField!.text!)
                                        
                                        self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",    style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
            
        }
        
        
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
                              animated: true,
                              completion: nil)
        
        
    }
    
    
    
    func saveName(name: String) {
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2 entity means table name
        let entity =  NSEntityDescription.entityForName("Persontable",
                                                        inManagedObjectContext:managedContext)
        
        let person = NSManagedObject(entity: entity!,
                                     insertIntoManagedObjectContext: managedContext)
        
        //3     table coulumn
        person.setValue(name, forKey: "personName")
        
        //4
        do {
            try managedContext.save()
            //5
            people.append(person)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    //    required init?(coder aDecoder : NSCoder){
    //        super.init(coder: aDecoder)
    //        navigationItem.leftBarButtonItem = editButtonItem()
    //        
    //    }
    //    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     let   searchBar = UISearchBar()
        searchBar.sizeToFit()
         navigationItem.titleView = searchBar
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        
        
        
        
        title = "\"The List View\""
        
        
        tableView.registerClass(UITableViewCell.self,
                                forCellReuseIdentifier: "Cell")
    }
    
    
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        //        cell!.textLabel!.text = people[indexPath.row].valueForKey("personName") as? String
        if editingStyle == .Delete {
            
            //            let appDelegate =
            //                UIApplication.sharedApplication().delegate as! AppDelegate
            //            
            //            let managedContext = appDelegate.managedObjectContext
            //            
            //            managedContext.deleteObject(people[indexPath.row])
            //            appDelegate.saveContext()
            //            people.removeAtIndex(indexPath.row)
            //            tableView.reloadData()
            //            let row = taskstore.taskobj[indexPath.row]
            //            let title = "Delete \(row.taskName)?"
            let message = "Do you want to delete ?"
            //
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler:nil)
            let delaction = UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) -> Void in
                
                //                self.taskstore.removeitem(row)
                //                self.imgstore.deleteimageforkey(self.taskstore.taskobj[indexPath.row].itemkey)
                let appDelegate =
                    UIApplication.sharedApplication().delegate as! AppDelegate
                
                let managedContext = appDelegate.managedObjectContext
                
                managedContext.deleteObject(self.people[indexPath.row])
                appDelegate.saveContext()
                
                
                
                
                //           self.people.removeAtIndex(indexPath.row)
                self.fetchData()
                tableView.reloadData()
            })
            
            ac.addAction(cancelAction)
            ac.addAction(delaction)
            presentViewController(ac, animated: true, completion: nil )
            
            
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        fetchData()
    }
    
    
    
    
    
    
    func fetchData(){
        
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Persontable")
        //        fetchRequest.predicate = NSPredicate(format:"personName = 12121")
//        fetchRequest.predicate =  NSPredicate(format: "personName = %@", "a")
        
        
        
        //3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            people = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    /////****   Data source function    ***/////
    
    
    // return row count
    func tableView(tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    
    // populates row
    func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCellWithIdentifier("Cell")
        // populate table row with data with key : column name
        cell!.textLabel!.text = people[indexPath.row].valueForKey("personName") as? String
        
        return cell!
    }
    
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 1
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        
        
        // 2
        let alert = UIAlertController(title: "Update", message: "Please Update the task list.", preferredStyle: .Alert)
        
        
        // 3
        let updateAction = UIAlertAction(title: "Update", style: .Default){(_) in
            
            let nameTextField = alert.textFields?.first
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            
            //            nameTextField!.text = self.people[indexPath.row].valueForKey("personName") as? String
            
            
            let str : String! = nameTextField!.text
            let persontableObj = self.people[indexPath.row]
            //   var persontableObj : Persontable =  self.people[indexPath.row] as! Persontable
            
            
            
            
            persontableObj.setValue(str, forKey: "personName")
            
            
            appDelegate.saveContext()
            self.fetchData()
            self.tableView.reloadData()
        }
        
        // 4
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addTextFieldWithConfigurationHandler(nil)
        
        alert.addAction(updateAction)
        alert.addAction(cancelAction)
        
        // 5
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
//    func updateSearchResultsForSearchController(searchbarcontroller: UISearchController) {
//        var request = NSFetchRequest(entityName: "Serie")
//        filteredTableData.removeAll(keepCapacity: false)
//        let searchPredicate = NSPredicate(format: "SELF.infos CONTAINS[c] %@", searchController.searchBar.text)
//        let array = (series as NSArray).filteredArrayUsingPredicate(searchPredicate)
//        
//        for item in array
//        {
//            let infoString = item.infos
//            filteredTableData.append(infoString)
//        }
//        
//        self.tableView.reloadData()
//    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Persontable")
        let searchstring = searchBar.text! as! String!
            print(searchstring)
        
        
//                fetchRequest.predicate = NSPredicate(format:"personName = 12121")
//                fetchRequest.predicate =  NSPredicate(format: "personName = %@", "12121")
//        fetchRequest.predicate =  NSPredicate(format: "personName = %@", searchstring)
            fetchRequest.predicate =  NSPredicate(format: "personName CONTAINS[cd] %@",searchstring)
        
        
        
//        let namesBeginningWithLetterPredicate = NSPredicate(format: "(firstName BEGINSWITH[cd] $letter) OR (lastName BEGINSWITH[cd] $letter)")
        
        //3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            people = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        tableView.reloadData()
    }
    
    
    
    
    
    
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Persontable")
        //        fetchRequest.predicate = NSPredicate(format:"personName = 12121")
        //        fetchRequest.predicate =  NSPredicate(format: "personName = %@", "a")
        
        
        
        //3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            people = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        tableView.reloadData()
//        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
    
    
    
}

