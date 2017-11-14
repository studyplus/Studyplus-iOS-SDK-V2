//
//  StudyplusAPIRequest.swift
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

internal struct StudyplusAPIRequest {
    
    private let apiVersion: Int = 1
    private let accessToken: String
    
    internal init(accessToken: String) {
        self.accessToken = accessToken
    }

    internal func post(path: String, params: [String: Any], success: @escaping (_ response: [AnyHashable: Any]) -> Void, failure: @escaping (_ error: StudyplusError) -> Void) {
        
        start(path: path, method: "POST", body: params, success: { (response) in
            
            DispatchQueue.main.async {
                success(response)
            }
        
        }, failure: { statusCode, response in

            DispatchQueue.main.async {
                if let message: String = response?["message"] as? String {
                    failure(StudyplusError(statusCode, message))
                } else {
                    failure(.unknownReason("Not connected to the network or StudyplusAPIRequest Error"))
                }
            }
        })
    }
    
    // MARK: - private
    
    private func start(path: String, method: String, body: [String: Any], success: @escaping (_ response: [AnyHashable: Any]) -> Void, failure: @escaping (_ statusCode: Int, _ response: [String: Any]?) -> Void) {

        guard let url = buildUrl(path: path) else {
            failure(0, nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        do {
            let data = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            request.addValue("application/json; charaset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = data
        } catch {
            failure(0, nil)
            return
        }
        
        request.addValue("OAuth " + accessToken, forHTTPHeaderField: "HTTP_AUTHORIZATION")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                failure(0, nil)
                return
            }
            
            guard let httpResponse: HTTPURLResponse = response as? HTTPURLResponse else {
                failure(0, nil)
                return
            }
            
            switch httpResponse.statusCode {
            case 200, 201, 202:
                guard let data = data else {
                    failure(0, nil)
                    return
                }
                
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    guard let obj = jsonObject as? [String: Any] else {
                        failure(0, nil)
                        return
                    }
                    
                    success(obj)

                } catch {
                    #if DEBUG
                        print("-- StudyplusAPIRequest Json Error Path: \(url.absoluteString), Method: \(method), Description: \(error.localizedDescription) --")
                    #endif
                    failure(httpResponse.statusCode, ["message": error.localizedDescription])
                }
            case 204:
                success([:])
                return
            default:
                #if DEBUG
                    print("-- StudyplusAPIRequest Path: \(url.absoluteString), Method: \(method), StatusCode: \(httpResponse.statusCode) --")
                #endif
                guard let data = data else {
                    failure(httpResponse.statusCode, nil)
                    return
                }
                
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    failure(httpResponse.statusCode, jsonObject as? [String: Any])
                    return
                    
                } catch let jsonError {
                    failure(httpResponse.statusCode, ["message": jsonError.localizedDescription])
                }
            }
        }
        
        #if DEBUG
            NSLog("StudyplusAPIRequest path:%@ method:%@", url.absoluteString, method)
        #endif
        
        task.resume()
    }
    
    private func buildUrl(path: String) -> URL? {
        
        let fullPath: String = "https://external-api.studyplus.jp/v\(apiVersion)/\(path)"
        guard let url = URL(string: fullPath) else { return nil }
        return url
    }
}
