//
//  StudyplusRecord.swift
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

private let formatter: DateFormatter = {
    let f: DateFormatter = DateFormatter()
    f.locale = Locale(identifier: "en_US_POSIX")
    f.calendar = Calendar(identifier: .gregorian)
    f.timeZone = NSTimeZone.system
    return f
}()

private extension Date {
    
    init?(dateString: String, dateFormat: String = "yyyy-MM-dd'T'HH:mm:ssZ") {
        formatter.dateFormat = dateFormat
        guard let date = formatter.date(from: dateString) else { return nil }
        self = date
    }

    func string(format: String = "yyyy-MM-dd'T'HH:mm:ssZ") -> String {
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

/**
 Study record object to post to Studyplus.
 
 Studyplusに投稿する一件の勉強記録を表現するクラスです。
 */
public struct StudyplusRecord {

    /**
     The seconds of the learning.
     勉強した時間（秒数）です。
     */
    public let duration: Double
    
    /**
     The date and time of learning.
     勉強した日時です。
     */
    public let recordedAt: Date
    
    /**
     The amount of learning.
     勉強した量です。
     
     see StudyplusRecordAmount
     */
     public let amount: StudyplusRecordAmount?

    /**
     The comment of learning.
     勉強に関するコメントです。
     */
     public let comment: String?

    /// Initialize StudyplusRecord object.
    ///
    /// 勉強記録オブジェクトを作成します。
    ///
    /// - Parameters:
    ///   - duration: Specify the seconds of the learning. 勉強した時間（秒数）を指定してください。
    ///   - recordedAt: Time the learning is ended. 学習を終えた日時。
    ///   - amount: The amount of learning. 学習量。
    ///   - comment: Studyplus timeline comment. Studyplusのタイムライン上で表示されるコメント。
    public init(duration: Double, recordedAt: Date = Date(), amount: StudyplusRecordAmount? = nil, comment: String? = nil) {
        
        self.duration = duration
        self.recordedAt = recordedAt
        self.amount = amount
        self.comment = comment
    }
    
    /// Return api reqest params of StudyplusRecord.
    ///
    /// 勉強記録のAPIリクエストのパラメーターを返します
    ///
    /// - Returns: Returns the parameters of the study record for posting API
    public func requestParams() -> [String: Any] {
        
        var params: [String: Any] = [:]
        
        params["duration"] = NSNumber(value: self.duration)
        params["recorded_at"] = self.recordedAt.string(format: "yyyy-MM-dd HH:mm:ss")
        
        if let comment = self.comment {
            params["comment"] = comment
        }
        
        if let amount = self.amount {            
            for (k, v) in amount.requestParams() {
                params[k] = v
            }
        }
        
        return params
    }
}
