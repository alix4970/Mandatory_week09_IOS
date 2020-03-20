//
//  ViewController.swift
//  Mandatory09
//
//  Created by Ali Al sharefi on 20/03/2020.
//  Copyright © 2020 Ali Al sharefi. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    var savedText = "Add note ..."
    
    var textArray = [String]()
    var idArray = [String]()
    
    var db: Firestore!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        myTextView.delegate = self
        
        db = Firestore.firestore()
        
        getNotes()
    }
    
    func getNotes() {
        textArray = [String]()
        
        db.collection("notes").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.textArray.append(document.data()["note"] as! String)
                    self.idArray.append(document.documentID);
                }
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
         myTextView.endEditing(true)

         savedText = myTextView.text!

         db.collection("notes").document().setData([
             "note": savedText,
         ]) { err in
             if let err = err {
                 print("Error writing document: \(err)")
             } else {
                 print("Document successfully written!")
             }
         }
         
         getNotes()
        
    }
    
    
/*  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
 */
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        self.textArray.remove(at: indexPath.row)
        db.collection("notes").document(idArray[indexPath.row]).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        getNotes()
      }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = textArray[indexPath.row]
        return cell!
    }


}

