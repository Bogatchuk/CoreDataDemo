//
//  TableViewController.swift
//  CoreDataDemo
//
//  Created by Roma Bogatchuk on 22.11.2022.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    var toDoItems: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = Task.fetchRequest()
        
        do {
            toDoItems = try context.fetch(fetchRequest)
            
        } catch {
            print(error.localizedDescription)
        }
    }

    // MARK: - Table view data source

    @IBAction func addTask(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Create task", message: "Add new task", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default){_ in
            let textField = alert.textFields?.first
            self.saveTask(taskToDo: (textField?.text)! )
            self.tableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addTextField()
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return toDoItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let task = toDoItems[indexPath.row]
        var configure = cell.defaultContentConfiguration()
        configure.text = task.taskToDo
        cell.contentConfiguration = configure

        return cell
    }
    
    func saveTask(taskToDo: String){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: context)
        let taskObject = NSManagedObject(entity: entity!, insertInto: context) as! Task
        taskObject.taskToDo = taskToDo
        
        do {
          try context.save()
          toDoItems.append(taskObject)
          print("Saved! Good Job!")
        } catch {
          print(error.localizedDescription)
        }
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

}
