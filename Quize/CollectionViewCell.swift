//
//  CollectionViewCell.swift
//  Quize
//
//  Created by Doaa Alkasaby on 11/11/17.
//  Copyright © 2017 Elryad. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var priceTV: UILabel!
    @IBOutlet weak var nameTV: UILabel!
    @IBOutlet weak var customerPhoneTV: UILabel!
    @IBOutlet weak var customerNameTV: UILabel!
    
    var imageChache = NSCache<NSString, UIImage>()
    
    func setItemImage(imgUrl : String){
        print("imageLink : \(imgUrl)")
        if let cachedImg = imageChache.object(forKey: (imgUrl as? NSString)!){ //if image cached before
            imgView.image = cachedImg
        }else{
            DispatchQueue.global().async {
                do {
                    
                    let url = URL(string: imgUrl)!
                    let jsonData = try! Data(contentsOf: url)
                    
                    let img = UIImage(data: jsonData)
                    //if image not cached cache it
                self.imageChache.setObject(img!, forKey: imgUrl as NSString)
                    
                    DispatchQueue.main.sync {
                        self.imgView.image = img
                    }
                    
                }
            }
        }
    }
}
