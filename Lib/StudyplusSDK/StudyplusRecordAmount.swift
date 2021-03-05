//
//  StudyplusRecordAmount.swift
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

/**
 The class that represents the amount of learning.
 
 学習量を表すクラスです。
 */
public struct StudyplusRecordAmount {

    /**
     Learning amount.
     
     学習量
     */
    public let amount: UInt?

    /**
     Range of learning amount.
     
     学習範囲
     */
    public let range: (from: UInt, to: UInt)?
    
    /// Initialize the Amount object with only the total amount of learning.
    ///
    /// 合計の学習量のみを持つ Amount オブジェクトを生成して返します。
    ///
    /// - Parameter amount: learning amount. 学習量。
    public init(amount: UInt) {
        self.amount = amount
        self.range = nil
    }
    
    /// Initialize the Amount object with a range of learning amount.
    ///
    /// 学習量を範囲で持つ Amount オブジェクトを生成して返します。
    ///
    /// - Parameter range: Starting point and ending point of learning amount. 学習量の起点と終点。
    public init?(range: (from: UInt, to: UInt)) {

        guard range.from <= range.to else {
           return nil
        }
        
        self.amount = nil
        self.range = range
    }
    
    internal func requestParams() -> [String: Any] {
        
        var params: [String: Any] = [:]
        
        if let amount = self.amount {
            params["amount"] = NSNumber(value: amount)
        }

        if let range = self.range {
            params["start_position"] = NSNumber(value: range.from)
            params["end_position"] = NSNumber(value: range.to)
        }
        
        return params
    }
}
