//
//  OptionPortSocketArray.swift
//  ZRNetworkModule
//
//  Created by 我演示 on 2019/8/4.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit

public class OptionPortSocketArray: NSObject {
    /**
     dict["dataType"] = "3"
     dict["ts"] = openData?.ts
     dict["code"] = openData?.code
     dict["type"] = openData?.type
     
     var code: String = ""
     var createTime:String = ""
     var  id: String = ""
     var name: String = ""
     var sort: String = ""
     var ts: String = ""
     var tsCode: String = ""
     var type: Int = 0
     var userId:String = ""
     */
    /// 设置基本属性， 应该还有发包超时的问题，
    /// 如果返回时间超出预期，应该提醒继续发送一次
    var dataType: String = ""
    var ts : String = ""
    var code: String = ""
    var type : Int = 0
    /// 使用闭包操作
     typealias   TimeoutClosure = (() -> Void)
    
    internal var timeOutClosure: TimeoutClosure?
    ///超时时间参数
    internal var timeout: Int = 0
    /// 定时器校验
    private var timerCheck: Bool = false
    /// 定时器,回调main函数里面
    private var timer: DispatchSourceTimer?
    /// 超时回调
    internal var closure: SendSocketPakgsClosure?
    
    
    public   convenience init(timeout: Int = 60,closure: SendSocketPakgsClosure? = nil) {
        self.init()
        self.timeout = timeout
        self.closure = closure
    }
    internal func startTimeout() {
        
    
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
            self.timer?.schedule(deadline: .now(), repeating:.seconds(timeout))
            
            self.timerCheck = false
            
            /// 设置回调
            self.timer?.setEventHandler(handler: { [weak self] in
                guard let optionSocket = self else { return }
                if  optionSocket.timerCheck {
                    optionSocket .timeOutClosure?()
                    optionSocket .startTimeout()
                }
                optionSocket.timerCheck = true
            })
            /// 开始
            self.timer?.resume()
        
    }
    /// 停止
    internal func stopTimeout() {
        self.timer?.cancel()
        self.timer = nil
    }
    
    /// 析构函数
    deinit {
        stopTimeout()
    }

}
extension OptionPortSocketArray{
    
    public  func socketArraySend(sourceArray:Array<OptionData>) -> ([String:Any] ){
        
        var  openArray:[Any] = []
        for item in sourceArray
        {
            var dict = [String:Any]()
            /// 数据抽取
            dict["dataType"] = item.type
            
            dict["ts"] = item.ts
            dict["code"] = item.code
            dict["type"] = item.type
            
            openArray.append(dict)
        }
        var topics = [String: Any]()
        topics["topics"]  = openArray
        
        return topics
        
    }
    
}
