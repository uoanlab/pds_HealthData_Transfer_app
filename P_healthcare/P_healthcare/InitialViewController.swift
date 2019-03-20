//
//  InitialViewController.swift
//  P_healthcare
//
//  Created by 佐藤優希 on 2019/01/24.
//  Copyright © 2019 佐藤優希. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            // 5秒後に実行したい処理
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginView")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
        
    }
    

}
