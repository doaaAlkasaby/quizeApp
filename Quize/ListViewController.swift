//
//  ListViewController.swift
//  Quize
//
//  Created by Doaa Alkasaby on 11/11/17.
//  Copyright © 2017 Elryad. All rights reserved.
//

import UIKit

class ListViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    var Products = [Product]()
    var SavedProducts = [ProductTable]()
    var localOrRemote : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //initialize tableview
        tableView.dataSource = self
        tableView.delegate = self
        
        print("\(Products.count)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showGridView(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if localOrRemote == "local" {
            return SavedProducts.count
            
        }else {
            return Products.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListViewCell
        
        if localOrRemote == "local" {
            cell.nameTV.text! = SavedProducts[indexPath.row].productName!
            cell.priceTV.text! = SavedProducts[indexPath.row].price!
            cell.customerNameTV.text! = SavedProducts[indexPath.row].customerName!
            cell.customerPhoneTV.text! = SavedProducts[indexPath.row].customerPhone!
            let imageLink = SavedProducts[indexPath.row].picture!
            cell.setItemImage(imgUrl: imageLink)
        }else {
        cell.nameTV.text! = Products[indexPath.row].ProductName!
        cell.priceTV.text! = Products[indexPath.row].Price!
        cell.customerNameTV.text! = Products[indexPath.row].Customer_name!
        cell.customerPhoneTV.text! = Products[indexPath.row].Customer_Phone!
        let imageLink = Products[indexPath.row].picture!
        cell.setItemImage(imgUrl: imageLink)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if localOrRemote == "local" {
        performSegue(withIdentifier: "list_map_segue", sender: SavedProducts[indexPath.row])
         }else{
            performSegue(withIdentifier: "list_map_segue", sender: Products[indexPath.row])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dist = segue.destination as? LocationViewController {
            print("step1")
            let lat = Double((sender as! Product).Lat!)
            dist.lat = lat
            let long = Double((sender as! Product).Lan!)
            dist.long = long
        }
    }
}
