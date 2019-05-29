//
//  LocationsViewController.swift
//  Weather
//
//  Created by Sapgv on 16/04/2019.
//  Copyright © 2019 Sapgv. All rights reserved.
//

import UIKit
import Moya

class FindCityViewController: UIViewController {
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Enter city name"
        searchBar.delegate = self
        return searchBar
    }()
    
    var locations: [SearchLocation] = []
    let tableView = UITableView()
    let cellId = "FindCityCell"
    var selectClosure: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(searchBar)
        self.view.addSubview(tableView)
        
        view.backgroundColor = .white
        setupSearchBar()
        setupTableView()
        setupView()
        self.navigationItem.title = "Find a city"
    }
    
    func setupSearchBar() {
        searchBar.becomeFirstResponder()
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    func setupTableView() {
        
        tableView.keyboardDismissMode = .onDrag
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    func setupView() {
        let gesturerecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gesturerecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(gesturerecognizer)
        
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
        
    }
}

extension FindCityViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
}

extension FindCityViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let location = locations[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = location.name
        cell.detailTextLabel?.text = location.fullName
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var location = locations[indexPath.row]
        let placeProvider = MoyaProvider<GoogleAutocompletionService>()
        
        placeProvider.request(.placeDetail(placeId: location.placeId)) { result in
            
            switch result {
            case let .success(response):
                do {
                    if let data = try response.mapJSON() as? [String: AnyObject],
                        let result = (data["result"] as? [String: AnyObject]),
                        let geometry = result["geometry"] as? [String: AnyObject],
                        let coordinates = geometry["location"] as? [String: Double]
                    {
                        
                        //save picked location
                        location.lat = try unwrap(coordinates["lat"])
                        location.lon = try unwrap(coordinates["lng"])
                        Location.save(searchLocation: location)
                        self.dismiss(animated: true)
                        self.selectClosure?()
                    }
                }
                catch let error {
                    //TO DO
                    print(error)
                }
            case let .failure(error):
                //TO DO
                print(error)
            }
        }
        
    }
}

extension FindCityViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let autocompleteProvider = MoyaProvider<GoogleAutocompletionService>()
        autocompleteProvider.request(.search(text: searchText)) { result in
            
            switch result {
            case let .success(response):
                do {
                    if let data = try response.mapJSON() as? [String: AnyObject], let predictions = data["predictions"] as? [[String: AnyObject]] {
                       print(data)
                        self.locations = try predictions.compactMap {
                            return try SearchLocation($0)
                        }
                        self.tableView.reloadData()

                    }
                } catch let error {
                    //TO DO
                    print(error)
                }
                
            case let .failure(error):
                //TO DO
                print(error)
            }

        }
        
    }
    
}
