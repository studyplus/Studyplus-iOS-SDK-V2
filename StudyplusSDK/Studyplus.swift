//
//  Studyplus.swift
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
import KeychainAccess

/**
 The class for using Studyplus.
 For example, you can authenticate in Studyplus account, de-authentication, and post study record.
 
 Studyplusの各機能を使うためのクラスです。
 Studyplusアカウントとの連携、連携解除、勉強記録の投稿ができます。
 */
final public class Studyplus {
    
    /**
     Returns the shared defaults object.
     
     Studyplusのオブジェクトを返します
     */
    public static let shared: Studyplus = Studyplus()
    
    /**
     When set to true, then call back to the delegate without posting the actual processing.

     trueの場合、勉強記録の投稿時に実際の通信は行わずdelegateのコールバックメソッドを呼び出して処理を終了します。
     */
    public var debug: Bool = false
    
    /**
     Consumer Key for Studyplus API.

     StudyplusAPI用のConsumer Keyです。
     */
    public private(set) var consumerKey: String
    
    /**
     Consumer Secret for Studyplus API.

     StudyplusAPI用のConsumer Secretです。
     */
    public private(set) var consumerSecret: String
    
    /**
     see StudyplusLoginDelegate protocol
     */
    public weak var delegate: StudyplusLoginDelegate?

    /**
     When set to true, if Studyplus is not installed, AppStore starts when auth/login methods are called.

     trueの場合、auth、loginメソッドを呼び出したとき、StudyplusアプリがインストールされていなければAppStoreを起動します。
     */
    public var openAppStoreIfNotInstalled: Bool = true
    
    private let accessTokenStoreKey: String = "accessToken"
    private let usernameStoreKey: String = "username"
    
    /// Opens the login screen by invoking the Studyplus application.
    /// If Studyplus app is not installed and openAppStoreIfNotInstalled is true, then open the Studyplus page in AppStore.
    /// If openAppStoreIfNotInstalled is false, do nothing.
    /// After the process has returned from Studyplus application, delegate method will be called back.
    ///
    /// Studyplusアプリを起動してStudyplusログイン画面を開きます。
    /// Studyplusアプリがインストールされていない場合、 openAppStoreIfNotInstalled が true であれば、AppStore を起動して Studyplus を開きます。
    /// openAppStoreIfNotInstalled が false であれば何もしません。
    /// Studyplusアプリから操作が戻ってきた後、delegateオブジェクトのコールバックメソッドを呼び出します。
    public func login() {
        openStudyplus(command: "auth")
    }
    
    /// Cancels the cooperation with Studyplus application.
    ///
    /// Studyplusアプリとの連携を解除します。
    public func logout() {

        let k = keychain()
        do {
            try k.remove(usernameStoreKey)
            try k.remove(accessTokenStoreKey)
        } catch {
        }
    }
    
    /// Returns to whether or not it is connected with Studyplus application.
    ///
    /// Studyplusアプリと連携されているか否かを返します。
    ///
    /// - Returns: true is connected, false is not connected
    public func isConnected() -> Bool {
        return self.accessToken() != nil
    }
    
    /// Access token of Studyplus API. It is set when the auth or login is successful.
    ///
    /// StudyplusAPIのアクセストークンです。login または authが成功したとき設定されます。
    ///
    /// - Returns: accessToken
    public func accessToken() -> String? {
        
        do {
            return try keychain().get(accessTokenStoreKey)
        } catch {
            return nil
        }
    }
    
    /// Username of Studyplus account. It is set when the auth or login is successful.
    ///
    /// Studyplusアカウントのユーザ名です。login または authが成功したとき設定されます。
    ///
    /// - Returns: username
    public func username() -> String? {

        do {
            return try keychain().get(usernameStoreKey)
        } catch {
            return nil
        }
    }
    
    /// Posts a new study record to Studyplus.
    ///
    /// Studyplusに勉強記録を新規投稿します。
    ///
    /// - Parameter
    ///   - studyRecord: see StudyplusRecord
    ///   - success: callback when success to post the studyRecord
    ///   - failure: callback when failure to post the studyRecord
    public func post(studyRecord: StudyplusRecord, success: @escaping () -> Void, failure: @escaping (_ error: StudyplusError) -> Void) {
        
        if !self.isConnected() {
            failure(.notConnected)
            return
        }
        
        guard let accessToken = self.accessToken() else {
            failure(.notConnected)
            return
        }
        
        if self.debug {
            success()
            return
        }
        
        let request: StudyplusAPIRequest = StudyplusAPIRequest(accessToken: accessToken)
        request.post(path: "study_records", params: studyRecord.requestParams(), success: { (response) in
            success()
        }, failure: { error in
            failure(error)
        })
    }
    
    /// It is responsible for processing custom URL scheme when it came back from the authorization / login screen of Stuudyplus app.
    /// After handling openURL method in AppDelegate, pass the url parameter to this method.
    /// If the URL is passed by Studyplus application, calls the callback method of the delegate object.
    ///
    /// Studyplusアプリの認可・ログイン画面から戻ってきた時のカスタムURLスキーム処理を担当します。
    /// AppDelegateでopenURLをハンドリングしてから、このメソッドにurlを渡して委譲してください。
    /// Studyplusアプリ関連のURLであれば、delegateオブジェクトのコールバックメソッドを呼び出します。
    ///
    /// - Parameter appDelegateUrl: The parameter of AppDelegate#openURL method. AppDelegate#openURLメソッドで受け取ったurlパラメータをそのまま渡して下さい。
    /// - Returns: If the url is supported by StudyplusSDK, returns true. The valid URL has a __[studyplus-{consumerKey}]__ scheme, and right pathComponents and host. 渡されたurlがStudyplusSDKで対応すべきURL（スキームが __[studyplus-{consumerKey}]__ であり、host/pathComponentsが想定内であるもの）であれば true、それ以外は false を返します。
    public func handle(appDelegateUrl: URL) -> Bool {
        
        guard isAcceptableURL(url: appDelegateUrl) else {
            delegate?.studyplusDidFailToLogin(error: .unknownUrl(appDelegateUrl))
            return false
        }
        
        switch appDelegateUrl.pathComponents[1] {
        case "success":
        
            let accessToken: String = appDelegateUrl.pathComponents[2].trimmingCharacters(in: .whitespacesAndNewlines)
            let username: String = appDelegateUrl.pathComponents[3].trimmingCharacters(in: .whitespacesAndNewlines)
            
            let k = keychain()
            do {
                try k.set(accessToken, key: accessTokenStoreKey)
                try k.set(username, key: usernameStoreKey)
                delegate?.studyplusDidSuccessToLogin()
            } catch {
                delegate?.studyplusDidFailToLogin(error: .unknownReason("Could not access Keychain."))
            }

        case "fail":

            if let errorCode: Int = Int(appDelegateUrl.pathComponents[2]) {
                delegate?.studyplusDidFailToLogin(error: StudyplusError(errorCode))
            } else {
                delegate?.studyplusDidFailToLogin(error: .unknownReason("ErrorCode is nil"))
            }

        case "cancel":

            delegate?.studyplusDidCancelToLogin()

        default:
            #if DEBUG
                print("StudyplusSDK: Unknown format: \(appDelegateUrl.absoluteString)")
            #endif
            return false
        }
        
        return true
    }
    
    /// Change the consumer key and secret.
    /// Calling this method allows you to switch to another consumer key and secret. For example, you log in to Studyplus, log out, and post a study record.
    /// If multiple applications are connected with Studyplus, you need to call this method.
    /// If there is only one connected application, you do not need to call this method.
    /// If multiple applications are connected with Studyplus, do not forget to set up custom URL schemes.
    ///
    /// StudyplusAPI用のConsumer Key と Secret を変更します。
    /// このメソッドを呼ぶとStudyplusにログイン、ログアウト、勉強記録を投稿するときなどに、別の Consumer Key と Secret に切り替えることができます。
    /// 複数のアプリケーションがStudyplusと連携している場合は、このメソッドを呼ぶ必要があります。
    /// 連携されたアプリケーションが1つしかない場合は、このメソッドを呼ぶ必要はありません。
    /// 複数のアプリケーションがStudyplusと連携している場合は、カスタムURLスキーマの設定を忘れないように注意してください。
    ///
    /// - Parameter
    ///   - consumerKey: consumer key
    ///   - consumerSecret: consumer secret
    public func change(consumerKey: String, consumerSecret: String) {
        
        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret
    }
    
    // MARK: - private method
    
    private init() {

        guard let data = Bundle.main.infoDictionary?["StudyplusSDK"] as? [String: String],
              let consumerKey = data["consumerKey"],
              let consumerSecret = data["consumerSecret"] else {

            assert(false, "StudyplusSDK: *** Pleease set consumerKey and consumerSecret in your Info.plist. ***")
            print("StudyplusSDK: *** Pleease set consumerKey and consumerSecret in your Info.plist. ***")

            self.consumerKey = ""
            self.consumerSecret = ""
            return
        }
        
        if consumerKey == "set_your_consumerKey" || consumerSecret == "set_your_consumerSecret" {
            
            assert(false, "StudyplusSDK: *** Pleease set consumerKey and consumerSecret in Info.plist. ***")
            print("StudyplusSDK: *** Pleease set consumerKey and consumerSecret in your Info.plist. ***")

            self.consumerKey = ""
            self.consumerSecret = ""
            return
        }
        
        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret
    }
    
    private func keychain() -> Keychain {
        
        let serviceName: String = "Studyplus_iOS_SDK_\(consumerKey)"
        return Keychain(service: serviceName)
    }
    
    private func openStudyplus(command: String) {
        
        let urlString: String = "studyplus://external_app/" + command + "/" + consumerKey + "/" + consumerSecret

        if let url = URL(string: urlString) {
        
            applicationOpen(url)

        } else {
            
            if self.openAppStoreIfNotInstalled {
            
                let appStoreURLString: String = "https://itunes.apple.com/jp/app/mian-qiangga-leshiku-xuku!/id505410049?mt=8"
                guard let appStoreURL = URL(string: appStoreURLString) else { return }
                applicationOpen(appStoreURL)
            }
        }
    }
    
    private func applicationOpen(_ url: URL) {
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            _ = UIApplication.shared.openURL(url)
        }
    }
    
    private func isAcceptableURL(url: URL) -> Bool {

        guard let host = url.host else { return false }
        guard host == "auth-result" || host == "login-result" else { return false }
        
        guard let scheme = url.scheme else { return false }
        guard scheme == "studyplus-\(consumerKey)" else { return false }
        
        if url.pathComponents.isEmpty {
            return false
        }
        
        return true
    }
}
