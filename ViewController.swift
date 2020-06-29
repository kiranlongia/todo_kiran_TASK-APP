//
//  ViewController.swift
//  todo_kirandeep_777255
//
//  Created by user176491 on 6/23/20.
//  Copyright © 2020 user176491. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var tasks: [Task]?
      
      weak var taskTable: TaskListTableViewController?
    
    @IBOutlet weak var txtDetails: UITextField!
    
   override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
       // loadCoreData()
        saveCoreData()
        NotificationCenter.default.addObserver(self, selector: #selector(saveCoreData), name: UIApplication.willResignActiveNotification, object: nil)
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
     view.addGestureRecognizer(tap)
    }
        
   

//Calls this function when the tap is recognized.
@objc func dismissKeyboard() {
    //Causes the view (or one of its embedded text fields) to resign the first responder status.
    view.endEditing(true)
}

    @IBAction func saveBtn(_ sender: Any) {
        let title = txtDetails.text ?? ""
               let days = Int(txtDetails.text ?? "0") ?? 0
                          
                       
               let task = Task(title: title, days: days)
               tasks?.append(task)
               saveCoreData()
                        /*  for textField in txtDetails {
                              textField.text = ""
                              textField.resignFirstResponder()
                          }*/
               creatNotification()
           }
    func creatNotification(){
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Task is due"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:3.0 , repeats: false)
        
        let request = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)
        center.add(request){
            (error) in
            if error != nil{
                print("Error = \(error?.localizedDescription ?? "error local notification")")
            }
        }
    }
           @objc func saveCoreData(){
               
              // call clear core data
               clearCoreData()
               
               //create an instance of app delegate
               let appDelegate = UIApplication.shared.delegate as! AppDelegate
                      
                                  // context
               let ManagedContext = appDelegate.persistentContainer.viewContext
               for task in tasks! {
                                      let taskEntity = NSEntityDescription.insertNewObject(forEntityName: "TaskEntity", into: ManagedContext)
                                     taskEntity.setValue(task.title, forKey: "title")
                                     taskEntity.setValue(task.days, forKey: "days")
                      
                                      print("\(task.days)")
                                      //save  context
                                      do{
                                          try ManagedContext.save()
                                      }catch{
                                          print(error)
                                      }
                      
                      
                                      print("days: \(task.days)")
                                  }
               loadCoreData()
           }
           
           func loadCoreData(){
               tasks = [Task]()
                //create an instance of app delegate
                       let appDelegate = UIApplication.shared.delegate as! AppDelegate
                       
                       // context
                       let ManagedContext =  appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
               
                do{
                    let results = try ManagedContext.fetch(fetchRequest)
                    if results is [NSManagedObject]{
                        for result in results as! [NSManagedObject]{
                            let title = result.value(forKey:"title") as! String
                         
                            let days = result.value(forKey: "days") as! Int
                           
                            
                            tasks?.append(Task(title: title, days: days))
                           
                        }
                    }
                } catch{
                    print(error)
                }
                print(tasks!.count )
           }
           
           override func viewWillDisappear(_ animated: Bool) {
                 
                  taskTable?.updateText(taskArray: tasks!)
                  //taskTable?.updateTask(task: task1!)
           
              }
           
           func clearCoreData(){
               
           
            //create an instance of app delegate
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            // context
            let ManagedContext = appDelegate.persistentContainer.viewContext
               
               //create fetch request
                 let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
               
               fetchRequest.returnsObjectsAsFaults = false
               do{
                   
                   let results = try ManagedContext.fetch(fetchRequest)
                   for managedObjects in results{
                       if let managedObjectsData = managedObjects as? NSManagedObject{
                           
                           ManagedContext.delete(managedObjectsData)
                       }
                   }
               }
                   catch{
                       print(error)
                   }
               
           }
           
           /*
           // MARK: - Navigation

           // In a storyboard-based application, you will often want to do a little preparation before navigation
           override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
               // Get the new view controller using segue.destination.
               // Pass the selected object to the new view controller.
           }
           */
    }
    



