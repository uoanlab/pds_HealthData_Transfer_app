//
//  NotificationSettingViewController.swift
//  P_healthcare
//
//  Created by 佐藤優希 on 2018/12/18.
//  Copyright © 2019 University of Aizu. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationSettingViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapNotificationSetting(_ sender: UIButton) {
        let center = UNUserNotificationCenter.current()
        
        
        let date = datePicker.date
        
        let calendar = Calendar.current
        
        let dateComponents = calendar.dateComponents([.hour, .minute], from: date)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(dateComponents.hour! * 3600 + dateComponents.minute! * 60), repeats: true)
        
        let identifier = "HealthCareDataNotification"
        
        let content = UNMutableNotificationContent()
        
        content.title = NSString.localizedUserNotificationString(forKey: "personium_HealthCare", arguments: nil)
        
        content.body = NSString.localizedUserNotificationString(forKey: "Personiumにヘルスケアデータを格納する時間になりました", arguments: nil)
        
        content.sound = UNNotificationSound.default
        
        // categoryIdentifierを設定
        content.categoryIdentifier = "message"
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: nil)
        
        let controller: UIAlertController
        
        if(dateComponents.hour! == 0){
            controller = UIAlertController(title: nil, message: "\(dateComponents.minute!)分毎に通知する設定を行いました", preferredStyle: UIAlertController.Style.alert)
        }else {
            controller = UIAlertController(title: nil, message: "\(dateComponents.hour!)時\(dateComponents.minute!)分毎に通知する設定を行いました", preferredStyle: UIAlertController.Style.alert)
        }
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action: UIAlertAction!) in
            //アラートが消えるのと画面遷移が重ならないように0.5秒後に画面遷移するようにしてる
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // 0.5秒後に実行したい処理
                //まずは、同じstororyboard内であることをここで定義します
                let storyboard: UIStoryboard = self.storyboard!
                //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
                let first = storyboard.instantiateViewController(withIdentifier: "homeView")
                //ここが実際に移動するコードとなります
                self.present(first, animated: true, completion: nil)
            }
        }
        
        controller.addAction(okAction)
        self.present(controller, animated: false, completion: nil)

    }

}
