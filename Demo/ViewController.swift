//
//  ViewController.swift
//  Demo
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

import UIKit
import StudyplusSDK

class ViewController: UIViewController, StudyplusLoginDelegate {

    @IBOutlet weak var isConnectedLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    var duration: TimeInterval = TimeInterval()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Studyplus.shared.delegate = self
    }
        
    // MARK: - Label

    private func updateIsConnected() {
        isConnectedLabel.text = Studyplus.shared.isConnected() ? "True" : "False"
    }

    // MARK: - Button Action
        
    @IBAction func loginButton(_ sender: UIButton) {
        Studyplus.shared.login()
    }
    
    @IBAction func logoutButton(_ sender: UIButton) {
        Studyplus.shared.logout()
        updateIsConnected()
        resultLabel.text = "Logout"
    }
    
    @IBAction func connectedButton(_ sender: UIButton) {
        updateIsConnected()
        resultLabel.text = ""
    }
    
    @IBAction func postStudyRecordButton(_ sender: UIButton) {
        
        self.resultLabel.text = ""
        
        let recordAmount: StudyplusRecordAmount = StudyplusRecordAmount(amount: 10)
        let record: StudyplusRecord = StudyplusRecord(duration: duration, recordedAt: Date(), amount: recordAmount, comment: "Today, I studied like anything.")

        Studyplus.shared.post(studyRecord: record, success: { 
            
            self.resultLabel.text = "Success to post your studyRecord to Studyplus App"
            
        }, failure: { error in
            
            self.resultLabel.text = "Error Code: \(error.code()), Message: \(error.message())"
        })
    }
    
    // MARK: - Picker
    
    @IBAction func studyRecordDurationPicker(_ sender: UIDatePicker) {
        duration = sender.countDownDuration
    }
    
    // MARK: - StudyplusLoginDelegate

    func studyplusDidSuccessToLogin() {
        print("-- Called studyplusDidSuccessToLogin --")
        resultLabel.text = "Login succeeded"
        updateIsConnected()
    }
    
    func studyplusDidFailToLogin(error: StudyplusError) {
        print("-- Called studyplusDidFailToLogin --")
        resultLabel.text = "Error Code: \(error.code()), Message: \(error.message())"
        updateIsConnected()
    }
    
    func studyplusDidCancelToLogin() {
        print("-- Called studyplusDidCancelToLogin --")
        resultLabel.text = "Login canceled"
        updateIsConnected()
    }    
}
