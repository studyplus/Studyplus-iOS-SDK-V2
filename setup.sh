#!/bin/sh -x

rm Podfile.lock
rm -rf Pods
rm -rf StudyplusSDK.xcworkspace

pod install
