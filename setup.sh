#!/bin/sh -x

rm Podfile.lock
rm Cartfile.resolved
rm -rf Pods
rm -rf StudyplusSDK.xcworkspace

pod install
carthage update --no-use-binaries --platform iOS

