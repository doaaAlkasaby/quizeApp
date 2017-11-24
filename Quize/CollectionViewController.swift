//
//  GridViewController.swift
//  Quize
//
//  Created by Doaa Alkasaby on 11/11/17.
//  Copyright © 2017 Elryad. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON

class CollectionViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout{

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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth =  (collectionView.bounds.size.width/2) - 5
        print("itemWidth : ", itemWidth)

        return CGSize(width: itemWidth, height:180)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("numberOfItemsInSection: \(Products.count)")
        if localOrRemote == "local" {
            print("locale\(Products.count)")
            return SavedProducts.count

        }else {
            print("remote\(Products.count)")
            return Products.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cellForItemAt")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionViewCell
        
        if localOrRemote == "local" {
            print("show ","local")
            cell.nameTV.text! = SavedProducts[indexPath.row].productName!
            cell.priceTV.text! = SavedProducts[indexPath.row].price!
            cell.customerNameTV.text! = SavedProducts[indexPath.row].customerName!
            cell.customerPhoneTV.text! = SavedProducts[indexPath.row].customerPhone!
            let imageLink = SavedProducts[indexPath.row].picture!
            cell.setItemImage(imgUrl: imageLink)
            //set item rate value as its cell numer as a temporary value
            cell.setItemRating(rateValue: indexPath.row + 1)
        }else {
            print("show ","REMOTE")
            cell.nameTV.text! = Products[indexPath.row].ProductName!
            cell.priceTV.text! = Products[indexPath.row].Price!
            cell.customerNameTV.text! = Products[indexPath.row].Customer_name!
            cell.customerPhoneTV.text! = Products[indexPath.row].Customer_Phone!
            cell.setItemImage(imgUrl: Products[indexPath.row].picture!)
            //set item rate value as its cell numer as a temporary value
            cell.setItemRating(rateValue: indexPath.row + 1)
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
        if let dist = segue.destination as? MapDirectionViewController {
            print("step1")
            let lat = Double((sender as! Product).Lat!)
            let long = Double((sender as! Product).Lan!)
            dist.setDestinationDim(lat: lat!, long: long!)
        }else if let dist = segue.destination as? ListViewController {
            dist.Products = Products
        }
    }
//-----------
    func readRemoteProducts(){

        Alamofire.request(productUrl, method: .get).responseJSON { response in
           
            let json = JSON(response.result.value!)
            print("swiftyJsonVar: \(json)")
            
            let products = json.array
            for item in products! {
                let imgLink = "http://maraselksa.com/WebServices/images/"+item["picture"].string!
                self.Products.append(Product(Order_ID: item["Order_ID"].string!, Product_ID: item["Product_ID"].string!, ProductName: item["ProductName"].string!, picture: imgLink, Quantatiy: item["Quantatiy"].string!, Price: item["Price"].string!, User_ID: item["User_ID"].string!, Department_ID: item["Department_ID"].string!, Customer_id: item["Customer_id"].string!, Customer_place: item["Customer_place"].string!, Lat: item["Lat"].string!, Lan: item["Lan"].string!, Customer_name: item["Customer_name"].string!, Customer_Phone: item["Customer_Phone"].string!))
            }
            
            self.collectionView.reloadData()
            self.saveProducts(products: self.Products)
            
            print("list: \(self.Products)")
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
               // print("goood product saved")
                
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
