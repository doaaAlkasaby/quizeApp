//
//  ViewController.swift
//  Quize
//
//  Created by Doaa Alkasaby on 11/11/17.
//  Copyright © 2017 Elryad. All rights reserved.
//

import UIKit
import SystemConfiguration
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {

    let testApi = "http://qtech-system.com/interview/index.php/apis/testApi"
    let loginApi = "http://maraselksa.com/WebServices/User/Login.php"
    
    var userName : String?
    var password : String?
    
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //initialize textfields
        usernameTF.addTarget(self, action:#selector(usernameChanged), for: UIControlEvents.editingChanged)
        passwordTF.addTarget(self, action:#selector(passwordChanged), for: UIControlEvents.editingChanged)

    
        // border color
        let borderColor = UIColor(red: 0, green: 255, blue: 255, alpha: 1)
        usernameTF.borderStyle = UITextBorderStyle.line
        passwordTF.borderStyle = UITextBorderStyle.line
        usernameTF.layer.borderColor = borderColor.cgColor
        passwordTF.layer.borderColor = borderColor.cgColor
        usernameTF.layer.borderWidth = 2
        passwordTF.layer.borderWidth = 2
        
        
        //login button will be disabled at initial
        loginBtn.isEnabled =  false;
    }

    
    @objc func usernameChanged(_ textField: UITextField){
        checkInputData()
    }
     @objc func passwordChanged(_ textField: UITextField){
        checkInputData()
    }
    
    func checkInputData(){
        if((usernameTF.text?.isEmpty)! || (passwordTF.text?.isEmpty)!){
            loginBtn.isEnabled = false
        }else{
            loginBtn.isEnabled = true
        }
    }

    @IBAction func handleLogin(_ sender: Any) {
        userName = usernameTF.text!
        password = passwordTF.text!
        
        if Reachability .isConnectedToNetwork(){
            print("Internet Connection Available!")
            self.handleTestApi()
        }else{
            print("Internet Connection not Available!")
            let alert = UIAlertController(title: "Network Offline", message: "you don't have an internet access. please,check you internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func handleLoginApi(){
        
        let params = ["Name" :self.userName!, "Password" : self.password!] //"Name=Yasser&Password=123456s"
        
        Alamofire.request(loginApi, method: .post, parameters: params).responseJSON { response in
            print("Request  \(response.request!)")
            print("RESPONSE \(response.result.value!)")
            
            let json = JSON(response.result.value!)
            print("swiftyJsonVar: \(json)")
            let success = json["success"]

                if(success == true){
                    //save login data
                    
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(true, forKey: "login")
                    userDefaults.set(json["id"] .int!, forKey: "id")
                    userDefaults.set(json["Email"].string!, forKey: "email")
                    userDefaults.set(json["Name"].string!, forKey: "name")
                    userDefaults.set(json["Password"].string!, forKey: "password")
                    userDefaults.set(json["Phone"].string!, forKey: "phone")
                    userDefaults.synchronize()

                    //open next page
                    self.performSegue(withIdentifier: "OrdersSegue", sender: self)
                }else{
                    let alert = UIAlertController(title: "Login Failed", message: "your data may be in correct. try again", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }

        }
    }
    
   
    func handleTestApi() {
    
        let params = ["un":"userName", "up":"userPassword"]

        Alamofire.request(testApi, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"Application/json"]).responseJSON { response in
            print("Request  \(response.request!)")
            print("RESPONSE \(response.result.value!)")
            
            let json = JSON(response.result.value!)
            print("swiftyJsonVar: \(json)")
            if(json["status"] == "success"){
                self.handleLoginApi()
            }
        }
    }
   
}

