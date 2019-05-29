//
//  CityListViewController.swift
//  Weather
//
//  Created by Sapgv on 16/05/2019.
//  Copyright © 2019 Sapgv. All rights reserved.
//

import UIKit

class ListCityViewController: UITableViewController {

    let cellId = "ListCityCell"
    var locations: [Location] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        self.navigationItem.rightBarButtonItem = addButtonItem
        self.navigationItem.title = "Cities"
        
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
        update()
    }

    func update() {
        locations = try! CoreDataStore.find(entity: Location.self)
        tableView.reloadData()
    }
    
    @objc
    func add(_ sender: AnyObject) {
        let findCityViewController = FindCityViewController()
        findCityViewController.selectClosure = {
            self.update()
        }
        self.present(findCityViewController, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let location = locations[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = location.name
        cell.detailTextLabel?.text = location.fullName
        
        return cell
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let location = locations[indexPath.row]
            CoreDataStore.delete(location) { saveResult in
                if saveResult == .success {
                    self.locations.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }            
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

}
