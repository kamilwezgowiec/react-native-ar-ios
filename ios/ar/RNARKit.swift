import Foundation
import SwiftUI
import React
import UIKit

@objc(RNARKit)
class RNARKit : UIResponder, UIApplicationDelegate {
  @objc static func requiresMainQueueSetup() -> Bool {
      return false
  }

  @objc func show() -> Void {
    DispatchQueue.main.async {
      self._show()
    }
  }

  func _show() -> Void {
    let vc = UIStoryboard(name: "ARKit", bundle: nil).instantiateInitialViewController()

    if let vc = vc {
      let window = UIApplication.shared.windows.first

      window?.rootViewController = vc
    }
  }
}
