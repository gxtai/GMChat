//
//  SwiftProgressHUD.swift
//  SwiftProgressHUDDemo
//
//  Created by YJHou on 2016/3/12.
//  Copyright © 2016年 houmanager@hotmail.com . All rights reserved.
//

import UIKit

/// Current_Version：0.0.7
/// Github: https://github.com/stackhou/SwiftProgressHUD

private let yj_topBarTag: Int = 1001
private let yj_showHUDBackColor = UIColor(red:0, green:0, blue:0, alpha: 0.8)

/// Display type
public enum SwiftProgressHUDType{
    case success
    case fail
    case info
}

//------------- API START -------------
public class SwiftProgressHUD {
    
    /// Set keyWindow Mask background color
    static public var hudBackgroundColor: UIColor = UIColor.clear {
        didSet{
            SwiftProgress.hudBackgroundColor = hudBackgroundColor
        }
    }
    
    /// Setting the number of manual hides
    static public var hideHUDTaps: Int = 2 {
        didSet{
            SwiftProgress.hideHUDTaps = hideHUDTaps
        }
    }
    
    /// Wait for loading...
    @discardableResult
    public class func showWait() -> UIWindow? {
        if let _ = UIApplication.shared.keyWindow {
            return SwiftProgress.wait()
        }
        return nil
    }
    
    /// Wait for loading with text
    @discardableResult
    public class func showWaitWithText(_ text: String, autoClear: Bool = false, autoClearTime: Double = 3, runable: (() -> ())? = nil) -> UIWindow? {
        if let _ = UIApplication.shared.keyWindow {
            return SwiftProgress.showWaitWithText(text, autoClear: autoClear, autoClearTime: autoClearTime, runable: runable)
        }
        return nil
    }
    
    /// Success
    @discardableResult
    public class func showSuccess(_ text: String, autoClear: Bool = true, autoClearTime: Double = 3, runable: (() -> ())? = nil) -> UIWindow? {
        if let _ = UIApplication.shared.keyWindow {
            return SwiftProgress.showNoticeWithText(SwiftProgressHUDType.success, text: text, autoClear: autoClear, autoClearTime: autoClearTime, runable: runable)
        }
        return nil
    }
    
    /// Fail
    @discardableResult
    public class func showFail(_ text: String, autoClear: Bool = true, autoClearTime: Double = 3, runable: (() -> ())? = nil) -> UIWindow? {
        if let _ = UIApplication.shared.keyWindow {
            return SwiftProgress.showNoticeWithText(SwiftProgressHUDType.fail, text: text, autoClear: autoClear, autoClearTime: autoClearTime, runable: runable)
        }
        return nil
    }
    
    /// Hint information
    @discardableResult
    public class func showInfo(_ text: String, autoClear: Bool = true, autoClearTime: Double = 3, runable: (() -> ())? = nil) -> UIWindow? {
        if let _ = UIApplication.shared.keyWindow {
            return SwiftProgress.showNoticeWithText(SwiftProgressHUDType.info, text: text, autoClear: autoClear, autoClearTime: autoClearTime, runable: runable)
        }
        return nil
    }
    
    /// Prompt free type
    @discardableResult
    public class func show(_ text: String, type: SwiftProgressHUDType, autoClear: Bool, autoClearTime: Double = 3, runable: (() -> ())? = nil) -> UIWindow? {
        if let _ = UIApplication.shared.keyWindow {
            return SwiftProgress.showNoticeWithText(type, text: text, autoClear: autoClear, autoClearTime: autoClearTime, runable: runable)
        }
        return nil
    }
    
    /// Only display text
    @discardableResult
    public class func showOnlyText(_ text: String, runable: (() -> ())? = nil) -> UIWindow? {
        if let _ = UIApplication.shared.keyWindow {
            return SwiftProgress.showText(text, runable: runable)
        }
        return nil
    }
    
    /// Status bar prompt
    @discardableResult
    public class func showOnNavigation(_ text: String, autoClear: Bool = true, autoClearTime: Double = 1, textColor: UIColor = UIColor.black, fontSize:CGFloat = 13, backgroundColor: UIColor = UIColor.white, runable: (() -> ())? = nil) -> UIWindow? {
        if let _ = UIApplication.shared.keyWindow {
            
            return SwiftProgress.noticeOnNavigationBar(text, autoClear: autoClear, autoClearTime: autoClearTime, textColor: textColor, fontSize: fontSize, backgroundColor: backgroundColor, runable: runable)
        }
        return nil
    }
    
    /// Animated picture array
    @discardableResult
    public class func showAnimationImages(_ imageNames: Array<UIImage>, timeMilliseconds: Int, backgroundColor: UIColor = UIColor.clear, scale: Double = 1.0, runable: (() -> ())? = nil) -> UIWindow? {
        if let _ = UIApplication.shared.keyWindow {
            return SwiftProgress.wait(imageNames, timeMilliseconds: timeMilliseconds, backgroundColor: backgroundColor, scale: scale)
        }
        return nil
    }
    
    /// Clear all
    public class func hideAllHUD() {
        SwiftProgress.clear()
    }
}
//----------------- API END -------------------


class SwiftProgress: NSObject {
    
    static var hudBackgroundColor: UIColor = UIColor.clear
    static var hideHUDTaps: Int = 2
    static var windows = Array<UIWindow??>()
    static let rv = UIApplication.shared.keyWindow?.subviews.first as UIView?
    static var timer: DispatchSource!
    static var timerTimes = 0
    
    /* just for iOS 8 */
    static var degree: Double {
        get {
            return [0, 0, 180, 270, 90][UIApplication.shared.statusBarOrientation.hashValue] as Double
        }
    }
    
    static func clear() {
        self.cancelPreviousPerformRequests(withTarget: self)
        if let _ = timer {
            timer.cancel()
            timer = nil
            timerTimes = 0
        }
        windows.removeAll(keepingCapacity: false)
    }
    
    @discardableResult
    static func noticeOnNavigationBar(_ text: String, autoClear: Bool, autoClearTime: Double, textColor: UIColor, fontSize:CGFloat, backgroundColor: UIColor, runable: (() -> ())? = nil) -> UIWindow{
        let statusBarFrame = UIApplication.shared.statusBarFrame
        let frame = CGRect(x: 0, y: 0, width: statusBarFrame.width, height: (statusBarFrame.height + 44))
        let window = UIWindow()
        window.rootViewController = UIViewController.currentViewController()
        window.backgroundColor = UIColor.clear
        let view = UIView()
        view.backgroundColor = backgroundColor
        let label = UILabel(frame: CGRect(x: 0, y: statusBarFrame.height, width: frame.width, height: (frame.height - 44)))
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textColor = textColor
        label.text = text
        view.addSubview(label)
        
        window.frame = frame
        view.frame = frame
        
        if let version = Double(UIDevice.current.systemVersion),
            version < 9.0 {
            // change center
            var array = [UIScreen.main.bounds.width, UIScreen.main.bounds.height]
            array = array.sorted(by: <)
            let kScreenWidth = array[0]
            let kScreenHeight = array[1]
            let x = [0, kScreenWidth/2, kScreenWidth/2, 10, kScreenWidth-10][UIApplication.shared.statusBarOrientation.hashValue] as CGFloat
            let y = [0, 10, kScreenHeight-10, kScreenHeight/2, kScreenHeight/2][UIApplication.shared.statusBarOrientation.hashValue] as CGFloat
            window.center = CGPoint(x: x, y: y)
            
            // change direction
            window.transform = CGAffineTransform(rotationAngle: CGFloat(degree * Double.pi / 180))
        }
    #if swift(>=4.2)
        window.windowLevel = UIWindow.Level.statusBar
    #else
        window.windowLevel = UIWindowLevelStatusBar
    #endif
        window.isHidden = false
        window.addSubview(view)
        windows.append(window)
        
        var origPoint = view.frame.origin
        origPoint.y = -(view.frame.size.height)
        let destPoint = view.frame.origin
        view.tag = yj_topBarTag
        
        view.frame = CGRect(origin: origPoint, size: view.frame.size)
        UIView.animate(withDuration: 0.3, animations: {
            view.frame = CGRect(origin: destPoint, size: view.frame.size)
        }, completion: { b in
            if autoClear {
                
                DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + autoClearTime, execute: {
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.3, animations: {
                            /// Vanishing animation
                            view.frame = CGRect(origin: origPoint, size: view.frame.size)
                        }, completion: { (b) in
                            let selector = #selector(SwiftProgress.hideNotice(_:))
                            self.perform(selector, with: window, afterDelay: TimeInterval(autoClearTime))
                            //  延时操作
                            DispatchQueue.main.asyncAfter(deadline: .now() + autoClearTime) {
                                runable?()
                            }
                        })
                    }
                })
            }
        })
        return window
    }
    
    @discardableResult
    static func wait(_ imageNames: Array<UIImage> = Array<UIImage>(), timeMilliseconds: Int = 0, backgroundColor: UIColor = yj_showHUDBackColor, scale: Double = 1.0) -> UIWindow {
        let frame = CGRect(x: 0, y: 0, width: 78, height: 78)
        let window = UIWindow()
        window.backgroundColor = hudBackgroundColor
        window.rootViewController = UIViewController.currentViewController()
        let mainView = UIView()
        mainView.layer.cornerRadius = 12
        mainView.backgroundColor = backgroundColor
        
        /// add tapGesture
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapHideGesture(gesture:)))
        tapGesture.numberOfTapsRequired = hideHUDTaps
        window.addGestureRecognizer(tapGesture)
        
        let imgViewFrame = CGRect(x: Double(frame.size.width) * (1 - scale) * 0.5, y: Double(frame.size.height) * (1 - scale) * 0.5, width: Double(frame.size.width) * scale, height: Double(frame.size.height) * scale)
        
        if imageNames.count > 0 {
            if imageNames.count > timerTimes {
                let iv = UIImageView(frame: imgViewFrame)
                iv.image = imageNames.first!
            #if swift(>=4.2)
                iv.contentMode = UIView.ContentMode.scaleAspectFit
            #else
                iv.contentMode = UIViewContentMode.scaleAspectFit
            #endif
                mainView.addSubview(iv)
                timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: UInt(0)), queue: DispatchQueue.main) as! DispatchSource
                //timer.schedule(deadline: DispatchTime.now(), repeating: DispatchTimeInterval.milliseconds(timeMilliseconds))
                timer.scheduleRepeating(deadline: DispatchTime.now(), interval: DispatchTimeInterval.milliseconds(timeMilliseconds))
                timer.setEventHandler(handler: { () -> Void in
                    let name = imageNames[timerTimes % imageNames.count]
                    iv.image = name
                    timerTimes += 1
                })
                timer.resume()
            }
        } else {
        #if swift(>=4.2)
            let ai = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        #else
            let ai = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        #endif
            ai.frame = CGRect(x: 21, y: 21, width: 36, height: 36)
            ai.startAnimating()
            mainView.addSubview(ai)
        }
        
        window.frame = rv!.bounds
        mainView.frame = frame
        mainView.center = rv!.center
        
        if let version = Double(UIDevice.current.systemVersion),
            version < 9.0 {
            // change center
            window.center = getRealCenter()
            // change direction
            window.transform = CGAffineTransform(rotationAngle: CGFloat(degree * Double.pi / 180))
        }
    #if swift(>=4.2)
        window.windowLevel = UIWindow.Level.alert
    #else
        window.windowLevel = UIWindowLevelAlert
    #endif
        window.isHidden = false
        window.addSubview(mainView)
        windows.append(window)
        
        mainView.alpha = 0.0
        UIView.animate(withDuration: 0.2, animations: {
            mainView.alpha = 1
        })
        return window
    }
    
    @discardableResult
    static func showText(_ text: String, autoClear: Bool = true, autoClearTime: Double = 2, runable: (() -> ())? = nil) -> UIWindow {
        let window = UIWindow()
        window.backgroundColor = hudBackgroundColor
        window.rootViewController = UIViewController.currentViewController()
        let mainView = UIView()
        mainView.layer.cornerRadius = 12
        mainView.backgroundColor = yj_showHUDBackColor
        
        /// add tapGesture
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapHideGesture(gesture:)))
        tapGesture.numberOfTapsRequired = hideHUDTaps
        window.addGestureRecognizer(tapGesture)
        
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        let size = label.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 82, height: CGFloat.greatestFiniteMagnitude))
        label.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        mainView.addSubview(label)
        
        let superFrame = CGRect(x: 0, y: 0, width: label.frame.width + 50 , height: label.frame.height + 30)
        
        window.frame = rv!.bounds
        mainView.frame = superFrame
        
        label.center = mainView.center
        mainView.center = rv!.center
        
        if let version = Double(UIDevice.current.systemVersion),
            version < 9.0 {
            // change center
            window.center = getRealCenter()
            // change direction
            window.transform = CGAffineTransform(rotationAngle: CGFloat(degree * Double.pi / 180))
        }
    #if swift(>=4.2)
        window.windowLevel = UIWindow.Level.alert
    #else
        window.windowLevel = UIWindowLevelAlert
    #endif
        window.isHidden = false
        window.addSubview(mainView)
        windows.append(window)
        
        if autoClear {
            let selector = #selector(SwiftProgress.hideNotice(_:))
            self.perform(selector, with: window, afterDelay: TimeInterval(autoClearTime))
            
            //  延时操作
            DispatchQueue.main.asyncAfter(deadline: .now() + autoClearTime) {
                runable?()
            }
        }
        return window
    }
    
    @discardableResult
    static func showNoticeWithText(_ type: SwiftProgressHUDType,text: String, autoClear: Bool, autoClearTime: Double, runable: (() -> ())? = nil) -> UIWindow {
        var frame = CGRect(x: 0, y: 0, width: 90, height: 90)
        let window = UIWindow()
        window.backgroundColor = hudBackgroundColor
        window.rootViewController = UIViewController.currentViewController()
        let mainView = UIView()
        mainView.layer.cornerRadius = 8
        mainView.backgroundColor = yj_showHUDBackColor
        
        /// add tapGesture
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapHideGesture(gesture:)))
        tapGesture.numberOfTapsRequired = hideHUDTaps
        window.addGestureRecognizer(tapGesture)
        
        var image = UIImage()
        switch type {
        case .success:
            image = SwiftProgressSDK.imageOfCheckmark
        case .fail:
            image = SwiftProgressSDK.imageOfCross
        case .info:
            image = SwiftProgressSDK.imageOfInfo
        }
        let checkmarkView = UIImageView(image: image)
        checkmarkView.frame = CGRect(x: 27, y: 15, width: 36, height: 36)
        mainView.addSubview(checkmarkView)
        
        let label = UILabel(frame: CGRect(x: 0, y: 60, width: 90, height: 16))
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.white
        label.text = text
        label.textAlignment = NSTextAlignment.center
        label.lineBreakMode = .byTruncatingMiddle
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        
        var size = label.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 82, height: CGFloat.greatestFiniteMagnitude))
        
        //  如果字符串的长度大于原有预计的90 需要重新进行计算
        if size.width > 90 {
            label.frame.origin.x = 5
            label.frame.size.width = size.width
            if Int(size.height) % 16 != 0 {
                let ratio = Int(size.height) / 16 + 2
                size.height = CGFloat(ratio) * 16
            }
            label.frame.size.height = size.height
            frame.size.width = size.width + 10
            frame.size.height = size.height + label.frame.minY + 5
            checkmarkView.frame.origin.x = (frame.width - checkmarkView.frame.width) / 2
            
        }
        
        mainView.addSubview(label)
        
        window.frame = rv!.bounds
        mainView.frame = frame
        mainView.center = rv!.center
        
        if let version = Double(UIDevice.current.systemVersion),
            version < 9.0 {
            // change center
            window.center = getRealCenter()
            // change direction
            window.transform = CGAffineTransform(rotationAngle: CGFloat(degree * Double.pi / 180))
        }
        
    #if swift(>=4.2)
        window.windowLevel = UIWindow.Level.alert
    #else
        window.windowLevel = UIWindowLevelAlert
    #endif
        window.center = rv!.center
        window.isHidden = false
        window.addSubview(mainView)
        windows.append(window)
        
        mainView.alpha = 0.0
        UIView.animate(withDuration: 0.2, animations: {
            mainView.alpha = 1
        })
        
        if autoClear {
            let selector = #selector(SwiftProgress.hideNotice(_:))
            self.perform(selector, with: window, afterDelay: TimeInterval(autoClearTime))
            //  延时操作
            DispatchQueue.main.asyncAfter(deadline: .now() + autoClearTime) {
                runable?()
            }
        }
        return window
    }
    
    @discardableResult
    static func showWaitWithText(_ text: String, autoClear: Bool, autoClearTime: Double, runable: (() -> ())? = nil) -> UIWindow {
        var frame = CGRect(x: 0, y: 0, width: 90, height: 90)
        let window = UIWindow()
        window.backgroundColor = hudBackgroundColor
        window.rootViewController = UIViewController()
        let mainView = UIView()
        mainView.layer.cornerRadius = 8
        mainView.backgroundColor = yj_showHUDBackColor
        
        /// add tapGesture
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapHideGesture(gesture:)))
        tapGesture.numberOfTapsRequired = hideHUDTaps
        window.addGestureRecognizer(tapGesture)
        
    #if swift(>=4.2)
        let ai = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
    #else
        let ai = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    #endif
        ai.frame = CGRect(x: 27, y: 15, width: 36, height: 36)
        ai.startAnimating()
        mainView.addSubview(ai)
        
        let label = UILabel(frame: CGRect(x: 0, y: 60, width: 90, height: 16))
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.white
        label.text = text
        label.lineBreakMode = .byTruncatingMiddle
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        
        var size = label.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 82, height: CGFloat.greatestFiniteMagnitude))
        
        //  如果字符串的长度大于原有预计的90 需要重新进行计算
        if size.width > 90 {
            label.frame.origin.x = 5
            label.frame.size.width = size.width
            if Int(size.height) % 16 != 0 {
                let ratio = Int(size.height) / 16 + 2
                size.height = CGFloat(ratio) * 16
            }
            label.frame.size.height = size.height
            frame.size.width = size.width + 10
            frame.size.height = size.height + label.frame.minY + 5
            ai.frame.origin.x = (frame.width - ai.frame.width) / 2
        }
        
        mainView.addSubview(label)
        
        window.frame = rv!.bounds
        mainView.frame = frame
        mainView.center = rv!.center
        
        if let version = Double(UIDevice.current.systemVersion),
            version < 9.0 {
            // change center
            window.center = getRealCenter()
            // change direction
            window.transform = CGAffineTransform(rotationAngle: CGFloat(degree * Double.pi / 180))
        }
        
    #if swift(>=4.2)
        window.windowLevel = UIWindow.Level.alert
    #else
        window.windowLevel = UIWindowLevelAlert
    #endif
        
        window.center = rv!.center
        window.isHidden = false
        window.addSubview(mainView)
        windows.append(window)
        
        mainView.alpha = 0.0
        UIView.animate(withDuration: 0.2, animations: {
            mainView.alpha = 1
        })
        
        if autoClear {
            let selector = #selector(SwiftProgress.hideNotice(_:))
            self.perform(selector, with: window, afterDelay: TimeInterval(autoClearTime))
            //  延时操作
            DispatchQueue.main.asyncAfter(deadline: .now() + autoClearTime) {
                runable?()
            }
        }
        return window
    }
    
    /// Repair window has not been removed
    @objc static func hideNotice(_ sender: AnyObject) {
        if let window = sender as? UIWindow {
            
            if let v = window.subviews.first {
                UIView.animate(withDuration: 0.2, animations: {
                    
                    if v.tag == yj_topBarTag {
                        v.frame = CGRect(x: 0, y: -v.frame.height, width: v.frame.width, height: v.frame.height)
                    }
                    v.alpha = 0
                }, completion: { b in
                    if let index = windows.index(where: { (item) -> Bool in
                        return item == window
                    }) {
                        windows.remove(at: index)
                    }
                })
            }
        }
    }
    
    // just for iOS 8
    static func getRealCenter() -> CGPoint {
        if UIApplication.shared.statusBarOrientation.hashValue >= 3 {
            return CGPoint(x: rv!.center.y, y: rv!.center.x)
        } else {
            return rv!.center
        }
    }
    
    /// tap Hide HUD
    @objc
    static func tapHideGesture(gesture: UITapGestureRecognizer) {
        clear()
    }
}

class SwiftProgressSDK {
    struct Cache {
        static var imageOfCheckmark: UIImage?
        static var imageOfCross: UIImage?
        static var imageOfInfo: UIImage?
    }
    class func draw(_ type: SwiftProgressHUDType) {
        let checkmarkShapePath = UIBezierPath()
        
        // draw circle
        checkmarkShapePath.move(to: CGPoint(x: 36, y: 18))
        checkmarkShapePath.addArc(withCenter: CGPoint(x: 18, y: 18), radius: 17.5, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: true)
        checkmarkShapePath.close()
        
        switch type {
        case .success: // draw checkmark
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 18))
            checkmarkShapePath.addLine(to: CGPoint(x: 16, y: 24))
            checkmarkShapePath.addLine(to: CGPoint(x: 27, y: 13))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 18))
            checkmarkShapePath.close()
        case .fail: // draw X
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 10))
            checkmarkShapePath.addLine(to: CGPoint(x: 26, y: 26))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 26))
            checkmarkShapePath.addLine(to: CGPoint(x: 26, y: 10))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 10))
            checkmarkShapePath.close()
        case .info:
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 6))
            checkmarkShapePath.addLine(to: CGPoint(x: 18, y: 22))
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 6))
            checkmarkShapePath.close()
            
            UIColor.white.setStroke()
            checkmarkShapePath.stroke()
            
            let checkmarkShapePath = UIBezierPath()
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 27))
            checkmarkShapePath.addArc(withCenter: CGPoint(x: 18, y: 27), radius: 1, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: true)
            checkmarkShapePath.close()
            
            UIColor.white.setFill()
            checkmarkShapePath.fill()
        }
        
        UIColor.white.setStroke()
        checkmarkShapePath.stroke()
    }
    class var imageOfCheckmark: UIImage {
        if (Cache.imageOfCheckmark != nil) {
            return Cache.imageOfCheckmark!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        
        SwiftProgressSDK.draw(SwiftProgressHUDType.success)
        
        Cache.imageOfCheckmark = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCheckmark!
    }
    class var imageOfCross: UIImage {
        if (Cache.imageOfCross != nil) {
            return Cache.imageOfCross!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        
        SwiftProgressSDK.draw(SwiftProgressHUDType.fail)
        
        Cache.imageOfCross = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCross!
    }
    class var imageOfInfo: UIImage {
        if (Cache.imageOfInfo != nil) {
            return Cache.imageOfInfo!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        
        SwiftProgressSDK.draw(SwiftProgressHUDType.info)
        
        Cache.imageOfInfo = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfInfo!
    }
}

extension UIWindow{
    func hide(){
        SwiftProgress.hideNotice(self)
    }
}


extension UIViewController {
    class func currentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return currentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return currentViewController(base: presented)
        }
        return base
    }
}

