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
    var viewModel: ViewModel?
    var locations: [Location] {
        return viewModel?.locations ?? []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItem()
        setupTableView()
        update()
    }

    func update() {
        updateContentInset()
        tableView.reloadData()
    }
    
    func setupNavigationItem() {
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        self.navigationItem.rightBarButtonItem = addButtonItem
        self.navigationItem.title = "Cities"
    }
    
    func setupTableView() {
        updateContentInset()
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
        tableView.backgroundColor = UIColor.clear
        tableView.isOpaque = false
        tableView.backgroundView = UIImageView(image: UIImage(named: "table"))
    }
    
    func updateContentInset() {
        if locations.isEmpty {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        else {
            tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        }
    }
    
    @objc
    func add(_ sender: AnyObject) {
        let findCityViewController = FindCityViewController()
        findCityViewController.selectClosure = {
            self.update()
        }
        self.present(findCityViewController, animated: true, completion: nil)
    }
    
    @objc
    func updateWeather(_ sender: AnyObject) {
        viewModel?.updateWeather()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? locations.count : 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let location = locations[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ListCityCell
        cell.setupCell(location: location)
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
//            CoreDataStore.delete(location) { saveResult in
//                if saveResult == .success {
//                    self.locations.remove(at: indexPath.row)
//                    self.updateContentInset()
//                    tableView.deleteRows(at: [indexPath], with: .fade)
//                }
//            }            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 84 + 20 : 84
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 0 {
            return nil
        }
        let view = FooterView.instanceFromNib() as? FooterView
        view?.addButton.addTarget(self, action: #selector(add(_:)), for: .touchUpInside)
        view?.updateButton.addTarget(self, action: #selector(updateWeather(_:)), for: .touchUpInside)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 44
    }
//    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        return "Footer"
//    }

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
