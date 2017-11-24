//
//  ListViewController.swift
//  Quize
//
//  Created by Doaa Alkasaby on 11/11/17.
//  Copyright © 2017 Elryad. All rights reserved.
//

import UIKit

class ListViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var tableView: UICollectionView!
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
    
    private func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if localOrRemote == "local" {
            return SavedProducts.count
            
        }else {
            return Products.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tableView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as! ListViewCell
        
        if localOrRemote == "local" {
            cell.nameTV.text! = SavedProducts[indexPath.row].productName!
            cell.priceTV.text! = SavedProducts[indexPath.row].price!
            cell.customerNameTV.text! = SavedProducts[indexPath.row].customerName!
            cell.customerPhoneTV.text! = SavedProducts[indexPath.row].customerPhone!
            let imageLink = SavedProducts[indexPath.row].picture!
            cell.setItemImage(imgUrl: imageLink)
            //set item rate value as its cell numer as a temporary value
            cell.setItemRating(rateValue: indexPath.row + 1)
        }else {
            cell.nameTV.text! = Products[indexPath.row].ProductName!
            cell.priceTV.text! = Products[indexPath.row].Price!
            cell.customerNameTV.text! = Products[indexPath.row].Customer_name!
            cell.customerPhoneTV.text! = Products[indexPath.row].Customer_Phone!
            let imageLink = Products[indexPath.row].picture!
            cell.setItemImage(imgUrl: imageLink)
            //set item rate value as its cell numer as a temporary value
            cell.setItemRating(rateValue: indexPath.row + 1)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if localOrRemote == "local" {
            performSegue(withIdentifier: "list_map_segue", sender: SavedProducts[indexPath.row])
        }else{
            performSegue(withIdentifier: "list_map_segue", sender: Products[indexPath.row])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dist = segue.destination as? MapDirectionViewController {
            print("step1")
            let lat = Double((sender as! Product).Lat!)
            let long = Double((sender as! Product).Lan!)
            dist.setDestinationDim(lat: lat!, long: long!)
        }
    }
}
