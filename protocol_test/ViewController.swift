//
//  ViewController.swift
//  protocol_test
//
//  Created by diego paredes on 18/11/19.
//  Copyright © 2019 Diego Paredes. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UserControllerLogin {
    func successLoginDelegate(data:ResponseLogin) {
        successLogin(data: data)
    }
    func errorLoginDelegate() {
        errorLogin()
    }
    
    @IBOutlet weak var emailTfd: UITextField!
    @IBOutlet weak var passTfd: UITextField!
    
    var userController = UserController()

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTfd.text = "guest@delimsys.com"
        passTfd.text = "asdf1qwer2019!"
        userController.delegateLogin = self
    }

    @IBAction func loginAction(_ sender: Any) {
        doLogin()
    }
    
    func doLogin(){
        userController.email = emailTfd.text!
        userController.password = passTfd.text!
        userController.doLogin()
    }
    
    func successLogin(data:ResponseLogin){
        print("good response")
        print(data)
        print("above the data")
    }
    
    func errorLogin(){
        print("bad response")
    }
    
}

