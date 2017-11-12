//
//  GridViewController.swift
//  Quize
//
//  Created by Doaa Alkasaby on 11/11/17.
//  Copyright © 2017 Elryad. All rights reserved.
//

import UIKit
import CoreData


class CollectionViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var collectionView: UICollectionView!
    
    let productUrl = "http://maraselksa.com/WebServices/ShowData/Orders/showIOS.php"
    var Products = [Product]()
    var SavedProducts = [ProductTable]()
    var localOrRemote : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //initialize collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        
        if Reachability .isConnectedToNetwork(){
            print("Internet Connection Available!")
            localOrRemote = "remote"
            readRemoteProducts()
        }else{
            print("Internet Connection not Available!")
            localOrRemote = "local"
            readLocalProducts()
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("count: \(Products.count)")
        if localOrRemote == "local" {
            return SavedProducts.count
            
        }else {
            return Products.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionViewCell
        
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
                    cell.setItemImage(imgUrl: Products[indexPath.row].picture!)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if localOrRemote == "local" {
            performSegue(withIdentifier: "grid_map_segue", sender: SavedProducts[indexPath.row])
        }else{
        performSegue(withIdentifier: "grid_map_segue", sender: Products[indexPath.row])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dist = segue.destination as? LocationViewController {
            print("step1")
            let lat = Double((sender as! Product).Lat!)
            dist.lat = lat
            let long = Double((sender as! Product).Lan!)
            dist.long = long
        }else if let dist = segue.destination as? ListViewController {
            dist.Products = Products
        }
    }
//-----------
    func readRemoteProducts(){
        
        DispatchQueue.global().async {
            do {
                
                let url = URL(string: self.productUrl)!
                let jsonData = try! Data(contentsOf: url)
                if let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) {
                    if let items = json as? [[String : String]]{
                        print("dict: \(items)")
                        
                            for item in items {
                                let imgLink = "http://maraselksa.com/WebServices/images/"+item["picture"]!
                                self.Products.append(Product(Order_ID: item["Order_ID"]!, Product_ID: item["Product_ID"]!, ProductName: item["ProductName"]!, picture: imgLink, Quantatiy: item["Quantatiy"]!, Price: item["Price"]!, User_ID: item["User_ID"]!, Department_ID: item["Department_ID"]!, Customer_id: item["Customer_id"]!, Customer_place: item["Customer_place"]!, Lat: item["Lat"]!, Lan: item["Lan"]!, Customer_name: item["Customer_name"]!, Customer_Phone: item["Customer_Phone"]!))
                            }
                            print("list: \(self.Products)")
                            DispatchQueue.main.sync {
                                print("list count: \(self.Products.count)")
                                self.collectionView.reloadData()
                                self.saveProducts(products: self.Products)
                            }
                    }
                }
            }
        }
    }

    
    func saveProducts(products : [Product]){
        
        //delete previous products before save new ones
        clearPreviousProducts()
        
        for product in products {
            do{
                let productTable = ProductTable(context: appContext)
                productTable.productId = product.Product_ID
                productTable.productName = product.ProductName
                productTable.price = product.Price
                productTable.picture = product.picture
                productTable.customerName = product.Customer_name
                productTable.customerPhone = product.Customer_Phone
                
                appDel.saveContext()
                print("goood product saved")
                
            }
        }
    }

    func readLocalProducts(){
        let fetchRequest : NSFetchRequest<ProductTable>  = ProductTable.fetchRequest()
        do{
             SavedProducts = try appContext.fetch(fetchRequest)
            collectionView.reloadData()
            print("read products done")
        }catch{
            print("products not readen")
        }
    }
    
    func clearPreviousProducts(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductTable")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try appContext.execute(deleteRequest)
            try appContext.save()
            print("products deleted")
        } catch {
            print ("products not deleted")
        }
    }

}
