//
//  AuthPersonium.swift
//  P_healthcare
//
//  Created by 佐藤優希 on 2018/12/22.
//  Copyright © 2018 佐藤優希. All rights reserved.
//

import Foundation

var boxApi: String = ""
var accessTokenToStore: String = ""

class AuthPersonium{
    //UserDefaultsの参照
    let userDefaults = UserDefaults.standard
    
    
    public func startAuth(url: URL){
        let data=url.fragment!
        let array_data = data.components(separatedBy: "&")
        var userCellUrl = array_data[0].components(separatedBy: "=")//user_cell_url[1]:UserCellのurlを取得
        var refreshToken = array_data[1].components(separatedBy: "=")//refresh_token[1]:refreshtokenを取得
        let appCellUrl: String = "https://app-aizu-health-store.demo.personium.io/"
        //userCellというキーで値を保存する
        self.userDefaults.set(userCellUrl[1], forKey: "userCell")
        //refreshTokenというキーで値を保存する
        self.userDefaults.set(refreshToken[1], forKey: "refreshToken")
        //appcellUrlというキーで値を保存する
        self.userDefaults.set(appCellUrl, forKey: "appCell")
        
        getToken(userCellUrl: userCellUrl[1], appCellUrl: appCellUrl, refreshToken: refreshToken[1])
    }
    
    public func getToken(userCellUrl: String,appCellUrl: String, refreshToken:String){
        
        let odataCollecitonName: String = "OData"
        let entityTypeName: String = "HealthRecord"
        
        self.getAppAuthToken(userCellUrl: userCellUrl, appCellUrl: appCellUrl, completion: {appAccessToken in
            
            self.getProtectedboxAccessToken(refreshToken: refreshToken, clientId: appCellUrl, clientSecret: appAccessToken, userCellUrl: userCellUrl, completion:{ userAccessToken in
                
                self.getBoxUrl(userCellUrl: userCellUrl, accessToken: userAccessToken, completion: {location in
                    let boxUrl = location + odataCollecitonName + "/" + entityTypeName
                    print(boxUrl)
                    boxApi = boxUrl
                    //boxApiというキーで値を保存する
                    self.userDefaults.set(boxApi, forKey: "boxApi")
                    //UserDefaultsへの値の保存を明示的に行う
                    self.userDefaults.synchronize()
                    print(boxUrl)
                })
                
            })
            
        })
    }
    
    // Get App Authentication Token
    public func getAppAuthToken(userCellUrl:String, appCellUrl:String, completion: @escaping (String)-> Void){
        //apiエンドポイント
        let engineEndPoint : String = "__/html/Engine/getAppAuthToken"
        let api = URL(string: appCellUrl + engineEndPoint)
        var request = URLRequest(url: api!)
        //method
        request.httpMethod = "POST"
        //requestBody
        let p_target = "p_target=\(userCellUrl)"
        request.httpBody = p_target.data(using: String.Encoding.utf8)
        //HTTPヘッダをセット
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("true", forHTTPHeaderField: "x-personium-cors")
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
            guard let data = data else { return }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("response = \(String(describing: response))")
            }
            do {
                let object = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                let accessToken = (object["access_token"] as? String)!
                print("accessToken   \(accessToken)")
                completion(accessToken)
            } catch let e {
                print(e)
            }
        }).resume()
    }
    
    
    public func getProtectedboxAccessToken(refreshToken: String, clientId: String, clientSecret: String, userCellUrl: String, completion: @escaping (String)-> Void){
        //apiエンドポイント
        let api = URL(string: userCellUrl + "__token")
        var request = URLRequest(url: api!)
        //method
        request.httpMethod = "POST"
        //requestBody
        let grantType: String = "grant_type=refresh_token&refresh_token=\(refreshToken)&client_id=\(clientId)&client_secret=\(clientSecret)"
        request.httpBody = grantType.data(using: String.Encoding.utf8)
        //HTTPヘッダをセット
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
            guard let data = data else { return }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("response = \(String(describing: response))")
            }
            do {
                let object = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                let getRefreshTokenUserUpdate = (object["refresh_token"] as? String)!
                //refreshTokenというキーで値を保存する
                self.userDefaults.set(getRefreshTokenUserUpdate, forKey: "refreshToken")
                let getUserAccessToken = (object["access_token"] as? String)!
                completion(getUserAccessToken)
            } catch let e {
                print(e)
            }
        }).resume()
    }
    
    public func getBoxUrl(userCellUrl: String, accessToken: String, completion: @escaping (String)-> Void){
        //apiエンドポイント
        let api = URL(string: userCellUrl + "__box")
        var request = URLRequest(url: api!)
        //method
        request.httpMethod = "GET"
        //HTTPヘッダをセット
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let authValue = "Bearer \(accessToken)"
        accessTokenToStore = accessToken
        //accessTokenToStoreというキーで値を保存する
        userDefaults.set(accessTokenToStore, forKey: "accessTokenToStore")
//        print("accessTokenToStore:  \(accessToken)")
        request.addValue(authValue, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            guard error == nil && data != nil else {
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
                if let httpResponse = response as? HTTPURLResponse {
                    let headers:NSDictionary = httpResponse.allHeaderFields as NSDictionary
                    for obj in headers{
                        if(String(describing: obj.key) == "Location"){
                            let location = String(describing: obj.value)
                            completion(location)
                        }
                    }
                }
            }
        }).resume()
        
    }
    
    
    public func getUpdateRefreshToken(){
        var cellUrl:String = ""
        var username:String = ""
        var passwd:String = ""
        //UserDefaultsの参照
        let userDefaults = UserDefaults.standard
        
        if let idValue = userDefaults.string(forKey: "inputId"){
            username = idValue
        }
        if let passwordValue = userDefaults.string(forKey: "inputPassword"){
            passwd = passwordValue
        }
        
        //userCellというキーを指定して保存していた値を取り出す
        if let userCellUrl = userDefaults.string(forKey: "userCell"){
            cellUrl = userCellUrl
        }
        let engineEndPoint: String = "__token"
        let api = URL(string: cellUrl + engineEndPoint)
        var request = URLRequest(url: api!)
        request.httpMethod = "POST"
        let grant_type = "grant_type=password&username=\(String(describing: username))&password=\(String(describing: passwd))"
        print(grant_type)
        request.httpBody = grant_type.data(using: .utf8)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
            guard let data = data else { return }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("response = \(String(describing: response))")
            }
            do {
                let object = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                let refreshToken = (object["refresh_token"] as? String)!
                //refreshTokenというキーで値を保存する
                userDefaults.set(refreshToken, forKey: "refreshToken")
                //UserDefaultsへの値の保存を明示的に行う
                userDefaults.synchronize()
                print("func : getUpdateRefreshToken = \(refreshToken)")
            } catch let e {
                print(e)
            }
        }).resume()
        
    }
    
}
