//
//  HTTPStatusCode.swift
//  MadDevs(Crypto)
//
//  Created by Рамазан Юсупов on 2/8/21.
//

import Foundation

public enum HTTPStatusCode: Int {
    case ok = 200
    case created = 201
    case accepted = 202
    case done = 206
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case conflict = 409
    case serverIsBusy = 429
    case internalServerError = 500
    case serviceError = 502
    case serviceUnavailable = 503
    case serviceDowntime = 504
    
    public var statusCode : Int {
        return self.rawValue
    }
}
