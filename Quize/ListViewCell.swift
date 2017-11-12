//
//  ListViewCell.swift
//  Quize
//
//  Created by Doaa Alkasaby on 11/11/17.
//  Copyright © 2017 Elryad. All rights reserved.
//

import UIKit

class ListViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameTV: UILabel!
    @IBOutlet weak var priceTV: UILabel!
    @IBOutlet weak var customerNameTV: UILabel!
    @IBOutlet weak var customerPhoneTV: UILabel!
    
    var imageChache = NSCache<NSString, UIImage>() //[String : UIImage]()
    
    func setItemImage(imgUrl : String){
        
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
