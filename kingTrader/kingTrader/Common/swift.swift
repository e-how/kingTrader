//
//  swift.swift
//  kingTrader
//
//  Created by kt on 15/10/16.
//  Copyright © 2015年 张益豪. All rights reserved.
//   连接jwt 加密类库 

import Foundation

import JWT

class JWTEncodeTests : NSObject {
    func testEncodingJWT(str:AnyObject)->String {
        
        let payload = ["name": "zhangyihao123","id":str,"exp":str] as Payload
        
        let jwt = JWT.encode(payload, algorithm: .HS256("weisd"))
        
        print(jwt)
        return jwt
    }
    
    
}