//
//  KRWSManager.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/19.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import Starscream

let authAccount = "authenticate"

public class KRWSManager: NSObject ,WebSocketDelegate {
    
    var reConnectTime = 0//重连时间
    
    var isConnected = false
    
    var hasAuth = false
    
    var index : Int?
    
    var socket: WebSocket?
    
    var url = ""
    
    var currentAccount : KRAccountEntity?
    
    public static var sharedInstance : KRWSManager {
        struct Static {
            static let instance : KRWSManager = KRWSManager()
        }
        return Static.instance
    }
    
    public func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("Connect success : \(headers)")
//            if KRSwapInfoManager.sharedInstance.allTickerInfoObs.count > 0 {
//                var instruments : Array<Int> = []
//                for item in KRSwapInfoManager.sharedInstance.allTickerInfoObs {
//                    do {
//                        let temp_entity = try item.value()
//                        instruments.append(temp_entity.instrument_id)
//                    } catch {
//                    }
//                }
//                KRSwapWsDataManager.sharedInstance.ws_subscribeSwapTicker(instruments)
//            }
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
//            print("接收文本信息\(string)")
            let messageDict = String.stringValueDic(string) ?? [:]
            KRSwapWsDataManager.sharedInstance.ws_dealSwapData(messageDict)
        case .binary(let data):
            print("接收二进制信息\(data)")
        case .ping(let data):
            print("ping\(data!)")
        case .pong(let data):
            print("pong\(data!)")
        case .viabilityChanged(_):
                break
        case .reconnectSuggested(_):
                break
        case .error(let error):
            isConnected = false
            handleError(error)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                //失败重连
                self.disconnect()
                self.connectSever(self.url)
            }
        case .cancelled:
            isConnected = false
            print("cancel link")
        }
    }
    
    func handleError(_ error: Error?) {
        if let e = error as? WSError {
            print("websocket encountered an error: \(e.message)")
        } else if let e = error {
            print("websocket encountered an error: \(e.localizedDescription)")
        } else {
            print("websocket encountered an error")
        }
    }
    
    //MARK:- 链接服务器
    public func connectSever(_ urlStr : String){
        if socket == nil{
            if let url = URL.init(string:urlStr){
                self.url = urlStr
                socket = WebSocket(request: URLRequest.init(url: url))
                socket?.delegate = self
                socket?.connect()
            }
        }
    }
    
    //MARK:- 账户认证
    func authenticate(_ entity: KRAccountEntity) {
        if entity.token.isEmpty == false {
            self.currentAccount = entity
            let nonce = KRBasicParameter.getNonce16()
            let uid = entity.uid
            let token = entity.token
            let version = KRBasicParameter.getAppVersion()
            let sign = NSString.init(string: token).aes256_encrypt(NetDefine.PRIVATE_KEY, nonce: nonce)
            let authArr = [uid,"iOS",version,sign,nonce]
            self.sendDataWithAction(authAccount, authArr)
        }
    }
    
    //MARK:- 关闭消息
    public func disconnect(){
        if socket != nil{
            socket?.disconnect()
            socket = nil
        }
    }
    
    //MARK:- 发送文字消息
    public func sendBrandStr(string:String){
        socket?.write(string: string)
    }
    
    public func sendBrandStr(string:String , func1 : @escaping (() -> ())){
        socket?.write(string: string, completion: {
            func1()
        })
    }
    
    public func sendBinary(data:Data){
        socket?.write(data: data)
    }
    
    public func sendBinary(data:Data , func1 : @escaping (() -> ())){
        socket?.write(data: data, completion: {
            func1()
        })
    }
    
    /**
    发送通用格式的数据
    
    @param action 命令 (subscribe, unsubscribe)
    @param args 参数
    */
    func sendDataWithAction(_ action : String, _ args : Array<String>) {
        let sendDict = ["action":action,"args":args] as NSDictionary
        let senStr = sendDict.mj_JSONString()
        sendBrandStr(string: senStr!)
    }
}
