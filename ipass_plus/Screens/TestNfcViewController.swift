//
//  TestNfcViewController.swift
//  ipass_plus
//
//  Created by MOBILE on 21/10/24.
//

import UIKit
import CoreNFC

class TestNfcViewController: UIViewController, NFCNDEFReaderSessionDelegate, NFCTagReaderSessionDelegate{
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: any Error) {
        
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        if case let .iso7816(tag) = tags.first! {
            session.connect(to: tags.first!) { (error) in
                if error == nil {
                    let apduCommand = NFCISO7816APDU(instructionClass: 0x00, instructionCode: 0xA4, p1Parameter: 0x04, p2Parameter: 0x00, data: Data(), expectedResponseLength: -1)
                   // tag.sendCommand(apdu: apduCommand) { (response, sw1, sw2, *),<#arg#>  in
//                        if let responseData = response {
//                            print("Data received: \(responseData)")
//                        }
                  //  }
                }
            }
        }
    }
    
    
    
    
    var nfcSession: NFCNDEFReaderSession?
    
    func sendCustomAPDU(to tag: NFCISO7816Tag) {
        let customAPDU = NFCISO7816APDU(
            instructionClass: 0x00, // Example class
            instructionCode: 0xA4, // Example code
            p1Parameter: 0x04, // Example parameter
            p2Parameter: 0x00, // Example parameter
            data: Data(), // Command data
            expectedResponseLength: -1 // Expected response length
        )
        tag.sendCommand(apdu: customAPDU) { (response, sw1, sw2, error) in
            if let error = error {
                print("Error sending APDU: \(error.localizedDescription)")
            } else {
                print("Received response: \(response)")
            }
        }
    }

    func logNFCEvent(event: String) {
        print("NFC Event: \(event)")
    }
           
           // Start NFC Session
           func startNFCSession() {
               let nfcSession = NFCTagReaderSession(pollingOption: [.iso14443], delegate: self, queue: nil)
               nfcSession?.alertMessage = "Hold your iPhone near the Jordanian ID card."
               nfcSession?.begin()
                      
           }

           // Delegate method when an NFC tag is detected
           func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
               for message in messages {
                   for record in message.records {
                       let payload = String(data: record.payload, encoding: .utf8)
                       print("Detected NFC Payload: \(payload ?? "No data")")
                   }
               }
           }

    func readerSession(_ session: NFCReaderSession, didInvalidateWithError error: Error) {
         if let error = error as? NFCReaderError, error.code == .readerTransceiveErrorTagConnectionLost {
             // Retry the connection if it's lost
             self.startNFCSession()
         }
     }
    
           // Error Handling
           func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
               print("Session invalidated: \(error.localizedDescription)")
           }
       

    @IBAction func method1(_ sender: Any) {
        startNFCSession()
    }
    
    @IBAction func startProcess(_ sender: Any) {
        startISO7816Session()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    func startISO7816Session() {
        var nfcSessionq: NFCTagReaderSession?
        nfcSessionq = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
        nfcSessionq?.alertMessage = "Hold your iPhone near the ID card."
        nfcSessionq?.begin()
         }
    
    
    
    func parseCardData(tag: NFCISO7816Tag) {
           let apduCommand = NFCISO7816APDU(instructionClass: 0x00, instructionCode: 0xA4, p1Parameter: 0x04, p2Parameter: 0x00, data: Data(), expectedResponseLength: -1)
           tag.sendCommand(apdu: apduCommand) { (response, sw1, sw2, error) in
               guard error == nil else {
                   print("Error reading card: \(error!.localizedDescription)")
                   return
               }
               // Handle and parse the response data
               let personalData = String(data: response, encoding: .utf8)
               print("Card Data: \(personalData ?? "No data available")")
           }
       }

   

}
