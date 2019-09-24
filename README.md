StudyplusSDK-V2
=======

StudyplusSDK-V2 is [Studyplus iOS SDK](https://github.com/studyplus/Studyplus-iOS-SDK) for Swift.

## Requirements

 * iOS 9.0 or above
 * Swift 4.0 or above

## Dependency
 * [KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess)

## Install

### [CocoaPods](https://cocoapods.org/)
Add the following line to your Podfile:
```ruby
use_frameworks!

target 'YOUR_TARGET_NAME' do
  pod 'StudyplusSDK-V2'
end
```

### [Carthage](https://github.com/Carthage/Carthage)
Add the following line to your Cartfile:
```swift
github "studyplus/Studyplus-iOS-SDK-V2"
```

## Usage

- If you don't have consumerKey and consumerSecret, please contact https://info.studyplus.co.jp/contact/studyplus-api

### ① Set up custom URL scheme

- set __studyplus-*{your consumer key}*__ to URL Types. (ex. studyplus-MIoh79q7pfMbTUVA3BNsSeTaZRcOK3yg )

![xcode](https://github.com/studyplus/Studyplus-iOS-SDK-V2/blob/master/docs/set_url_scheme.png)

### ② Set up consumerKey and consumerSecret

- set __consumerKey__ and __consumerSecret__ in your Info.plist.

```
<key>StudyplusSDK</key>
<dict>
  <key>consumerKey</key>
  <string>set_your_consumerKey</string>
  <key>consumerSecret</key>
  <string>set_your_consumerSecret</string>
</dict>
```

### ③ Set up LSApplicationQueriesSchemes

- Set LSApplicationQueriesSchemes in your info.plist for checking if studyplus is installed.

```
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>studyplus</string>
</array>
```

### Initialize

```Swift

// when carthage is StudyplusSDK, cocoapods is StudyplusSDK_V2
import StudyplusSDK_V2

class ViewController: UIViewController, StudyplusLoginDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        Studyplus.shared.delegate = self
    }

    // ...
}
```

### Login
```Swift

// when carthage is StudyplusSDK, cocoapods is StudyplusSDK_V2
import StudyplusSDK_V2

class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return Studyplus.shared.handle(appDelegateUrl: url)
    }
}
```

```Swift

// when carthage is StudyplusSDK, cocoapods is StudyplusSDK_V2
import StudyplusSDK_V2

class ViewController: UIViewController, StudyplusLoginDelegate {

    // ...

    // MARK: - Login

    @IBAction func loginButton(_ sender: UIButton) {
        Studyplus.shared.login()
    }

    // MARK: - StudyplusLoginDelegate

    func studyplusDidSuccessToLogin() {
        // do something
    }

    func studyplusDidFailToLogin(error: StudyplusError) {
        // do something
    }

    func studyplusDidCancelToLogin() {
        // do something
    }
}
```

### Post studyRecord to Studyplus

```Swift

// when carthage is StudyplusSDK, cocoapods is StudyplusSDK_V2
import StudyplusSDK_V2

class ViewController: UIViewController, StudyplusLoginDelegate {

    // ...

    // MARK: - Post studyRecord to Studyplus

    @IBAction func postStudyRecordButton(_ sender: UIButton) {
        let recordAmount: StudyplusRecordAmount = StudyplusRecordAmount(amount: 10)
        let record: StudyplusRecord = StudyplusRecord(duration: duration, recordedAt: Date(), amount: recordAmount, comment: "Today, I studied like anything.")

        Studyplus.shared.post(studyRecord: record, success: {

            // do something

        }, failure: { error in

            print("Error Code: \(error.code()), Message: \(error.message())")
        })
    }
}
```

## Demo app

![demo](https://github.com/studyplus/Studyplus-iOS-SDK-V2/blob/master/docs/demoapp_v2.jpg)

- Set __studyplus-*{your consumer key}*__ to URL Types in Demo.
- Set __consumerKey__ and __consumerSecret__ in Info.plist of Demo.
- Select Demo Scheme and Run.

## License

- [MIT License.](http://opensource.org/licenses/mit-license.php)
