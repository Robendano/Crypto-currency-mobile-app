//
//  HttpRequest.swift
//  Crypto Currency
//
//  Created by Aidar Bekturov on 13/12/21.
//

import Foundation
import Alamofire
import SystemConfiguration

class HTTPRequest {
    // maing Service where we catching errors and getting success
    typealias Success = (Data?) -> ()
    typealias Error = (String) -> ()
    
    private func request(method: HTTPMethod, url: String, parameters: Parameters?, header: HTTPHeaders, complition: @escaping Success, error: @escaping Error) {
        AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseData(completionHandler: { (response) in
            guard response.response != nil else {
                error(ServerConstants.ErrorMessage.UNABLE_LOAD_DATA)
                return
            }
            guard let statusCode = response.response?.statusCode else {
                error(ServerConstants.ErrorMessage.NO_HTTP_STATUS_CODE)
                return
            }
            
            switch statusCode {
                
            case HTTPStatusCode.unauthorized.statusCode:
                error(ServerConstants.ErrorMessage.UNAUTHORIZED)
                break
                
            case HTTPStatusCode.notFound.statusCode:
                error(ServerConstants.ErrorMessage.NOT_FOUND)
                break
                
            case HTTPStatusCode.forbidden.statusCode:
                error(ServerConstants.ErrorMessage.FORBIDDEN)
                break
                
            case HTTPStatusCode.internalServerError.statusCode,
                HTTPStatusCode.serviceError.statusCode,
                HTTPStatusCode.serviceUnavailable.statusCode,
                HTTPStatusCode.serviceDowntime.statusCode:
                error(ServerConstants.ErrorMessage.SERVER_ERROR)
                break
                
            case HTTPStatusCode.badRequest.statusCode:
                error(ServerConstants.ErrorMessage.BAD_REQUEST)
                break
                
            case HTTPStatusCode.ok.statusCode,
                HTTPStatusCode.accepted.statusCode,
                HTTPStatusCode.done.statusCode,
                HTTPStatusCode.created.statusCode:
                guard let safeData = response.data else {return}
                complition(safeData)
                break
                
            default:
                error("")
            }
        })
    }
    // get method
    internal func get(url: String, header: HTTPHeaders, complition: @escaping Success, error: @escaping Error) {
        request(method: .get, url: url, parameters: nil, header: header, complition: complition, error: error)
    }
    // post method
    internal func post(url: String, parameters: Parameters, header: HTTPHeaders, complition: @escaping Success, error: @escaping Error) {
        request(method: .post, url: url, parameters: parameters, header: header, complition: complition, error: error)
    }
    // put method
    internal func put(url: String, parameters: Parameters, header: HTTPHeaders, complition: @escaping Success, error: @escaping Error) {
        request(method: .put, url: url, parameters: parameters, header: header, complition: complition, error: error)
    }
    
    // MARK: - Internet Connectivity
        // checking internet connetctivity
    static func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret
    }
}
