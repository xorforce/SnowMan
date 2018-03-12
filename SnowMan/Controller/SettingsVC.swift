//
//  SettingsVC.swift
//  SnowMan
//
//  Created by Bhagat  Singh on 07/03/18.
//  Copyright © 2018 Bhagat Singh. All rights reserved.
//

import UIKit

class SettingsVC: UITableViewController {
    
    let darkMode = UserDefaults.standard.bool(forKey: darkModeKey)
    let rows = ["Dark Mode"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if darkMode {
            tableView.backgroundColor = .black
            navigationController?.navigationBar.tintColor = .white
        }
        else {
            tableView.backgroundColor = .white
            navigationController?.navigationBar.tintColor = .black
        }
        
        tableView.tableFooterView = UIView()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backItem?.title = ""
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! SettingsTableViewCell
        cell.settingsLabel.text = rows[indexPath.row]
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if darkMode {
            return .lightContent
        }
        return .default
    }
    
}
