//
//  LocationListVC.swift
//  SnowMan
//
//  Created by Bhagat  Singh on 12/03/18.
//  Copyright © 2018 Bhagat Singh. All rights reserved.
//

import UIKit
import RealmSwift

class LocationListVC: UITableViewController {
    
    var locations : Results<LocationModel>!
    let darkMode = UserDefaults.standard.bool(forKey: darkModeKey)
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = RealmService.shared.realm
        locations = realm.objects(LocationModel.self)
    }
    
    func setupUI() {
        navigationController?.navigationBar.isHidden = false
        if darkMode {
            tableView.backgroundColor = .black
            navigationController?.navigationBar.tintColor = .white
            navigationItem.rightBarButtonItem?.tintColor = .white
        }
        else {
            tableView.backgroundColor = .white
            navigationController?.navigationBar.tintColor = .black
            navigationItem.rightBarButtonItem?.tintColor = .black
        }
        
        tableView.tableFooterView = UIView()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backItem?.title = ""
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let locations = locations {
            return locations.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LocationTableViewCell
        let obj = locations[indexPath.row]
        cell.configureCell(obj)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = locations[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "weatherVC")
        UserDefaults.standard.set(obj.latitude.value, forKey: latitudeKey)
        UserDefaults.standard.set(obj.longitude.value, forKey: longitudeKey)
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            RealmService.shared.delete(locations[indexPath.row])
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let darkMode = UserDefaults.standard.bool(forKey: darkModeKey)
        if darkMode {
            return .lightContent
        }
        return .default
    }
}
