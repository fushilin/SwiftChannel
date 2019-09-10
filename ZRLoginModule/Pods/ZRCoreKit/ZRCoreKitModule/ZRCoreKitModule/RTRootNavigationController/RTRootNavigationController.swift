//
//  RTRootNavigationController.swift
//  ZRCoreKitModule
//
//  Created by lam on 2019/7/16.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit

fileprivate func RTSafeUnwrapViewController(_ controller: UIViewController?) -> UIViewController? {
    if let container = (controller as? RTContainerController)?.contentViewController {
        return container
    }
    return controller;
}

fileprivate func RTSafeWrapViewController(_ controller: UIViewController, navigationBarClass: AnyClass?, withPlaceholder: Bool = false, backItem: UIBarButtonItem? = nil, backTitle: String? = nil) -> UIViewController {
    return RTContainerController(controller:controller,navigationBarClass:navigationBarClass,withPlaceholder:withPlaceholder,backItem:backItem,backTitle:backTitle)
}

extension Array where Element: Equatable {
    
    fileprivate func rt_any(_ operate: (Element) -> Bool) -> Bool {
        var result: Bool = false
        for item in self {
            if operate(item) {
                result = true
                break
            }
        }
        return result
    }
}

extension UIViewController {
    fileprivate var rt_hasSetInteractivePop: Bool {
        guard let _ = objc_getAssociatedObject(self, &disableInteractivePopKey) else { return false }
        return true
    }
}

// MARK:  - -------------------*****RTContainerController*****----------------------- -

open class RTContainerController : UIViewController {
    
    open private(set) var contentViewController: UIViewController = UIViewController()
    
    private var containerNavigationController: UINavigationController?
    
    open override var canBecomeFirstResponder: Bool {
        return contentViewController.canBecomeFirstResponder
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return contentViewController.preferredStatusBarStyle
    }
    
    open override var prefersStatusBarHidden: Bool {
        return contentViewController.prefersStatusBarHidden
    }
    
    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return contentViewController.preferredStatusBarUpdateAnimation
    }
    
    @available(iOS 11.0, *)
    open override var childForScreenEdgesDeferringSystemGestures: UIViewController? {
        return contentViewController
    }
    
    @available(iOS 11.0, *)
    open override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return contentViewController.preferredScreenEdgesDeferringSystemGestures
    }
    
    @available(iOS 11.0, *)
    open override var prefersHomeIndicatorAutoHidden: Bool {
        return contentViewController.prefersHomeIndicatorAutoHidden
    }
    
    @available(iOS 11.0, *)
    open override var childForHomeIndicatorAutoHidden: UIViewController? {
        return contentViewController.childForHomeIndicatorAutoHidden
    }
    
    open override var shouldAutorotate: Bool {
        return contentViewController.shouldAutorotate
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return contentViewController.supportedInterfaceOrientations
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return contentViewController.preferredInterfaceOrientationForPresentation
    }
    
    open override var hidesBottomBarWhenPushed: Bool {
        set {
            super.hidesBottomBarWhenPushed = newValue
        }
        get {
            return contentViewController.hidesBottomBarWhenPushed
        }
    }
    
    open override var title: String? {
        set {
            super.title = newValue
        }
        get {
            return contentViewController.title
        }
    }
    
    open override var tabBarItem: UITabBarItem! {
        set {
            super.tabBarItem = newValue
        }
        get{
            return contentViewController.tabBarItem
        }
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate convenience init(controller: UIViewController, navigationBarClass: AnyClass?, withPlaceholder: Bool, backItem: UIBarButtonItem?, backTitle: String?) {
        self.init(nibName: nil, bundle: nil)
        
        self.contentViewController = controller
        
        self.containerNavigationController = RTContainerNavigationController(navigationBarClass: navigationBarClass, toolbarClass: nil)
        
        if withPlaceholder {
            let vc = UIViewController()
            vc.title = backTitle
            vc.navigationItem.backBarButtonItem = backItem
            self.containerNavigationController?.viewControllers = [vc, controller]
        } else {
            self.containerNavigationController?.viewControllers = [controller]
        }
        
        self.addChild(self.containerNavigationController!)
        self.containerNavigationController?.didMove(toParent: self)
    }
    
    fileprivate convenience init(contentController: UIViewController) {
        self.init(nibName:nil,bundle:nil)
        self.contentViewController = contentController
        self.addChild(self.contentViewController)
        self.contentViewController.didMove(toParent: self)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        if let containerNav = self.containerNavigationController {
            containerNav.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
            self.view.addSubview(containerNav.view)
            
            // fix issue #16 https://github.com/rickytan/RTRootNavigationController/issues/16
            containerNav.view.frame = self.view.bounds
        }else{
            self.contentViewController.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
            self.contentViewController.view.frame = self.view.bounds
            self.view.addSubview((self.contentViewController.view)!)
        }
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // remove the following to fix issue #16 https://github.com/rickytan/RTRootNavigationController/issues/16
        // self.containerNavigationController.view.frame = self.view.bounds;
    }
    
    open override func becomeFirstResponder() -> Bool {
        return contentViewController.becomeFirstResponder()
    }
    
    @available(iOS, introduced: 6.0, deprecated: 9.0)
    open override func forUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any?) -> UIViewController? {
        return contentViewController.forUnwindSegueAction(action, from: fromViewController, withSender: sender)
    }
   
}

// MARK:  - -------------------*****RTContainerNavigationController*****----------------------- -

open class RTContainerNavigationController : UINavigationController {
    
    open override var tabBarController: UITabBarController? {
        
        guard let tabController = super.tabBarController  else { return nil }
        
        let navigationController = self.rt_navigationController
        
        if navigationController?.tabBarController != tabController {
            return tabController
        } else {
            let isHidden = navigationController?.viewControllers.rt_any{ (item) -> Bool in
                return item.hidesBottomBarWhenPushed
            }
            return (!(tabController.tabBar.isTranslucent) || isHidden ?? false) ? nil : tabController
        }
    }
    
    open override var viewControllers: [UIViewController] {
        
        set {
            if self.navigationController != nil{
                self.navigationController?.viewControllers = newValue
            } else {
                super.viewControllers = newValue
            }
        }
        
        get {
            if let navigationController = self.navigationController, navigationController is RTRootNavigationController {
                return (self.rt_navigationController?.rt_viewControllers)!
            }
            return super.viewControllers
        }
    }
    
    open override var delegate: UINavigationControllerDelegate? {
        set {
            if let navigationController = self.navigationController {
                navigationController.delegate = newValue
            } else {
                super.delegate = newValue
            }
        }
        
        get {
            return  (self.navigationController != nil) ? self.navigationController?.delegate : super.delegate
        }
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return (self.topViewController?.preferredStatusBarStyle)!
    }
    
    open override var prefersStatusBarHidden: Bool {
        return (self.topViewController?.prefersStatusBarHidden)!
    }
    
    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation
    {
        return (self.topViewController?.preferredStatusBarUpdateAnimation)!
    }
    
    @available(iOS 11.0, *)
    open override var childForScreenEdgesDeferringSystemGestures: UIViewController? {
        return self.topViewController
    }
    
    @available(iOS 11.0, *)
    open override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return (self.topViewController?.preferredScreenEdgesDeferringSystemGestures)!
    }
    
    @available(iOS 11.0, *)
    open override var prefersHomeIndicatorAutoHidden: Bool {
        return (self.topViewController?.prefersHomeIndicatorAutoHidden)!
    }
    
    @available(iOS 11.0, *)
    open override var childForHomeIndicatorAutoHidden: UIViewController? {
        return self.topViewController
    }

    
    override init(rootViewController: UIViewController) {
        super.init(navigationBarClass: rootViewController.rt_navigationBarClass(), toolbarClass: nil)
        pushViewController(rootViewController, animated: false)
    }
    
    override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.interactivePopGestureRecognizer?.isEnabled = false
        
        if let _ = self.rt_navigationController?.transferNavigationBarAttributes {
            self.navigationBar.isTranslucent   = (self.navigationController?.navigationBar.isTranslucent)!
            self.navigationBar.tintColor       = self.navigationController?.navigationBar.tintColor
            self.navigationBar.barTintColor    = self.navigationController?.navigationBar.barTintColor
            self.navigationBar.barStyle        = (self.navigationController?.navigationBar.barStyle)!
            self.navigationBar.backgroundColor = self.navigationController?.navigationBar.backgroundColor
            
            self.navigationBar.setBackgroundImage(self.navigationController?.navigationBar.backgroundImage(for: .`default`), for: .`default`)
            self.navigationBar.setTitleVerticalPositionAdjustment((self.navigationController?.navigationBar.titleVerticalPositionAdjustment(for: .`default`))!, for: .`default`)
            
            self.navigationBar.titleTextAttributes              = self.navigationController?.navigationBar.titleTextAttributes;
            self.navigationBar.shadowImage                      = self.navigationController?.navigationBar.shadowImage;
            self.navigationBar.backIndicatorImage               = self.navigationController?.navigationBar.backIndicatorImage;
            self.navigationBar.backIndicatorTransitionMaskImage = self.navigationController?.navigationBar.backIndicatorTransitionMaskImage;
        }
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let viewController = self.visibleViewController else { return }
        
        // set rt_disableInteractivePop
        if viewController.rt_hasSetInteractivePop == false {
            let hasSetLeftItem = viewController.navigationItem.leftBarButtonItem != nil
            if self.isNavigationBarHidden {
                viewController.rt_disableInteractivePop = true
            } else if hasSetLeftItem {
                viewController.rt_disableInteractivePop = true
            } else {
                viewController.rt_disableInteractivePop = false
            }
        }
        
        ///
        if self.parent is RTContainerController, parent?.parent is RTRootNavigationController {
            self.rt_navigationController?.installsLeftBarButtonItemIfNeeded(for: viewController)
        }
    }
    
    
    @available(iOS, introduced: 6.0, deprecated: 9.0)
    open override func forUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any?) -> UIViewController? {        if(self.navigationController != nil) {
            return self.navigationController?.forUnwindSegueAction(_:action,from:fromViewController,withSender:sender)
        }
        return super.forUnwindSegueAction(_:action,from:fromViewController,withSender:sender)
    }
    
    open override func allowedChildrenForUnwinding(from source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        
        if let navigationController = self.navigationController {
            return navigationController.allowedChildrenForUnwinding(from: source)
        }
        
        return super.allowedChildrenForUnwinding(from: source)
    }
    
    
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if let navigationController = self.navigationController {
            navigationController.pushViewController(viewController, animated: animated)
        } else {
            super.pushViewController(viewController, animated: animated)
        }
    }
    
    open override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if let _ = self.navigationController?.responds(to: aSelector) {
            return self.navigationController
        }
        return nil
    }
    
    open override func popViewController(animated: Bool) -> UIViewController? {
        if let navigationController = self.navigationController {
            return navigationController.popViewController(animated: animated)
        } else {
            return super.popViewController(animated: animated)
        }
    }
    
    open override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if let navigationController = self.navigationController {
            return navigationController.popToViewController(viewController, animated: animated)
        } else {
            return super.popToViewController(viewController, animated: animated)
        }
    }
    
    open override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        if let navigationController = self.navigationController {
            return navigationController.popToRootViewController(animated: animated)
        } else {
            return super.popToRootViewController(animated: animated)
        }
    }
    
    open override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        if let navigationController = self.navigationController {
            navigationController.setViewControllers(viewControllers, animated: animated)
        } else {
             super.setViewControllers(viewControllers, animated: animated)
        }
    }
    
    open override func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
        super.setNavigationBarHidden(hidden, animated: animated)
        
        guard let vc = visibleViewController else { return }
        if vc.rt_hasSetInteractivePop == false {
            vc.rt_disableInteractivePop = hidden
        }
    }
    
}

// MARK:  - -------------------*****RTRootNavigationController*****----------------------- -
@IBDesignable
open class RTRootNavigationController: UINavigationController {
    
    /// use system original back bar item or custom back bar item returned by
    @IBInspectable open var useSystemBackBarButtonItem: Bool = false
    
    ///  Weather each individual navigation bar uses the visual style of root navigation bar
    @IBInspectable open var transferNavigationBarAttributes: Bool = false
    
    /// use this property instead of @c visibleViewController to get the current visiable content view controller
    open  var rt_visibleViewController: UIViewController? {
        return RTSafeUnwrapViewController(super.visibleViewController)
    }

    /// use this property instead of @c topViewController to get the content view controller on the stack top
    open var rt_topViewController: UIViewController? {
        return RTSafeUnwrapViewController(super.topViewController)
    }
    
    /// use this property to get all the content view controllers;
    open var rt_viewControllers: [UIViewController] {
        return super.viewControllers.map{
            return RTSafeUnwrapViewController($0)!
        }
    }
    
    weak fileprivate var rt_delegate: UINavigationControllerDelegate?
    
    fileprivate var animationComplete: ((Bool)->Swift.Void)?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    public override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
        self.commonInit()
    }
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.commonInit()
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(rootViewControllerNoWrapping: UIViewController) {
        super.init(rootViewController: RTContainerController(contentController: rootViewControllerNoWrapping))
        self.commonInit()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .red
        
        super.delegate = self
        
        super.setNavigationBarHidden(true, animated: false)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.viewControllers = super.viewControllers
    }
    
    @available(iOS, introduced: 6.0, deprecated: 9.0)
    open override func forUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any?) -> UIViewController? {
        guard let controller = super.forUnwindSegueAction(action, from: fromViewController, withSender: sender) else { return nil }
        
        var vc: UIViewController? = controller
        
        if let index = self.viewControllers.firstIndex(of: controller) {
            for i in (index - 1)...0  {
                vc = self.viewControllers[i].forUnwindSegueAction(action, from: fromViewController, withSender: sender)
                if vc != nil {break}
            }
        }
        return vc
    }
    
    open override func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
        // Override to protect
    }
    
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if self.viewControllers.count > 0 {
            let currentLast = RTSafeUnwrapViewController(self.viewControllers.last!)
            let toController = RTSafeWrapViewController(viewController, navigationBarClass: viewController.rt_navigationBarClass(), withPlaceholder: self.useSystemBackBarButtonItem,backItem: currentLast?.navigationItem.backBarButtonItem, backTitle: currentLast?.navigationItem.title)
            super.pushViewController(toController, animated: animated)
        } else {
            super.pushViewController(RTSafeWrapViewController(viewController,navigationBarClass: viewController.rt_navigationBarClass()), animated: animated)
        }
    }
    
    open override func popViewController(animated: Bool) -> UIViewController? {
        return RTSafeUnwrapViewController(super.popViewController(animated: animated)!);
    }
    
    open override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        return (super.popToRootViewController(animated: animated))?.map {
            RTSafeUnwrapViewController($0)!
        }
    }
    
    open override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        var controllerToPop :UIViewController?
        
        for vc in super.viewControllers {
            if(RTSafeUnwrapViewController( vc) == viewController) {
                controllerToPop = vc
                break
            }
        }
        
        if let ctp = controllerToPop {
            return super.popToViewController(ctp, animated: animated)?.map{
                return RTSafeUnwrapViewController($0)!
            }
        }
        return nil
    }
    
    open override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        
        super.setViewControllers(viewControllers.enumerated().map{(index,item)
            in
            if self.useSystemBackBarButtonItem && index > 0 {
                return RTSafeWrapViewController(item, navigationBarClass: item.rt_navigationBarClass(), withPlaceholder: self.useSystemBackBarButtonItem, backItem: viewControllers[index - 1].navigationItem.backBarButtonItem, backTitle: viewControllers[index - 1].navigationItem.title)
            }else{
                return RTSafeWrapViewController(item, navigationBarClass: item.rt_navigationBarClass())
            }
            
        }, animated: animated)
    }
    
    open override var delegate: UINavigationControllerDelegate? {
        set {
            self.rt_delegate = newValue
        }
        
        get {
            return super.delegate
        }
    }
    
    open override var shouldAutorotate: Bool {
        return (self.topViewController?.shouldAutorotate)!
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return (self.topViewController?.supportedInterfaceOrientations)!
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return (self.topViewController?.preferredInterfaceOrientationForPresentation)!
    }
    
    open override func responds(to aSelector: Selector!) -> Bool {
        if super.responds(to: aSelector) {
            return true
        }
        
        return self.rt_delegate?.responds(to: aSelector) ?? false
    }
    
    open override func forwardingTarget(for aSelector: Selector!) -> Any? {
        return self.rt_delegate
    }
}


// MARK: - remove push
extension RTRootNavigationController {
    open func removeViewController(_ controller: UIViewController, animated: Bool = false) {
        var viewControllers: [UIViewController] = super.viewControllers
        var controllerToRemove :UIViewController?
        for vc in viewControllers {
            if(RTSafeUnwrapViewController(vc) == controller) {
                controllerToRemove = vc
                break
            }
        }
        if let ctp = controllerToRemove, let index = viewControllers.firstIndex(of: ctp){
            viewControllers.remove(at: index)
            super.setViewControllers(viewControllers, animated: animated)
        }
    }
    
    open func pushViewController(viewController: UIViewController, animated: Bool,complete: @escaping (Bool)->Swift.Void){
        self.animationComplete?(false)
        self.animationComplete = complete
        self.pushViewController(viewController, animated: animated)
    }
    
    open func popViewController(animated: Bool, complete: @escaping (Bool)->Swift.Void) ->UIViewController? {
        self.animationComplete?(false)
        self.animationComplete = complete
        
        let vc = self.popViewController(animated: animated)
        
        self.animationComplete?(true)
        self.animationComplete = nil
        
        return vc
    }
    
    open func popToViewController(viewController: UIViewController,animated: Bool,complete: @escaping (Bool)->Swift.Void) ->[UIViewController]?{
        
        self.animationComplete?(false)
        self.animationComplete = complete
        
        let vcs = self.popToViewController(viewController, animated: animated)
        
        if let count = vcs?.count,count > 0 {
            self.animationComplete?(true)
            self.animationComplete = nil
        }
        return vcs
    }
    
    open func popToRootViewController(animated: Bool,complete: @escaping (Bool)->Swift.Void) ->[UIViewController]? {
        
        self.animationComplete?(false)
        self.animationComplete = complete
        
        let vcs = self.popToRootViewController(animated: animated)
        
        if let count = vcs?.count,count > 0 {
            self.animationComplete?(true)
            self.animationComplete = nil
        }
        return vcs
    }
}


// MARK: - go back
extension RTRootNavigationController {
    @objc private func onBack(sender: UIButton) {
        _ = popViewController(animated: true)
    }
    
    private func commonInit() {
        
    }
    
    fileprivate func installsLeftBarButtonItemIfNeeded(for viewController: UIViewController) {
        
        let isRootVC = viewController == RTSafeUnwrapViewController(viewControllers.first!)
        
        let hasSetLeftItem = viewController.navigationItem.leftBarButtonItem != nil
        
        if !isRootVC, !useSystemBackBarButtonItem, !hasSetLeftItem {
            if let customizable = viewController as? RTNavigationItemCustomizable {
                viewController.navigationItem.leftBarButtonItems = customizable.rt_customBackItems()
            } else {
//                viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title:NSLocalizedString("Back", comment: ""),style:.plain,target:self,
//                                                                                  action:#selector(onBack(sender:)))
                viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title:NSLocalizedString("Back", comment: ""),style:.plain,target:self,
                                                                                                  action:#selector(onBack(sender:)))
            }
        }
    }
}



// MARK: - UINavigationControllerDelegate
extension RTRootNavigationController : UINavigationControllerDelegate{
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        let isRootVC = viewController == navigationController.viewControllers.first
        let unwrapVC = RTSafeUnwrapViewController(viewController)!
        
        if !isRootVC, unwrapVC.isViewLoaded {
            let hasSetLeftItem = unwrapVC.navigationItem.leftBarButtonItem != nil
            
            if hasSetLeftItem && !unwrapVC.rt_hasSetInteractivePop {
                unwrapVC.rt_disableInteractivePop = true
            } else if !unwrapVC.rt_hasSetInteractivePop {
                unwrapVC.rt_disableInteractivePop = false
            }
            
            installsLeftBarButtonItemIfNeeded(for: viewController)
        }
        
        rt_delegate?.navigationController?(navigationController, willShow: viewController, animated: animated)
    }
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        let isRootVC = viewController == navigationController.viewControllers.first
        let viewController = RTSafeUnwrapViewController(viewController)!
        
        if viewController.rt_disableInteractivePop {
            interactivePopGestureRecognizer?.delegate = nil
            interactivePopGestureRecognizer?.isEnabled = false
        } else {
            interactivePopGestureRecognizer?.delaysTouchesBegan = true
            interactivePopGestureRecognizer?.delegate = self
            interactivePopGestureRecognizer?.isEnabled = !isRootVC
        }
        
        RTRootNavigationController.attemptRotationToDeviceOrientation()
        
        /// 代理
        rt_delegate?.navigationController?(navigationController, didShow: viewController, animated: animated)
        
        
        DispatchQueue.main.async {
            self.animationComplete?(true)
            self.animationComplete = nil
        }
    }
    
    @available(iOS 7.0, *)
    public func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        
        return rt_delegate?.navigationControllerSupportedInterfaceOrientations?(navigationController) ?? .all
    }
    
    @available(iOS 7.0, *)
    public func navigationControllerPreferredInterfaceOrientationForPresentation(_ navigationController: UINavigationController) -> UIInterfaceOrientation {
        return rt_delegate?.navigationControllerPreferredInterfaceOrientationForPresentation?(navigationController) ?? .portrait
    }
    
    
    @available(iOS 7.0, *)
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return rt_delegate?.navigationController?(navigationController,interactionControllerFor: animationController)
    }
    
    
    @available(iOS 7.0, *)
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return rt_delegate?.navigationController?(navigationController, animationControllerFor: operation, from: RTSafeUnwrapViewController(fromVC)!, to: RTSafeUnwrapViewController(toVC)!)
    }
}


// MARK: - UIGestureRecognizerDelegate
extension RTRootNavigationController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer == self.interactivePopGestureRecognizer
    }
    
    
}
