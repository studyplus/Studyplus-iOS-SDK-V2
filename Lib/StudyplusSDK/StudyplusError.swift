//
//  StudyplusError.swift
//  StudyplusSDK
//
//  The MIT License (MIT)
//
//  Copyright (c) 2017 Studyplus inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation

public enum StudyplusError {
    
    case getAppDescription       
    case authFailed              
    case loginFailed             
    case studyplusInMaintenance  
    case invalidStudyplusSession 
    case networkUnavailable      
    case serverError             
    case postRecordFailed
    case notConnected            
    case unknownUrl(URL)
    case unknownReason(String)

    internal init(_ code: Int) {
        
        switch code {
        case 1000:
            self = .getAppDescription
        case 2000:
            self = .authFailed
        case 3000:
            self = .loginFailed
        case 4000:
            self = .studyplusInMaintenance
        case 5000:
            self = .invalidStudyplusSession
        case 6000:
            self = .networkUnavailable
        case 7000:
            self = .serverError
        case 8000:
            self = .postRecordFailed
        case 9000:
            self = .notConnected
        default:
            self = .unknownReason("Unexpected Error errorCode: \(code).")
        }
    }
    
    internal init(_ httpStatusCode: Int, _ message: String) {
        
        switch (httpStatusCode) {
        case 400:
            self = .postRecordFailed
        case 401:
            self = .invalidStudyplusSession
        case 500:
            self = .serverError
        case 503:
            self = .studyplusInMaintenance
        default:
            self = .unknownReason("Unexpected http status: \(httpStatusCode), message: \(message).")
        }
    }
    
    public func code() -> Int {
        
        switch self {
        case .getAppDescription:
            return 1000
        case .authFailed:
            return 2000
        case .loginFailed:
            return 3000
        case .studyplusInMaintenance:
            return 4000
        case .invalidStudyplusSession:
            return 5000
        case .networkUnavailable:
            return 6000
        case .serverError:
            return 7000
        case .postRecordFailed:
            return 8000
        case .notConnected:
            return 9000
        case .unknownUrl(_):
            return 10000
        case .unknownReason(_):
            return 90000
        }
    }
    
    public func message() -> String {
        
        switch self {
        case .getAppDescription:
            return "Failed to get information about application. (400 bad request)"
        case .authFailed:
            return "Failed to authorize Studyplus user. (400 bad request)"
        case .loginFailed:
            return "Failed to login to Studyplus. (400 bad request)"
        case .studyplusInMaintenance:
            return "Maybe Studyplus is in temporary maintenance."
        case .invalidStudyplusSession:
            return "Studyplus session is invalid."
        case .networkUnavailable:
            return "Network is not available."
        case .serverError:
            return "Some error(s) occurred in Studyplus server."
        case .postRecordFailed:
            return "Failed to post study record. (400 bad request)"
        case .notConnected:
            return "Not Connected, so accessToken is nill"
        case let .unknownUrl(url):
            return "Unknown Url: \(url.absoluteString)."
        case let .unknownReason(reason):
            return "Unknown Error: \(reason)."
        }
    }
}
