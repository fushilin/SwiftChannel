

import ObjectMapper
import UIKit

public class OptionModel: Mappable {
      /**
     currentPage = 20;
     datas
     pageSize = 20;
     totalPage = 80;
     totalRecord = 1599;
     */
    var currentPage: String  = ""
    var  datas : [OptionData] = [OptionData] ()
    var pageSize: String = ""
    var totalPage: String = ""
    var totalRecord: String = ""
    
    public func mapping(map: Map) {
        currentPage    <-  map["currentPage"]
        datas   <-    map["datas"]
        pageSize      <- map["pageSize"]
        totalPage   <- map["totalPage"]
        totalRecord <- map["totalRecord"]
        
    }
    
    
    required  convenience public init?(map: Map) {
     self.init()
        mapping(map: map)
    }
    init() {
    }
  
    //父类的init方法是必须去实现的
 
    
    required convenience public init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    func encode(with aCoder: NSCoder) {
        
    }
    
    
}


/// 内部数据解析
open class OptionData:NSObject, Mappable {
    
    var code: String = ""
    var createTime:String = ""
    var  id: String = ""
    var name: String = ""
    var sort: String = ""
    var ts: String = ""
    var tsCode: String = ""
    var type: Int = 0
    var userId:String = ""
    
 var OptionSocketBackDataStockData:OptionSocketBackDataStockData?
    var option: Bool = false
    
    public required convenience init?(map: Map) {
        self.init()
        mapping(map: map )
        
    }
    
    public func mapping(map: Map) {
        code  <- map["code"]
        createTime <-  map["createTime"]
        id <-   map["id"]
        name <-  map["name"]
        sort <- map["sort"]
        ts <- map["ts"]
        tsCode <-  map["tsCode"]
        type <-  map["type"]
        userId  <-  map["userId"]
        
    }
    
    
}
