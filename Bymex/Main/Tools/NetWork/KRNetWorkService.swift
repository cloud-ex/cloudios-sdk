//
//  KRNetWorkService.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/8.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Moya
import RxSwift
import Alamofire

class NetWorkService<Target> : MoyaProvider<Target> where Target : TargetType {
    
    init(
        endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider.defaultEndpointMapping,
        requestClosure: @escaping MoyaProvider<Target>.RequestClosure,
        stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub,
        manager: Session = Session.default,// MoyaProvider<Target>.defaultAlamofireManager()
        plugins: [PluginType] = []
        ) {
        
//        super.init(endpointClosure: endpointClosure,
//                   requestClosure: requestClosure,
//                   stubClosure: stubClosure,
//                   manager: manager,
//                   plugins: plugins)
        super.init(endpointClosure: endpointClosure,
                   requestClosure: requestClosure,
                   stubClosure: stubClosure,
                   session: manager,
                   plugins: plugins)
    }
    
}

private let swapRequestClosure: MoyaProvider<SwapAPIEndPoint>.RequestClosure = {( endpoint: Endpoint, closure: MoyaProvider.RequestResultClosure) in
    do {
        let urlRequest = try endpoint.urlRequest()
        closure(.success(urlRequest))
    }
    catch {
        
    }
}

private let appRequestClosure: MoyaProvider<AppAPIEndPoint>.RequestClosure = {( endpoint: Endpoint, closure: MoyaProvider.RequestResultClosure) in
    do {
        let urlRequest = try endpoint.urlRequest()
        closure(.success(urlRequest))
    }
    catch {
        
    }
}

private let settlesRequestClosure: MoyaProvider<SettlesAPIPoint>.RequestClosure = {( endpoint: Endpoint, closure: MoyaProvider.RequestResultClosure) in
    do {
        let urlRequest = try endpoint.urlRequest()
        closure(.success(urlRequest))
    }
    catch {
        
    }
}

let swapApiEndpointClosure = { (target: SwapAPIEndPoint) -> Endpoint in
    let sampleResponseClosure = { return EndpointSampleResponse.networkResponse(200, target.sampleData) }
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
    let method = target.method
    
    return Endpoint(url: url, sampleResponseClosure: sampleResponseClosure, method: target.method, task: target.task, httpHeaderFields: target.headers)
}

let appApiEndpointClosure = { (target: AppAPIEndPoint) -> Endpoint in
    let sampleResponseClosure = { return EndpointSampleResponse.networkResponse(200, target.sampleData) }
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
    let method = target.method
    
    return Endpoint(url: url, sampleResponseClosure: sampleResponseClosure, method: target.method, task: target.task, httpHeaderFields: target.headers)
}

let settlesApiEndpointClosure = { (target: SettlesAPIPoint) -> Endpoint in
    let sampleResponseClosure = { return EndpointSampleResponse.networkResponse(200, target.sampleData) }
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
    let method = target.method
    
    return Endpoint(url: url, sampleResponseClosure: sampleResponseClosure, method: target.method, task: target.task, httpHeaderFields: target.headers)
}

let swapApi = NetWorkService(endpointClosure:swapApiEndpointClosure,requestClosure: swapRequestClosure)
let appAPI = NetWorkService(endpointClosure:appApiEndpointClosure,requestClosure: appRequestClosure)
let settlesAPI = NetWorkService(endpointClosure:settlesApiEndpointClosure,requestClosure: settlesRequestClosure)
