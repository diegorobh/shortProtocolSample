//
//  UserController.swift
//  protocol_test
//
//  Created by diego paredes on 18/11/19.
//  Copyright © 2019 Diego Paredes. All rights reserved.
//

import Foundation

protocol UserControllerLogin{
    func successLoginDelegate(data:ResponseLogin)
    func errorLoginDelegate()
}

class UserController{
    var email = ""
    var password = ""
    var delegateLogin:UserControllerLogin?

    func doLogin(){
        let parameters = ["email":email, "password":password, "linkFirebaseToken": false] as [String : Any]
        
        WTRequest.shared.post(url: "http://dev.delimsys.com/login", accesstoken: "", type: ResponseLogin.self, parameters: parameters, completion: {(responseLogin,statusCode) in
            switch responseLogin {
            case .success(let responseLogin):
                print("status code from controller \(statusCode)")
                print("response data from controller \(responseLogin)")
                self.successLogin(data:responseLogin)
                break
            case .failure(let error):
                self.errorLogin()
                print(error.errorDescription)
            }
        })
        
    }
    
    func successLogin(data:ResponseLogin){
        delegateLogin?.successLoginDelegate(data:data)
    }
    func errorLogin(){
        delegateLogin?.errorLoginDelegate()
    }
    
}
