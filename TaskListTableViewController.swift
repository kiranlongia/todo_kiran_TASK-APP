//
//  TaskListTableViewController.swift
//  todo_kirandeep_777255
//
//  Created by user176491 on 6/24/20.
//  Copyright © 2020 user176491. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

extension TaskListTableViewController:
UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification ,withCompletionHandler completionHandler : @escaping(UNNotificationPresentationOptions)-> Void) {
        completionHandler([.alert,.sound, .badge])
    }
}
    

class TaskListTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    
   
    var tasks: [Task]?
        var items: [NSManagedObject] = []
        var addDay = "0"

        override func viewDidLoad() {
            super.viewDidLoad()

            searchBar.delegate = self
            self.loadCoreData()
           let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
               view.addGestureRecognizer(tap)
         
        }
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
        
        
        override func viewWillAppear(_ animated: Bool) {
            tasks?.removeAll()
            self.loadCoreData()
            tableView.reloadData()
            
            
        }

        // MARK: - Table view data source

        override func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return tasks?.count ?? 0
        }

        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
                   let task = tasks![indexPath.row]
                   let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell")
                   cell?.textLabel?.text = task.title
                   cell?.detailTextLabel?.text = "\(task.days) days needed to complete the task"
            
                    if tasks?[indexPath.row].increment == self.tasks?[indexPath.row].days{
                        cell?.backgroundColor = UIColor.systemGreen
                       // cell?.textLabel?.text = "Completed"
                        cell?.detailTextLabel?.text = ""
                        
                        
                    }
                   return cell!
            
        }
   
        
        override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let edit = UIContextualAction(style: .normal,title: "Edit"){ (action, view, completion:(Bool)->()) in
     self.performSegue(withIdentifier: "Vc", sender: nil)
            }
            edit.backgroundColor=UIColor.systemRed
            return UISwipeActionsConfiguration(actions: [edit])
        }
        
        
        override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
                let Addaction = UITableViewRowAction(style: .normal, title: "Add Day") { (rowaction, indexPath) in
                   
                    print("add day clicked")
                    let alertcontroller = UIAlertController(title: "Add Days", message: nil, preferredStyle: .alert)
                                   
                                   alertcontroller.addTextField { (textField ) in
                                                   textField.placeholder = "enter the number of days"
                                    self.addDay = textField.text!
                                    
                                       textField.text = ""
                                    
                                   }
                                   let CancelAction = UIAlertAction(title: "Quit", style: .cancel, handler: nil)
                                   CancelAction.setValue(UIColor.systemPink, forKey: "titleTextColor")
                                   let AddItemAction = UIAlertAction(title: "Add", style: .default){
                                       (action) in
                                    let count = alertcontroller.textFields?.first?.text
                                    self.tasks?[indexPath.row].increment += Int(count!) ?? 0
                                    
                                    if self.tasks?[indexPath.row].increment == self.tasks?[indexPath.row].days{
                                        
                                       
    //
                                                   
                                        
                                        }
                                        
                                    
                                
                                    self.tableView.reloadData()
                                    
                            
                        }
                            AddItemAction.setValue(UIColor.black, forKey: "titleTextColor")
                                                 alertcontroller.addAction(CancelAction)
                                                 alertcontroller.addAction(AddItemAction)
                                                 self.present(alertcontroller, animated: true, completion: nil)
                }
                Addaction.backgroundColor = UIColor.systemPink
                
        
                let deleteaction = UITableViewRowAction(style: .normal, title: "Delete") { (rowaction, indexPath) in
                    
                    
                          // let taskItem = self.tasks![indexPath.row] as? NSManagedObject
                           let appDelegate = UIApplication.shared.delegate as! AppDelegate
                           let ManagedContext = appDelegate.persistentContainer.viewContext
                           let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
                    do{
                        let test = try ManagedContext.fetch(fetchRequest)
                        let item = test[indexPath.row] as!NSManagedObject
                        self.tasks?.remove(at: indexPath.row)
                        ManagedContext.delete(item)
                        tableView.reloadData()
                        
                        do{
                                    try ManagedContext.save()
                            }
                    
                        catch{
                                           print(error)
                                       }
                    }
                    catch{
                        print(error)
                    }
                           
                        

                }
                       deleteaction.backgroundColor = UIColor.red
                       return [Addaction,deleteaction]
            }

            
     

        // Override to support conditional editing of the table view.
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            // Return false if you do not want the specified item to be editable.
            return true
        }
        

        
        // Override to support editing the table view.
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // Delete the row from the data source
                tableView.deleteRows(at: [indexPath], with: .left)
            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            }
        }
        

        /*
        // Override to support rearranging the table view.
        override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

        }
        */

        /*
        // Override to support conditional rearranging of the table view.
        override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
            // Return false if you do not want the item to be re-orderable.
            return true
        }
        */

        /*
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        }
        */
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
            
            if let detailView = segue.destination as? ViewController{
                detailView.taskTable = self
                detailView.tasks = tasks
                
           }
        
        }
        
        func loadCoreData(){
            tasks = [Task]()
             //create an instance of app delegate
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    // context
                    let ManagedContext = appDelegate.persistentContainer.viewContext
             
             let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
            
             do{
                 let results = try ManagedContext.fetch(fetchRequest)
                 if results is [NSManagedObject]{
                     for result in results as! [NSManagedObject]{
                         let title = result.value(forKey:"title") as! String

                         let days = result.value(forKey: "days") as! Int


                         tasks?.append(Task(title: title, days: days))
                         //tableView.reloadData()
                     }
                 }
             } catch{
                 print(error)
             }
             print(tasks!.count )
        }
        
        func LoadData(){
            
            //create an instance of app delegate
                   let appDelegate = UIApplication.shared.delegate as! AppDelegate
                   
                   // context
                   let ManagedContext = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
            
            do{
                tasks = try ManagedContext.fetch(fetchRequest) as? [Task]
                self.tableView.reloadData()
                
            }catch
            {
                print("error")
            }

        }
        
        func updateText(taskArray: [Task]){
            tasks = taskArray
            tableView.reloadData()
        }
        

        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchText != ""{
                var predicate: NSPredicate = NSPredicate()
                predicate = NSPredicate(format: "title=%@", "\(searchText)")
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let ManagedContext = appDelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
                fetchRequest.predicate = predicate
                do{
                   tasks = try ManagedContext.fetch(fetchRequest) as? [Task]
                }
                catch{
                    print("error")
                }
            }
            else{
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let ManagedContext = appDelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
            
                do{
                    tasks = try ManagedContext.fetch(fetchRequest) as? [Task]
                }
                catch{
                    print("error")
                }
                
            }
            tableView.reloadData()
        }
    
    @IBAction func sortByName(_ sender: Any) {
   let item = self.tasks!
                           self.tasks! = item.sorted { $0.title < $1.title }
                              self.tableView.reloadData()
            }
            
            
            
        }
