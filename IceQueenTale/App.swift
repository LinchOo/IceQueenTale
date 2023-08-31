import Foundation
import UIKit
import SwiftUI
import Lottie

class StartApp: UIViewController, URLSessionDelegate {
    var window: UIWindow?
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var animationView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        animationView = .init(name: "loading")
        animationView?.frame = CGRect(x: 0 , y: view.bounds.height / 2 - 250, width: view.bounds.width, height: 300 )
        animationView?.loopMode = .loop
        animationView?.contentMode = .scaleToFill
        animationView?.animationSpeed = 1
        view.addSubview(animationView!)
        animationView?.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            self.switchToHomeView()
            self.animationView?.stop()
        }
    }
    
    func switchToHomeView() {
            let homeViewController = UIHostingController(rootView: MainTab())
            homeViewController.modalPresentationStyle = .fullScreen
            AppUtility.lockOrientation(.portrait)
            self.window?.switchRootViewController(homeViewController,animated: true, duration: 0.3, options: .transitionCrossDissolve)
            self.window?.makeKeyAndVisible()

        }
}

extension UIWindow {

    func switchRootViewController(_ viewController: UIViewController,
                                  animated: Bool = true,
                                  duration: TimeInterval = 0.5,
                                  options: AnimationOptions = .transitionFlipFromRight,
                                  completion: (() -> Void)? = nil) {
        guard animated else {
            rootViewController = viewController
            return
        }

        UIView.transition(with: self, duration: duration, options: options, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            self.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        }, completion: { _ in
            completion?()
        })
    }
}

struct AppUtility {
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {

        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {

        self.lockOrientation(orientation)

        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
}

