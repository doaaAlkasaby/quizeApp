//
//  Order.swift
//  Quize
//
//  Created by Doaa Alkasaby on 11/11/17.
//  Copyright © 2017 Elryad. All rights reserved.
//

import Foundation
class Product {
    
    var Order_ID: String?
    var Product_ID: String?
    var ProductName: String?
    var picture:  String?
    var Quantatiy:  String?
    var Price:  String?
    var User_ID:  String?
    var Department_ID:  String?
    var Customer_id:  String?
    var Customer_place:  String?
    var Lat:  String?
    var Lan:  String?
    var Customer_name:  String?
    var Customer_Phone:  String?
    
    init( Order_ID: String,
    Product_ID:  String,
    ProductName:  String,
    picture:  String,
    Quantatiy:  String,
    Price:  String,
    User_ID:  String,
    Department_ID:  String,
    Customer_id:  String,
    Customer_place:  String,
    Lat:  String,
    Lan:  String,
    Customer_name:  String,
        Customer_Phone:  String){
        
        self.Order_ID  = Order_ID
       self.Product_ID = Product_ID
        self.ProductName = ProductName
        self.picture = picture
        self.Quantatiy = Quantatiy
        self.Price = Price
        self.User_ID = User_ID
        self.Department_ID = Department_ID
        self.Customer_id = Customer_id
        self.Customer_place = Customer_place
        self.Lat = Lat
        self.Lan = Lan
        self.Customer_name = Customer_name
        self.Customer_Phone = Customer_Phone
    }
        
    
}
