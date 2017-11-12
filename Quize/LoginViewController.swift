//
//  ViewController.swift
//  Quize
//
//  Created by Doaa Alkasaby on 11/11/17.
//  Copyright © 2017 Elryad. All rights reserved.
//

import UIKit
import SystemConfiguration

class LoginViewController: UIViewController {

    let testApi = "http://qtech-system.com/interview/index.php/apis/testApi"
    let loginApi = "http://maraselksa.com/WebServices/User/Login.php"
    
    var userName : String?
    var password : String?
    
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    

    override func viewDidAppear(_ animated: Bool) {
        let loginBefore = UserDefaults.standard.object(forKey: "login") as? Bool
                //print("login before", loginBefore!)
        
        if(loginBefore != nil){
                if(loginBefore!){
                    //open next page
                    print("logged")
                    self.performSegue(withIdentifier: "OrdersSegue", sender: self)
                }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        //initialize textfields
        usernameTF.addTarget(self, action:#selector(usernameChanged), for: UIControlEvents.editingChanged)
        passwordTF.addTarget(self, action:#selector(passwordChanged), for: UIControlEvents.editingChanged)

        //
        // Solid color
        let borderColor = UIColor.green
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func handleLogin(){
       
        DispatchQueue.global().async {
            do {
        let url = URL(string: self.loginApi)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
                let postString = "Name=\(self.userName!)&Password=\(self.password!)"
                //"Name=Yasser&Password=123456s"  //"id=13&name=Jack"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString!)")
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                                    if let jsonDictionary = json as? [String: Any] {
                                        let success = jsonDictionary["success"] as? Bool
                                        print("success",success ?? false)
                                        DispatchQueue.main.sync {
                                        if(success!){
                                            //save login data
                                            let userDefaults = UserDefaults.standard
                                            userDefaults.set(true, forKey: "login")
                                            userDefaults.set(jsonDictionary["id"] as? Int, forKey: "id")
                                            userDefaults.set(jsonDictionary["Email"]!, forKey: "email")
                                            userDefaults.set(jsonDictionary["Name"]!, forKey: "name")
                                            userDefaults.set(jsonDictionary["Password"]!, forKey: "password")
                                            userDefaults.set(jsonDictionary["Phone"]!, forKey: "phone")
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
                
                                }
        }
        task.resume()
                
            }
        }
    }
    func handleTestApi() {
        
        var request = URLRequest(url:URL(string:testApi)!)
        request.httpMethod = "POST"
        
        let params = ["un":"userName", "up":"userPassword"]
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task=URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            if let safeData = data{
                print("response: \(String(describing: String(data:safeData, encoding:.utf8)!))")
                if let json = try? JSONSerialization.jsonObject(with: safeData, options: []) {
                                        if let jsonDictionary = json as? [String: String] {
                                            let status = jsonDictionary["status"]!
                                            print("status",status)
                                            if(status == "success"){
                                                self.handleLogin()
                                            }
                    }
                    
                }
            }
        }
        task.resume()
    }
   
}

