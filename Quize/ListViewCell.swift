//
//  ListViewCell.swift
//  Quize
//
//  Created by Doaa Alkasaby on 11/11/17.
//  Copyright © 2017 Elryad. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ListViewCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameTV: UILabel!
    @IBOutlet weak var priceTV: UILabel!
    @IBOutlet weak var customerNameTV: UILabel!
    @IBOutlet weak var customerPhoneTV: UILabel!    
    @IBOutlet var starsCollection: [UIButton]!
    
    var imageChache = NSCache<NSString, UIImage>() //[String : UIImage]()
    
    func setItemImage(imgUrl : String){

        Alamofire.request(imgUrl).responseImage { response in
            
            if let image = response.result.value {
                print("image downloaded: \(image)")
                self.imgView.image = image
                self.imgView.layer.cornerRadius = self.imgView.frame.height/2;
                self.imgView.clipsToBounds = true
            }
        }
    }
    
    func setItemRating(rateValue : Int){
        for index in stride(from : 0 ,to: rateValue, by: 1) {
            starsCollection[index].setTitle("★", for:  UIControlState.normal)
            starsCollection[index].setTitleColor(UIColor.yellow, for: UIControlState.normal)
            
        }
        print("rate func")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
