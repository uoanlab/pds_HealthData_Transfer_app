//
//  SettingsTableViewController.swift
//  P_healthcare
//
//  Created by 佐藤優希 on 2018/12/17.
//  Copyright © 2019 University of Aizu. All rights reserved.
//

import UIKit
import UserNotifications


class SettingsTableViewController: UITableViewController {


    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0: // 「ヘルスケアデータ」のセクション
            return 1
        case 1: // 「通知」のセクション
            return 1
        default: // ここが実行されることはない
            return 0
        }
        
    }
    
    //テーブルビューセルがタップされた時の動作
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0: // 「ヘルスケアデータ」のセクション
            
            if let url = URL(string:"x-apple-health://") {
                if #available(iOS 10.0, *) {
                    DispatchQueue.main.async(execute: {
                        UIApplication.shared.open(url, options: [:], completionHandler: { result in
                            print(result) // → true
                        })
                    })
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        
        case 1: // 「通知」のセクション
            //通知不許可のとき、呼び出される
            let center = UNUserNotificationCenter.current()
            center.getNotificationSettings { (setting) in
                if setting.authorizationStatus == .denied{
                    // OSの通知設定画面へ遷移
                    if let url = URL(string:UIApplication.openSettingsURLString) {
                        if #available(iOS 10.0, *) {
                            DispatchQueue.main.async(execute: {
                                UIApplication.shared.open(url, options: [:], completionHandler: { result in
                                    print(result) // → true
                                })
                            })
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                }
            }
            
        default:
            break
        }
    }
    
    @IBAction func tapRefreshButton(_ sender: Any) {
        print("refreshボタンが押されました。")
        //Personiumに格納するヘルスケアデータを選択&格納
        ReadStatus().authorizedStatus()
    }

}
