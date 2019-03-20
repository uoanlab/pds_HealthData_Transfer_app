//
//  LoginViewController.swift
//  P_healthcare
//
//  Created by 佐藤優希 on 2019/01/24.
//  Copyright © 2019 佐藤優希. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {

    var window: UIWindow?
    
    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // textFiel の情報を受け取るための delegate を設定
        id.delegate = self
        password.delegate = self
        
        // Do any additional setup after loading the view.
        let userDefaults = UserDefaults.standard
        if let idValue = userDefaults.string(forKey: "inputId"){
            id.text = idValue
        }
        if let passwordValue = userDefaults.string(forKey: "inputPassword"){
            password.text = passwordValue
        }
        
    }
    //TextFieldのキーボードを閉じる方法：Returnキー押下で閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        id.resignFirstResponder()
        password.resignFirstResponder()
        return true
    }
    //TextFieldのキーボードを閉じる方法：TextField以外をタップして閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        id.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(id.text, forKey: "inputId")
        userDefaults.set(password.text, forKey: "inputPassword")
        userDefaults.synchronize()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // 0.5秒後に実行したい処理
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "navigationView")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
    }
    


}
