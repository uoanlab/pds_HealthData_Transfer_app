//
//  ReadStatus.swift
//  P_healthcare
//
//  Created by 佐藤優希 on 2018/12/23.
//  Copyright © 2018 佐藤優希. All rights reserved.
//

import Foundation
import HealthKit

// anchoredHealthData: 最新のヘルスケアデータのアンカー
// 新規でヘルスケアデータを選択した時に、参照される。
var anchoredHealthData: HKQueryAnchor = HKQueryAnchor(fromValue:  Int(HKAnchoredObjectQueryNoAnchor))
var anchoredSC:HKQueryAnchor = HKQueryAnchor(fromValue:  Int(HKAnchoredObjectQueryNoAnchor))
var anchoredDWR:HKQueryAnchor = HKQueryAnchor(fromValue:  Int(HKAnchoredObjectQueryNoAnchor))
var anchoredAEB: HKQueryAnchor = HKQueryAnchor(fromValue:  Int(HKAnchoredObjectQueryNoAnchor))
var anchoredBEB: HKQueryAnchor = HKQueryAnchor(fromValue:  Int(HKAnchoredObjectQueryNoAnchor))
var anchoredHR: HKQueryAnchor = HKQueryAnchor(fromValue:  Int(HKAnchoredObjectQueryNoAnchor))
var anchoredRHR: HKQueryAnchor = HKQueryAnchor(fromValue:  Int(HKAnchoredObjectQueryNoAnchor))
var anchoredWHRA: HKQueryAnchor = HKQueryAnchor(fromValue:  Int(HKAnchoredObjectQueryNoAnchor))
var anchoredHRV: HKQueryAnchor = HKQueryAnchor(fromValue:  Int(HKAnchoredObjectQueryNoAnchor))


class ReadStatus{
    
    //UserDefaultsの参照
    let userDefaults = UserDefaults.standard
    
    public func authorizedStatus(){
        let healthStore = HKHealthStore()
        let typeOfRead = [
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned),
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.basalEnergyBurned),
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount),
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning),
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate),
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.restingHeartRate),
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.walkingHeartRateAverage),
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRateVariabilitySDNN),
            ]
        let typeOfReads = NSSet(array: typeOfRead as [Any])
        
        healthStore.requestAuthorization(toShare: nil, read: typeOfReads as? Set<HKObjectType>) { (success, error) in
            if success {
                print("success!!")
                //UserDefaultsの参照
                let userDefaults = UserDefaults.standard
                //他の種類
                
                var updateRefreshToken = ""
                var userCell = ""
                var appCell = ""
                //userCellというキーを指定して保存していた値を取り出す
                if let userCellUrl = userDefaults.string(forKey: "userCell"){
                    userCell = userCellUrl
                }
                //appCellというキーを指定して保存していた値を取り出す
                if let appCellUrl = userDefaults.string(forKey: "appCell"){
                    appCell = appCellUrl
                }
                //refreshTokenというキーを指定して保存していた値を取り出す
                if let refreshToken = userDefaults.string(forKey: "refreshToken"){
                    updateRefreshToken = refreshToken
                }
                print("userCell : \(userCell)")
                print("appCell : \(appCell)")
                print("updateRefreshToken : \(updateRefreshToken)")
                
                AuthPersonium().getToken(userCellUrl: userCell, appCellUrl: appCell, refreshToken: updateRefreshToken)
                sleep(2)
                
                if(anchoredHealthData.isEqual(HKQueryAnchor(fromValue:  Int(HKAnchoredObjectQueryNoAnchor)))){
                    
                    if(anchoredSC.isEqual(HKQueryAnchor(fromValue:  Int(HKAnchoredObjectQueryNoAnchor)))){
                        StepCount().anchoredStepCount(completion: { (anchor) in
//                            let Anchor = HKQueryAnchor(fromValue: 565000)
                            anchoredHealthData = anchor
//                            anchoredHealthData = Anchor
//                            self.userDefaults.set(anchoredHealthData, forKey: "anchoredHealthData")
                            anchoredSC = anchor
//                            anchoredSC = Anchor
                            
                            print("anchoredStepCount\(anchoredSC)")
                        })
                    }else if(anchoredDWR.isEqual(HKQueryAnchor(fromValue:  Int(HKAnchoredObjectQueryNoAnchor)))){
                        DistanceWalkingRunning().anchoredDistWalkingRunning(completion: { (anchor) in
                            anchoredHealthData = anchor
                            anchoredDWR = anchor
                            print("anchoredDistWalkingRunning\(anchoredDWR)")
                        })
                    }else if(anchoredBEB.isEqual(HKQueryAnchor(fromValue:  Int(HKAnchoredObjectQueryNoAnchor)))){
                        BasalEnergyBurned().anchoredBasalEnergyBurned(completion: { (anchor) in
                            anchoredHealthData = anchor
                            anchoredBEB = anchor
                        })
                    }else if(anchoredHR.isEqual(HKQueryAnchor(fromValue:  Int(HKAnchoredObjectQueryNoAnchor)))){
                        HeartRate().anchoredHeartRate(completion: { (anchor) in
                            anchoredHealthData = anchor
                            anchoredHR = anchor
                        })
                    }else if(anchoredRHR.isEqual(HKQueryAnchor(fromValue:  Int(HKAnchoredObjectQueryNoAnchor)))){
                        RestingHeartRate().anchoredRestingHeartRate(completion: { (anchor) in
                            anchoredHealthData = anchor
                            anchoredRHR = anchor
                        })
                    }else if(anchoredWHRA.isEqual(HKQueryAnchor(fromValue:  Int(HKAnchoredObjectQueryNoAnchor)))){
                        WalkingHeartRateAverage().anchoredWalkingHeartRateAverage(completion: { (anchor) in
                            anchoredHealthData = anchor
                            anchoredWHRA = anchor
                        })
                    }else if(anchoredHRV.isEqual(HKQueryAnchor(fromValue:  Int(HKAnchoredObjectQueryNoAnchor)))){
                        HeartRateVariability().anchoredHeartRateVariability(completion: { (anchor) in
                            anchoredHealthData = anchor
                            anchoredHRV = anchor
                        })
                    }else if(anchoredAEB.isEqual(HKQueryAnchor(fromValue:  Int(HKAnchoredObjectQueryNoAnchor)))){
                        ActiveEnergyBurned().anchoredActiveEnergyBurned(completion: { (anchor) in
                            anchoredHealthData = anchor
                            anchoredAEB = anchor
                            print("anchoredActiveEnergyBurned\(anchoredAEB)")
                        })
                    }else{
                        print("何も許可されていません")
                        anchoredHealthData = HKQueryAnchor(fromValue:  Int(HKAnchoredObjectQueryNoAnchor))
                    }
                    
                }else{
                    //歩数
                    if(anchoredSC.isEqual(HKQueryAnchor(fromValue:  Int(HKAnchoredObjectQueryNoAnchor)))){
                        StepCount().storeStepCount(anchor: anchoredHealthData)
                    }else{
                        StepCount().storeStepCount(anchor: anchoredSC)
                    }
                    //走行距離
                    if(anchoredDWR.isEqual(HKQueryAnchor(fromValue:  Int(HKAnchoredObjectQueryNoAnchor)))){
                        DistanceWalkingRunning().storeDistWalkingRunning(anchor: anchoredHealthData)
                    }else{
                        DistanceWalkingRunning().storeDistWalkingRunning(anchor: anchoredDWR)
                    }
                    //安静時エネルギー
                    if(anchoredBEB.isEqual(HKQueryAnchor(fromValue:  Int(HKAnchoredObjectQueryNoAnchor)))){
                        BasalEnergyBurned().storeBasalEnergyBurned(anchor: anchoredHealthData)
                    }else{
                        BasalEnergyBurned().storeBasalEnergyBurned(anchor: anchoredBEB)
                    }
                    //心拍数
                    if(anchoredHR.isEqual(HKQueryAnchor(fromValue:  Int(HKAnchoredObjectQueryNoAnchor)))){
                        HeartRate().storeHeartRate(anchor: anchoredHealthData)
                    }else{
                        HeartRate().storeHeartRate(anchor: anchoredHR)
                    }
                    //安静時心拍数
                    if(anchoredRHR.isEqual(HKQueryAnchor(fromValue:  Int(HKAnchoredObjectQueryNoAnchor)))){
                        RestingHeartRate().storeRestingHeartRate(anchor: anchoredHealthData)
                    }else{
                        RestingHeartRate().storeRestingHeartRate(anchor: anchoredRHR)
                    }
                    //歩行時平均心拍数
                    if(anchoredWHRA.isEqual(HKQueryAnchor(fromValue:  Int(HKAnchoredObjectQueryNoAnchor)))){
                        WalkingHeartRateAverage().storeWalkingHeartRateAverage(anchor: anchoredHealthData)
                    }else{
                        WalkingHeartRateAverage().storeWalkingHeartRateAverage(anchor: anchoredWHRA)
                    }
                    //心拍変動
                    if(anchoredHRV.isEqual(HKQueryAnchor(fromValue:  Int(HKAnchoredObjectQueryNoAnchor)))){
                        HeartRateVariability().storeHeartRateVariability(anchor: anchoredHealthData)
                    }else{
                        HeartRateVariability().storeHeartRateVariability(anchor: anchoredHRV)
                    }
                    //アクティブエネルギー
                    if(anchoredAEB.isEqual(HKQueryAnchor(fromValue:  Int(HKAnchoredObjectQueryNoAnchor)))){
                        ActiveEnergyBurned().storeActiveEnergyBurned(anchor: anchoredHealthData)
                    }else{
                        ActiveEnergyBurned().storeActiveEnergyBurned(anchor: anchoredAEB)
                    }
                }
                
            } else {
                print(error.debugDescription)
                
            }
        }
        
    }
}
