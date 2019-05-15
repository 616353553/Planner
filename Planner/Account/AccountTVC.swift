//
//  AccountTVC.swift
//  Planner
//
//  Created by Ningshuo Bai on 4/8/19.
//  Copyright © 2019 Ningshuo Bai. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class AccountTVC: UITableViewController {

    @IBOutlet weak var avatarBgImage: UIImageView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var logInOutLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor.groupTableViewBackground
        avatarImage.layer.cornerRadius = avatarImage.frame.width / 2
        avatarImage.layer.borderWidth = 2
        avatarImage.layer.borderColor = UIColor.white.cgColor
        avatarImage.clipsToBounds = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        resetTableView()
    }
    
    func resetTableView() {
        self.tableView.reloadData()
        if Auth.auth().currentUser == nil {
            logInOutLabel.text = "Log in"
            logInOutLabel.textColor = UIColor.blue
        } else {
            logInOutLabel.text = "Log out"
            logInOutLabel.textColor = UIColor.red
        }
    }
    
    func logout() {
        let optionMenu = UIAlertController(title: "Log out", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler:{ (action) -> Void in
            do {
                try Auth.auth().signOut()
                FBSDKLoginManager().logOut()
                self.resetTableView()
            } catch {
                let alert = UIAlertController(title: "Error", message: "Unable to log out, please try again later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionMenu.addAction(yesAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if Auth.auth().currentUser == nil {
                return 0
            }
            return 5
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height))
        headerView.backgroundColor = UIColor.groupTableViewBackground
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        switch indexPath {
        case [0, 1]:
            self.performSegue(withIdentifier: "toFollowingCourse", sender: self)
        case [0, 2]:
            self.performSegue(withIdentifier: "toMyCourse", sender: self)
        case [0, 3]:
            self.performSegue(withIdentifier: "toMyTask", sender: self)
        case [1, 0]:
            if Auth.auth().currentUser == nil {
                let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
                let vc = storyboard.instantiateInitialViewController()!
                self.present(vc, animated: true, completion: nil)
            } else {
                self.logout()
            }
        default:
            break
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if Auth.auth().currentUser == nil && section == 0 {
            return 1
        }
        return super.tableView(tableView, heightForHeaderInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if Auth.auth().currentUser == nil && section == 0 {
            return 1
        }
        return super.tableView(tableView, heightForFooterInSection: section)
    }
    
//    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        view.backgroundColor = UIColor.groupTableViewBackground
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
