//
//  GTimer.swift
//  FastPaySDKTest
//
//  Created by Ainul Kazi on 21/7/22.
//

import UIKit


class GTimer: NSObject {

    static let sharedTimer: GTimer = GTimer()
    static let timerName = NSNotification.Name("com.user.requestTimeOut")
    var internalTimer = Timer()
    var numberOfTimesFired = 0
    var recentReducedAmount = 0
    var isRequestTimeOut:Bool = false

    func startTimer(timeOut : Int){
        self.internalTimer.invalidate()
        self.internalTimer = Timer.scheduledTimer(timeInterval: 1.0 /*seconds*/, target: self, selector: #selector(fireTimerAction), userInfo: nil, repeats: true)
        self.numberOfTimesFired = timeOut
    }
    
    func reduceSecond(_ seconds:Int) {
        if seconds != recentReducedAmount{
            numberOfTimesFired = numberOfTimesFired - seconds
            recentReducedAmount = seconds
        }
    }

    func stopTimer(){
        self.internalTimer.invalidate()
    }

    @objc func fireTimerAction(sender: AnyObject?){
        if numberOfTimesFired > 0{
            numberOfTimesFired -= 1
        }else{
            self.internalTimer.invalidate()
            postRequestTimeoutNotification()
        }
       // debugPrint("Remaining Seconds to Request Timeout \(numberOfTimesFired)")
    }
    
    func postRequestTimeoutNotification() {
        NotificationCenter.default
            .post(name:GTimer.timerName,
                  object: nil)
        GTimer.sharedTimer.isRequestTimeOut = true
    }

}
