import Foundation
import SwiftUI
import React
import UIKit

@objc(RNARKit)
class RNARKit : UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  var bridge: RCTBridge!
  
  @objc static func requiresMainQueueSetup() -> Bool {
      return false
  }
  
  // Reference to use main thread
  @objc func open(_ options: NSDictionary) -> Void {
    DispatchQueue.main.async {
      //self._open(options: options)
      
      print("test")
      let vc = UIStoryboard(name: "ARKit", bundle: nil).instantiateInitialViewController()
      print("test2", vc)
      if let vc = vc {
        
        let window = UIApplication.shared.windows.first
        
        window?.rootViewController = vc
        //(window?.rootViewController as? UINavigationController)?.pushViewController(vc, animated: true)
        print("executing", window)
      }
    }
  }
  
//  func _open(options: NSDictionary) -> Void {
//    var items = [String]()
//    let message = RCTConvert.nsString(options["message"])
//
//    if message != "" {
//      items.append(message!)
//    }
//
//    if items.count == 0 {
//      print("No `message` to share!")
//      return
//    }
//
//    let controller = RCTPresentedViewController()
//    let shareController = UIActivityViewController(activityItems: items, applicationActivities: nil);
//
//    shareController.popoverPresentationController?.sourceView = controller?.view;
//
//    controller?.present(shareController, animated: true, completion: nil)
//  }
}

