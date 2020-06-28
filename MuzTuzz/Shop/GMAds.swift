//
//  FreeCoins.swift
//  MuzTuzz
//
//  Created by Anton on 26.06.2020.
//  Copyright © 2020 Anton. All rights reserved.
//

import Foundation
import GoogleMobileAds


class FreeCoinsRewardClass: NSObject, GADRewardedAdDelegate, GADInterstitialDelegate{
    let adID = "ca-app-pub-8364051315582457/6579562744"
    let testAdID = "ca-app-pub-3940256099942544/1712485313"
    
    let testInterstitialAd = "ca-app-pub-3940256099942544/4411468910"
    let interstitialAd = "ca-app-pub-8364051315582457/9039873428"
    
    
    static let freeAdd = FreeCoinsRewardClass()
    
    var rewardedAd: GADRewardedAd?
    var interstitial: GADInterstitial!
    
    func adLoad(){
        rewardedAd = GADRewardedAd(adUnitID: testAdID)

//        rewardedAd = GADRewardedAd(adUnitID: adID)
        
        rewardedAd?.load(GADRequest()) { error in
            if let error = error {
                print ("error")
                // Handle ad failed to load case.
            } else {
                // Ad successfully loaded.
            }
        }
    }
    
    func freeCoinsAdShow(_ view: UIViewController){
        if rewardedAd?.isReady == true {
            rewardedAd?.present(fromRootViewController: view, delegate:self)
        }
    }
    
    /// Tells the delegate that the user earned a reward.
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        Persistence.shared.totalCoins! += Int(reward.amount)
        Persistence.shared.freeCoinsGotInt += 1
//        print("Reward received with currency: \(reward.amount).")

    }
    /// Tells the delegate that the rewarded ad was presented.
    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
        print("Rewarded ad presented.")
    }
    /// Tells the delegate that the rewarded ad was dismissed.
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        adLoad()
        SoundsPlay.shared.playSound("boughtCoins", "wav")
        print("Rewarded ad dismissed.")
    }
    /// Tells the delegate that the rewarded ad failed to present.
    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
        print("Rewarded ad failed to present.")
    }
    
    
    func interstitialAdLoad(){
//        interstitial = GADInterstitial(adUnitID: interstitialAd)
         interstitial = GADInterstitial(adUnitID: testInterstitialAd)
        let request = GADRequest()
        interstitial.load(request)
        print ("ad loaded")
    }
    
    func interstitialAdShow(_ view: UIViewController){
        if interstitial.isReady {
           interstitial.present(fromRootViewController: view)
         } else {
           print("Ad wasn't ready")
         }
    }
    
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
      print("interstitialDidReceiveAd")
    }

    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
      print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
      print("interstitialWillPresentScreen")
    }

    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
      
        print("interstitialWillDismissScreen")
    }

    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
      interstitialAdLoad()
        print("interstitialDidDismissScreen")
    }

    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
      print("interstitialWillLeaveApplication")
    }
        
    
    
}

