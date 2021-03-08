//
//  StudyplusLoginDelegate.swift
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
 The delegate to receive callbacks from Studyplus.
 
 Studyplusオブジェクトに対する各種操作後のコールバックを受けるdelegateです。
 */
public protocol StudyplusLoginDelegate: class {

    /// Will be called after the Studyplus#login was successful.
    ///
    /// Studyplus#login が成功した後に呼ばれます。
    func studyplusDidSuccessToLogin()

    /// Will be called after the Studyplus#login was failure.
    ///
    /// Studyplus#login が失敗した後に呼ばれます。
    ///
    /// - Parameter error: failure reason, see StudyplusError. 失敗の理由です。詳細は StudyplusError を参照してください。
    func studyplusDidFailToLogin(error: StudyplusError)

    // MARK: - optional

    /// Will be called after the Studyplus#login was cancelled.
    ///
    /// Studyplus#login がキャンセルされた後に呼ばれます。
    func studyplusDidCancelToLogin()
}

public extension StudyplusLoginDelegate {

    func studyplusDidCancelToLogin() {
    }
}
