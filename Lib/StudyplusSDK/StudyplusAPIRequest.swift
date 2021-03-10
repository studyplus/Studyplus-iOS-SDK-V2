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

    private static let endPoint: String = "https://external-api.studyplus.jp"
    private static let path: String = "/v1/study_record"
    private let studyRecordUrl: URL = URL(string: endPoint + path)!

    private let accessToken: String
    private var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601

        return encoder
    }

    internal init(accessToken: String) {
        self.accessToken = accessToken
    }

    internal func post(_ record: StudyplusRecord,
                       success: @escaping () -> Void,
                       failure: @escaping (_ error: StudyplusError) -> Void) {
        studyRecord(record, success: {
            DispatchQueue.main.async {
                success()
            }
        }, failure: { error in
            DispatchQueue.main.async {
                failure(error)
            }
        })
    }

    private func studyRecord(_ record: StudyplusRecord,
                             success: @escaping () -> Void,
                             failure: @escaping (_ error: StudyplusError) -> Void) {
        var request = URLRequest(url: studyRecordUrl)
        request.httpMethod = "POST"
        request.addValue("application/json; charaset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("OAuth " + accessToken, forHTTPHeaderField: "Authorization")
        request.httpBody = try? encoder.encode(record)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard data != nil, error == nil, let response = response as? HTTPURLResponse else {
                failure(.postRecordFailed)
                return
            }

            guard (200...204).contains(response.statusCode) else {
                failure(StudyplusError(response.statusCode, ""))
                return
            }

            success()
        }

        task.resume()
    }
}
