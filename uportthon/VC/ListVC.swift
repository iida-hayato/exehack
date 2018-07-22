//
//  ListTableViewController.swift
//  uportthon
//
//  Created by hayato.iida on 2018/07/21.
//  Copyright © 2018年 hayato.iida. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MessageUI

class ListVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
      tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      return Store.shared.list.count > 3 ? 3 : Store.shared.list.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListTableViewCell
      let v = Store.shared.list[indexPath.row]
      cell.name.text = v["name"].stringValue
      cell.lang.text = v["home_city"].stringValue
      cell.hoby.text = v["interests"].stringValue
      let r = (0...(v["contribution"].intValue / 10)).reduce("") { (pre, i) -> String in
        "\(pre)⭐"
      }

      cell.contribution.text = r
      cell.email.text = v["email"].stringValue
      if let i = v["image"].string {
        cell.userImage.image = UIImage(named: i)
      }

      return cell
    }
  let emails = ["sato@gmail.co.com", "suzuki@gmail.co.com", "takahasi@gmail.co.com"]
  let names = ["sato", "suzuki", "takahasi"]

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let email = Store.shared.list[indexPath.row]["email"].string {
      sendMail(email: email)
      return
    }
    let url = URL(string: "https://id.uport.me/req/")
    UIApplication.shared.open(url!) { (result) in
      print(result)
    }

    Store.shared.list[indexPath.row]["image"] = JSON("p\(indexPath.row)")
    Store.shared.list[indexPath.row]["name"] = JSON(names[indexPath.row])
    Store.shared.list[indexPath.row]["email"] = JSON(emails[indexPath.row])
    tableView.reloadData()
  }

  func sendMail(email: String) {
    //メールを送信できるかチェック
    if MFMailComposeViewController.canSendMail()==false {
      return
    }

    let mailViewController = MFMailComposeViewController()
    let toRecipients = [email] //Toのアドレス指定

    mailViewController.mailComposeDelegate = self
    mailViewController.setToRecipients(toRecipients) //Toアドレスの表示
    self.present(mailViewController, animated: true, completion: nil)
  }
}

extension ListVC: MFMailComposeViewControllerDelegate {

}
