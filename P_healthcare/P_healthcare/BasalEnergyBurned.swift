//
//  BasalEnergyBurned.swift
//  P_healthcare
//
//  Created by 佐藤優希 on 2019/01/06.
//  Copyright © 2019 University of Aizu. All rights reserved.
//

import Foundation
import HealthKit

class BasalEnergyBurned{
    
    public func anchoredBasalEnergyBurned(completion: @escaping (HKQueryAnchor)-> Void){
        //データの種類(安静時エネルギー)
        let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.basalEnergyBurned)!
        //データの取得準備
        let healthstore = HKHealthStore()
        print(anchoredHealthData)
        let anchoredObjectQuery = HKAnchoredObjectQuery(type: type, predicate: nil, anchor: anchoredHealthData, limit: 0) { (query, newSamoles, deletedSamples, newAnchor, error) in
            completion(newAnchor!)
        }
        healthstore.execute(anchoredObjectQuery)
    }
    
    public func storeBasalEnergyBurned(anchor: HKQueryAnchor){
        print("安静時消費エネルギーを格納します")
        //UserDefaultsの参照
        let userDefaults = UserDefaults.standard
        //データの種類(安静時消費エネルギー)
        let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.basalEnergyBurned)!
        
        //データの取得準備
        let healthstore = HKHealthStore()
        
        let anchoredObjectQuery = HKAnchoredObjectQuery(type: type, predicate: nil, anchor: anchor, limit: 0) { (query, newSamples, deletedSamples, newAnchor, error) -> Void in
            
            guard let samples = newSamples as? [HKQuantitySample], let deleted = deletedSamples else {
                // Add proper error handling here...
                print("*** Unable to query for basal energy burned: \(String(describing: error?.localizedDescription)) ***")
                abort()
            }
            // Process the results...
            for sample in samples {
                
                // 取得したサンプルを単位に合わせる.
                let unit = HKUnit(from: "kcal")
                let ID = sample.uuid //HealthKitデータベースの一意な識別子
                //sourceName取得
                let sourceName = sample.sourceRevision.source.name
                //sourceVersion取得
                let sourceVersion = sample.sourceRevision.version!
                //デバイス名取得
                let devicename :String = (sample.device?.name!)!
                
                //デバイス情報（HKDevice,name,manufacture,model,hardware,software）
                var device = ""
                if(sample.device == nil){
                    device = "nil"
                }else{
                    device = String(describing: sample.device!)
                }
                //startDate情報
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS Z"
                let startdate = formatter.string(from: sample.startDate)
                let startdate_date = formatter.date(from: startdate)
                //startdate_dateをdata型からUnix時間に変換
                let startdate_unix = (startdate_date?.timeIntervalSince1970)! * 1000
                let startDate = "\\/Date(\(String(describing: Int(startdate_unix))))\\/"
                //endDate情報
                let enddate = formatter.string(from: sample.endDate)
                let enddate_date = formatter.date(from: enddate)
                let enddate_unix = (enddate_date?.timeIntervalSince1970)! * 1000
                let endDate = "\\/Date(\(String(describing: Int(enddate_unix))))\\/"
                
                //value取得
                let basalEnergyBurned = sample.quantity.doubleValue(for: unit)
                
                let contents = "{\"__id\": \"\(ID)\",\"type\": \"\(type)\",\"sourceName\": \"\(sourceName)\",\"sourceVersion\": \"\(sourceVersion)\",\"deviceName\": \"\(devicename)\",\"device\": \"\(device)\",\"unit\": \"\(unit)\",\"startDate\": \"\(startDate)\",\"endDate\": \"\(endDate)\",\"value\": \"\(basalEnergyBurned)\"}"
                print(contents)
                //boxApiというキーを指定して保存していた値を取り出す
                if let boxApiValue = userDefaults.string(forKey: "boxApi"){
                    boxApi = boxApiValue
                }
                let POST_url = NSURL(string: boxApi)
                var request = URLRequest(url: POST_url! as URL)
                let grant_typeData = contents.data(using: String.Encoding.utf8)
                request.httpMethod = "POST"
                request.httpBody = grant_typeData
                //accessTokenToStoreというキーを指定して保存していた値を取り出す
                if let accessTokenToStoreValue = userDefaults.string(forKey: "accessTokenToStore"){
                    accessTokenToStore = accessTokenToStoreValue
                }
                let authValue = "Bearer \(accessTokenToStore)"
                request.addValue(authValue, forHTTPHeaderField: "Authorization")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    guard error == nil && data != nil else {                                             // check for fundamental networking error
                        
                        return
                    }
                    
                    
                    // 受け取ったdataをJSONパース、エラーならcatchへジャンプ
                    do {
                        // dataをJSONパースし、変数"get_access_token"に格納
                        let get_access_token = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        print(get_access_token)
                        
                    } catch {
                        print ("json error")
                        return
                    }
                    
                })
                
                task.resume()
                
            }
            
            for deletedSample in deleted {
                
                print("deleted: \(deletedSample)")
            }
            
            anchoredHealthData = newAnchor!
            anchoredBEB = newAnchor!
            
        }
        
        healthstore.execute(anchoredObjectQuery)
    }
    
}
