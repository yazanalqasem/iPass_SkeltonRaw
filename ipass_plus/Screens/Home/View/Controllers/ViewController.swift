////
////  ViewController.swift
////  ipass_plus
////
////  Created by MOBILE on 30/01/24.
////
//
import UIKit
import DocumentReader
import SafariServices
import Amplify
import FaceLiveness
import SwiftUI
import AWSPluginsCore
import AVFoundation
import Toast_Swift
import WebKit
import Alamofire
import EasyTipView
import CoreNFC

//  ACtual code -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate, NFCNDEFReaderSessionDelegate {
    

    //MARK: IBoutlets
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var optionsTV: UITableView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var actionSettingBtn: UIButton!
    @IBOutlet weak var actionCameraBtn: UIButton!
    @IBOutlet weak var actionOpenGalleryBtn: UIButton!
    
    var nfcSession: NFCNDEFReaderSession?

        func beginScanning() {
            nfcSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
            nfcSession?.alertMessage = "Hold your iPhone near the NFC tag."
            nfcSession?.begin()
        }
        
        func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
            // Handle errors or session cancellation
            if let readerError = error as? NFCReaderError {
                print("NFC Error: \(readerError.localizedDescription)")
                DispatchQueue.main.async {
                    self.view.makeToast("NFC Error: \(readerError.localizedDescription)", duration: 2)

                }
            }
        }

        func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
            // Process detected NFC messages
            for message in messages {
                for record in message.records {
                    if let payloadText = String(data: record.payload, encoding: .utf8) {
                        print("NFC Tag Payload: \(payloadText)")
                        DispatchQueue.main.async {
                            self.view.makeToast("NFC Tag Payload: \(payloadText)", duration: 2)

                        }
                    }
                }
            }
        }
    
    func testDismiss() {
        print("DISMISSED")
    }
    
    
    //MARK: Propertes
    let numberFormatter = NumberFormatter()
    let imagePicker = UIImagePickerController()
    private var selectedScenario: String?
    var isCustomUILayerEnabled: Bool = false
    private var sectionsData: [CustomizationSection] = []
    
    var imageSourceType = ""
    var isSpoofingType = false

    lazy var animationTimer = Timer.scheduledTimer(timeInterval: 1.0/60, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    
    
    let customLayerJsonString =
    """
    {
    "objects": [
    {
    "label": {
      "text": "Searching document...",
      "fontStyle": "normal",
      "fontColor": "#FF444444",
      "fontSize": 24,
      "alignment": "center",
      "background": "#BBDDDDDD",
      "borderRadius": 10,
      "padding": {
        "start": 20,
        "end": 20,
        "top": 20,
        "bottom": 20
      },
      "position": {
        "v": 1.0
      },
      "margin": {
        "start": 24,
        "end": 24
      }
    }
    }]
    }
    """
    var webView: WKWebView!
    
   
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        setupLanguage()
       
        bottomView.isUserInteractionEnabled = false
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        loadInitData()
        optionsTV.isHidden = true
        
        testCode()
        
        
        
        if(UserLocalStore.shared.DataBaseDownloaded == false) {
            showAlertWithYesNoButtons(title: "confirmation".localizeString(string: HomeDataManager.shared.languageCodeString), message: "app_need_download".localizeString(string: HomeDataManager.shared.languageCodeString)) { (didConfirm) in
                if didConfirm {
                    print("User confirmed")
                    
                    DocumentReaderService.shared.initializeDatabaseAndAPI(progress: { [weak self] state in
                        guard let self = self else { return }
                        switch state {
                        case .downloadingDatabase(progress: let progress):
                            DispatchQueue.main.async {
                                let progressValue = String(format: "%.1f", progress * 100)
                                self.statusLabel.text = "Downloading database: \(progressValue)%"
                            }
                        case .initializingAPI:
                            self.statusLabel.text = "Initializing..."
                            self.activityIndicator.stopAnimating()
                        case .completed:
                            DispatchQueue.main.async {
                                UserLocalStore.shared.DataBaseDownloaded = true
                                self.enableUserInterfaceOnSuccess()
                                self.initSections()
                            }
                            //                self.optionsTV.reloadData()
                        case .error(let text):
                            DispatchQueue.main.async {
                                self.statusLabel.text = text
                               //
                                self.enableUserInterfaceOnSuccess()
                                self.initSectionsWithoutLicence()
                                //
                            }
                            //                    self.optionsTV.reloadData()
                            print(text)
                        }
                    })
                } else {
                    print("User declined")
                    self.statusLabel.text = "To run this app please restart the application and download the database"
                    self.activityIndicator.stopAnimating()
                    
                }
            }
        }
        else {
            DocumentReaderService.shared.initializeDatabaseAndAPI(progress: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .downloadingDatabase(progress: let progress):
                    DispatchQueue.main.async {
                        let progressValue = String(format: "%.1f", progress * 100)
                        self.statusLabel.text = "Downloading database: \(progressValue)%"
                    }
                case .initializingAPI:
                    self.statusLabel.text = "Initializing..."
                    self.activityIndicator.stopAnimating()
                case .completed:
                    DispatchQueue.main.async {
                        UserLocalStore.shared.DataBaseDownloaded = true
                        self.enableUserInterfaceOnSuccess()
                        self.initSections()
                    }
                    //                self.optionsTV.reloadData()
                case .error(let text):
                    DispatchQueue.main.async {
                        self.statusLabel.text = text
                       //
                        self.enableUserInterfaceOnSuccess()
                        self.initSectionsWithoutLicence()
                        //
                    }
                    //                    self.optionsTV.reloadData()
                    print(text)
                }
            })
        }
        
   
        
        
        
        
        
        
        
        
        
//        DocumentReaderService.shared.initializeDatabaseAndAPI(progress: { [weak self] state in
//            guard let self = self else { return }
//            
//            
//            
//            
//            switch state {
//            case .downloadingDatabase(progress: let progress):
//                DispatchQueue.main.async {
//                    let progressValue = String(format: "%.1f", progress * 100)
//                    self.statusLabel.text = "Downloading database(100 MB): \(progressValue)%"
//                }
//            case .initializingAPI:
//                self.statusLabel.text = "Initializing..."
//                self.activityIndicator.stopAnimating()
//            case .completed:
//                DispatchQueue.main.async {
//                    self.enableUserInterfaceOnSuccess()
//                    self.initSections()
//                }
//                //                self.optionsTV.reloadData()
//            case .error(let text):
//                DispatchQueue.main.async {
//                    self.statusLabel.text = text
//                   //
//                    self.enableUserInterfaceOnSuccess()
//                    self.initSectionsWithoutLicence()
//                    //
//                }
//                //                    self.optionsTV.reloadData()
//                print(text)
//            }
//        })
        
        // startCamera(value: "")
        //startCamera(value: "")
        //        Task {
        ////
        ////          //  await dddasas()
        ////
        ////            //await fetchCurrentAuthSession()
        ////        //await signIn()
        ////          //  await signUp(username:"testuser", password:"Apple@123", email: "appsdev096@gmail.com")
        ////
        ////           // await confirmSignUp(for:"testuser", with: "088811")
        ////
        //  await fetchCurrentAuthSession()
        //        }
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
       // setAppSettings()
        
        actionSettingBtn.addTarget(self, action: #selector(didTapSettingBtn(_:)), for: .touchUpInside)
        
        actionCameraBtn.addTarget(self, action: #selector(didTapCameraBtn(_:)), for: .touchUpInside)
        
        actionOpenGalleryBtn.addTarget(self, action: #selector(didTapGalleryBtn(_:)), for: .touchUpInside)
       // loadToolTips()
    }
    
    
    func setupLanguage(){
        var currentLanguage = "en"
        if let preferredLanguageCode = Locale.preferredLanguages.first {
             currentLanguage = Locale(identifier: preferredLanguageCode).languageCode ?? "en"
            print("Device's preferred language code: \(currentLanguage)")
            assignLanguage(langCode: currentLanguage)
          
        } else {
            print("Unable to determine the device's preferred language code.")
            assignLanguage(langCode: currentLanguage)
        }
    }
    
    func assignLanguage(langCode: String){
        var translationDictionary = [String : String]()
       // ENG, AR, FR, SP, TURKISH, URDU, GERMAN, KURDISH
        
        
        if( langCode.lowercased() == "en") {
            let dataValues = EnglishDataValues()
            translationDictionary = dataValues.getDictionary()
        }
        else if( langCode.lowercased() == "ar") {
            let dataValues = ArabicDataValues()
            translationDictionary = dataValues.getDictionary()
        }
        else if( langCode.lowercased() == "fr") {
            let dataValues = FrenchDataValues()
            translationDictionary = dataValues.getDictionary()
        }
        else if( langCode.lowercased() == "es") {
            let dataValues = SpanishDataValues()
            translationDictionary = dataValues.getDictionary()
        }
        else if( langCode.lowercased() == "tr") {
            let dataValues = TurkishDataValues()
            translationDictionary = dataValues.getDictionary()
        }
        else if( langCode.lowercased() == "ur") {
            let dataValues = UrduDataValues()
            translationDictionary = dataValues.getDictionary()
        }
        else if( langCode.lowercased() == "de") {
            let dataValues = GermanDataValues()
            translationDictionary = dataValues.getDictionary()
        }
        else if( langCode.lowercased() == "ku") {
            let dataValues = KurdishDataValues()
            translationDictionary = dataValues.getDictionary()
        }
        else if( langCode.lowercased() == "ckb") {
            let dataValues = CkbDataValues()
            translationDictionary = dataValues.getDictionary()
        }
        else {
            let dataValues = EnglishDataValues()
            translationDictionary = dataValues.getDictionary()
        }
        DocReader.shared.localizationHandler = { localizationKey in
            if let updatedString = translationDictionary[localizationKey] {
                return updatedString
            }
            return nil
        }
       
    }
    
    func loadToolTips(){
//        var preferences = EasyTipView.Preferences()
//        preferences.drawing.font = UIFont(name: "Futura-Medium", size: 13)!
//        preferences.drawing.foregroundColor = UIColor.red
//        preferences.drawing.backgroundColor = UIColor(hue:0.46, saturation:0.99, brightness:0.6, alpha:1)
//        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.top
//
//        /*
//         * Optionally you can make these preferences global for all future EasyTipViews
//         */
//        EasyTipView.globalPreferences = preferences
//        
//        let tipView = EasyTipView(text: "Some text", preferences: preferences)
//        tipView.show(forView: self.actionOpenGalleryBtn, withinSuperview: self.view)
        
        var preferences = EasyTipView.Preferences()
        preferences.drawing.font = UIFont(name: "Futura-Medium", size: 13)!
        preferences.drawing.foregroundColor = UIColor.red
        preferences.drawing.backgroundColor = UIColor(hue:0.46, saturation:0.99, brightness:0.6, alpha:1)
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.top

        /*
         * Optionally you can make these preferences global for all future EasyTipViews
         */
        EasyTipView.globalPreferences = preferences
        
        EasyTipView.show(forView: self.actionOpenGalleryBtn,
        withinSuperview: self.view,
        text: "Tip view inside the navigation controller's view. Tap to dismiss!",
        preferences: preferences,
        delegate: nil)
    }
    
    
    func showAlertWithYesNoButtons(title: String, message: String, completion: @escaping (Bool) -> Void) {
           
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let titleFont = [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 18.0)!]
        let messageFont = [NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 15)!]
        
        let titleAttrString = NSAttributedString(string: title, attributes: titleFont)
        let messageAttrString = NSAttributedString(string: message, attributes: messageFont)
        
        alertController.setValue(titleAttrString, forKey: "attributedTitle")
        alertController.setValue(messageAttrString, forKey: "attributedMessage")
        
            let yesAction = UIAlertAction(title: "yes".localizeString(string: HomeDataManager.shared.languageCodeString), style: .default) { _ in
                completion(true)
            }
            
            let noAction = UIAlertAction(title: "no".localizeString(string: HomeDataManager.shared.languageCodeString), style: .cancel) { _ in
                completion(false)
            }
            
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            
            self.present(alertController, animated: true, completion: nil)
        
        
        
//        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
//
//        // Customize the title and message font
//        let titleFont = [NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 18.0)!]
//        let messageFont = [NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 12.0)!]
//
//        let titleAttrString = NSAttributedString(string: title, attributes: titleFont)
//        let messageAttrString = NSAttributedString(string: message, attributes: messageFont)
//
//        alertController.setValue(titleAttrString, forKey: "attributedTitle")
//        alertController.setValue(messageAttrString, forKey: "attributedMessage")
//
//        
//       
//        
//        // Add actions
//        let action1 = UIAlertAction(title: "Yes", style: .default) { (action) in
//            print("\(action.title!)")
//            completion(true)
//        }
//
//        let action2 = UIAlertAction(title: "No", style: .default) { (action) in
//            print("\(action.title!)")
//            completion(false)
//        }
//
//       
//
//        alertController.addAction(action1)
//        alertController.addAction(action2)
//
//
//        // Customize the alert view appearance
//        alertController.view.tintColor = UIColor.blue
//        alertController.view.backgroundColor = UIColor.black
//        alertController.view.layer.cornerRadius = 40
//
//        present(alertController, animated: true, completion: nil)
        
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserLocalStore.shared.TutorialViewed = true
        setAppSettings()
        
       
    }
    //MARK: Button Navigations

    @objc func didTapSettingBtn(_ sender: UIButton){
        let  vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapCameraBtn(_ sender: UIButton){
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//                  imagePicker.sourceType = .camera
//                  present(imagePicker, animated: true, completion: nil)
//              } else {
//                 print("Please add Camera ")
//              }
        
        
        UserLocalStore.shared.clickedIndex = 0
        
        let config = DocReader.ScannerConfig(scenario: "")
           // let config = DocReader.ScannerConfig()
            config.scenario = RGL_SCENARIO_FULL_PROCESS
            
           


            DocReader.shared.showScanner(presenter: self, config: config) { [self] (action, result, error) in
                if action == .complete || action == .processTimeout {
                    print(result?.rawResult as Any)
                    
                    if result?.chipPage != 0 && UserLocalStore.shared.RFIDChipProcessing == true {
                        self.startRFIDReading(result)
                    } else {
                        if ApplicationSetting.shared.isDataEncryptionEnabled {
                            statusLabel.text = "Decrypting data..."
                            activityIndicator.startAnimating()
                            popUpView.isHidden = false
                            processEncryptedResults(result!) { decryptedResult in
                                DispatchQueue.main.async {
                                    self.popUpView.isHidden = true
                                    
                                    guard let results = decryptedResult else {
                                        print("Can't decrypt result")
                                        return
                                    }
                                    
                                   
                                    
                                    self.presentResults(results)
                                }
                            }
                        } else {
                            presentResults(result!)
                        }
                    }
                    
                  
                                   
                 
                    
                }
            }
            
        
    }

    @objc func didTapGalleryBtn(_ sender: UIButton){
        imageSourceType = ""
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                   imagePicker.sourceType = .photoLibrary
                   present(imagePicker, animated: true, completion: nil)
               } else {
                   print("Can't open gallery")
               }
        
  
    }
    
    func captureModeToString(captureMode: String) -> CaptureMode {
        switch captureMode {
        case "Auto":
            return .auto
        case "Video processing":
            return .captureVideo
        case "Frame processing":
            return .captureFrame
        default:
            return .auto
        }
    }

    // For String data
    func zoomFactorToString(zoomFactor: CGFloat) -> String {
        let newData = String(Double(zoomFactor))
        return newData
    }
    // For
    func captureSessionPresetToString(preset: AVCaptureSession.Preset) -> String {
        return preset.rawValue
    }
    // For Authentication Procedure
    func authProcTypeToString(authProcType: String) -> RFIDAuthenticationProcedureType {
        switch authProcType {
            case "Undefined":
            return .undefined
            case "Standard inspection procedure":
            return .standard
            case "Advanced inspection procedure":
            return .advanced
            case "General inspection procedure":
            return .general
        default:
            return .undefined
        }
    }

    // For Basic Security messaging procedure
    func accessControlProcTypeToString(procType: String) -> RFIDAccessControlProcedureType {
        switch procType {
            case "Undefined":
            return .undefined
            case "BAC":
            return .bac
            case "PACE":
            return .pace
            case "CA":
            return .ca
            case "TA":
            return .ta
            case "AA":
            return .aa
            case "RI":
            return .ri
            case "CardInfo":
            return .ca
        default:
            return .undefined
        }
    }

    func preset(from string: String) -> AVCaptureSession.Preset? {
           switch string {
           case "Photo": return .photo
           case "High": return .high
           case "Medium": return .medium
           case "Low": return .low
           case "352×288": return .cif352x288
           case "640×480": return .vga640x480
           case "1280×720": return .hd1280x720
           case "1920×1080": return .hd1920x1080
           case "3840×2160": return .hd4K3840x2160
           case "iFrame960×540": return .iFrame960x540
           case "iFrame1280x720": return .iFrame1280x720
           case "inputPriority": return .inputPriority
           default: return nil
           }
       }
    
//    func setAppSettings() {
//        
//        // HANLDE LOCALLAY
//        
//        
//        // FACE MATCHING
//        // LIVENESS
//        
//        DocReader.shared.processParams.imageQA.colornessCheck = true
//        
//        DocReader.shared.customization.cameraFrameDefaultColor  = UIColor(red: 126/255, green: 87/255, blue: 196/255, alpha: 1)
////           DocReader.shared.customization.cameraPreviewBackgroundColor = .purple
////           DocReader.shared.customization.tintColor = .yellow
//        DocReader.shared.customization.tintColor  = UIColor(red: 126/255, green: 87/255, blue: 196/255, alpha: 1)
//        
//        
//        DocReader.shared.functionality.showSkipNextPageButton = false
//
//        // Double Page Spread Proccessing
//        DocReader.shared.processParams.doublePageSpread = UserLocalStore.shared.DoublePageSpreadProcessing == true ? 1 : 0
//        
//        // SAVE EVENT LOGS
//        DocReader.shared.processParams.debugSaveLogs = UserLocalStore.shared.SaveEventLogs == true ? 1 : 0
//        
//        // SAVE IMAGE
//        DocReader.shared.processParams.debugSaveImages = UserLocalStore.shared.SaveImages == true ? 1 : 0
//        
//        // SAVE CROPPED IMAGE
//        DocReader.shared.processParams.debugSaveCroppedImages = UserLocalStore.shared.SaveCroppedImages == true ? 1 : 0
//        
//        // SAVE RFID SESSION
//        DocReader.shared.processParams.debugSaveRFIDSession = UserLocalStore.shared.SaveRFIDSession == true ? 1 : 0
//        
//        // REPORT EVENT LOGS
//        let path = DocReader.shared.processParams.sessionLogFolder
//        print("Path: \(path ?? "nil")") // COPY CONTENT FOR THIS PATH AND SHOW
//        
//        // SHOW METADATA
//        DocReader.shared.functionality.showMetadataInfo = UserLocalStore.shared.ShowMetadata
//        
//        
//        // CAPTURE BUTTON
//        DocReader.shared.functionality.showCaptureButton = UserLocalStore.shared.CaptureButton
//        
//        // CAMERA SWITCH BUTTON
//        DocReader.shared.functionality.showCameraSwitchButton = UserLocalStore.shared.CameraSwitchButton
//
//        
//        //HELP
//        DocReader.shared.customization.showHelpAnimation = UserLocalStore.shared.Help
//        
//        
//        // TIMEOUT
//        if let timeout = numberFormatter.number(from: UserLocalStore.shared.TimeOut) {
//            DocReader.shared.processParams.timeout = timeout
//        }
//
//        // TIMEOUT STARTING FROM DOCUMENT DETECTION
//        if let timeoutString = numberFormatter.number(from: UserLocalStore.shared.TimeOutDocumentDetection) {
//            DocReader.shared.processParams.timeoutFromFirstDetect = timeoutString
//        }
//        
//        
//        // TIME OUT STARTING FROM DOCUMENT TYPE IDENTIFICATION
//        if let documentId = numberFormatter.number(from: UserLocalStore.shared.TimeOutDocumentIdentification) {
//            DocReader.shared.processParams.timeoutFromFirstDocType = documentId
//        }
//        
//        // MOTION DETECTION
//        DocReader.shared.functionality.videoCaptureMotionControl = UserLocalStore.shared.MotionDetection
//        
//        // FOCUSING DETECTION
//        DocReader.shared.functionality.skipFocusingFrames = UserLocalStore.shared.FocusingDetection
//
//        
//        // PROCESSING MOEDS
//
//        let captureModeString = captureModeToString(captureMode: UserLocalStore.shared.ProcessingModes)
//        DocReader.shared.functionality.captureMode = captureModeString
//        
//        // CAMERA RESOLUTION
//
//         let presetdata = preset(from:  UserLocalStore.shared.CameraResolution)
//            DocReader.shared.functionality.videoSessionPreset = presetdata
//
//
//        // ADJUST ZZOOM LEVEL
//        DocReader.shared.functionality.isZoomEnabled  = UserLocalStore.shared.AdiustZoomLevel
//        
//        // ZOOM LEVEL
//        if let zoomFactor = numberFormatter.number(from: UserLocalStore.shared.ZoomLevel) {
//            DocReader.shared.functionality.zoomFactor = CGFloat(truncating: zoomFactor)
//        }
//        
//        // MANUAL CROP
//        DocReader.shared.processParams.manualCrop = UserLocalStore.shared.ManualCrop == true ? 1 : 0
//        
//        // MINIMUM DPI
//        if let DPI = numberFormatter.number(from: UserLocalStore.shared.MinimumDPI) {
//            DocReader.shared.processParams.minDPI = DPI
//        }
//        // PERPECTIVE ANGLE
//        if let Angle = numberFormatter.number(from: UserLocalStore.shared.PerspectiveAngle) {
//            DocReader.shared.processParams.perspectiveAngle = Angle
//        }
//        // INTEGRAL IMAGE
//        DocReader.shared.processParams.integralImage = UserLocalStore.shared.IntegralImage == true ? 1 : 0
//
//        // HOLOGRAM DETECTION
//        DocReader.shared.processParams.authenticityParams?.livenessParams?.checkHolo =  UserLocalStore.shared.HologramDetection == true ? 1 : 0
//        
//        // GLARE
//        DocReader.shared.processParams.imageQA.glaresCheck = UserLocalStore.shared.ImgGlares == true ? 1 : 0
//        
//        // FOCUS
//        DocReader.shared.processParams.imageQA.focusCheck = UserLocalStore.shared.ImgFocus == true ? 1 : 0
//        
//        // COLor
//        DocReader.shared.processParams.imageQA.colornessCheck = UserLocalStore.shared.ImgColor == true ? 1 : 0
//        
//        // DPI
//
//        if let threshold = numberFormatter.number(from: UserLocalStore.shared.DPIThreshold) {
//        DocReader.shared.processParams.imageQA.dpiThreshold = threshold
//        }
//        
//        // ANGLE   UserLocalStore.shared.AngleThreshold
//        if let anglethreshold = numberFormatter.number(from: UserLocalStore.shared.AngleThreshold) {
//        DocReader.shared.processParams.imageQA.angleThreshold = anglethreshold
//        }
//        
//        // DOCUMENT
//        if let document = numberFormatter.number(from: UserLocalStore.shared.DocumentPositionIndent) {
//            DocReader.shared.processParams.imageQA.documentPositionIndent = document
//        }
//        
//        // DATE FORMAT
//        DocReader.shared.processParams.dateFormat = UserLocalStore.shared.DateFormat
//
//        // DOCUMENT FILTER
////        DocReader.shared.processParams.documentIDList = [-274257313, -2004898043]
//        if UserLocalStore.shared.DocumentFilter != "" {
//            var dataAt = [NSNumber]()
//            var fullName: String = UserLocalStore.shared.DocumentFilter
//            let fullNameArr = fullName.components(separatedBy: ",")
//            for i in 0..<fullNameArr.count {
//                dataAt.append(Int(fullNameArr[i])! as NSNumber);
//            }
//            
//            DocReader.shared.processParams.documentIDList = dataAt
//        }
//        
//        // AUTH PROCEDURE TYPE
//        let authProcTypeString = authProcTypeToString(authProcType: UserLocalStore.shared.AuthenticationProcedureType)
//        DocReader.shared.rfidScenario.authProcType = authProcTypeString
//
//        // AUTH PROCEDURE TYPE
//        let procTypeString = accessControlProcTypeToString(procType: UserLocalStore.shared.BasicSecurityMessagingProcedure)
//        DocReader.shared.rfidScenario.baseSMProcedure = procTypeString
//        
//        // PRIORITY OF DS CER
//        DocReader.shared.rfidScenario.pkdDSCertPriority = UserLocalStore.shared.PriorityUsingDSCertificates
//        
//        // CSCA CERTIFICATE
//        DocReader.shared.rfidScenario.pkdUseExternalCSCA = UserLocalStore.shared.UseExternalCSCACertificates
//        
//        // PKD CERTIFICATE
//        DocReader.shared.rfidScenario.trustedPKD = UserLocalStore.shared.TrustPKDCertificates
//        
//        // PASSIVE AUTH
//        DocReader.shared.rfidScenario.passiveAuth = UserLocalStore.shared.PassiveAuthentication
//        
//        // AA AFTER CA
//        DocReader.shared.rfidScenario.skipAA = UserLocalStore.shared.PerformAAAfterCA
//        
//        // PROFILE TYE
//        if( UserLocalStore.shared.ProfilerType != "") {
//            if(UserLocalStore.shared.ProfilerType == "LSD and PKI Maintenance, v2.0, May21, 2014") {
//                DocReader.shared.rfidScenario.profilerType = RGLRFIDSdkProfilerTypeDoc9303LdsPkiMaintenance
//            }
//            else {
//                DocReader.shared.rfidScenario.profilerType = RGLRFIDSdkProfilerTypeDoc9303Edition2006
//            }
//        }
//       
//
//        // STRICT PROTOCOL
//        DocReader.shared.rfidScenario.strictProcessing =  UserLocalStore.shared.StrictISOProtocol
//        
//        
//        
//        // READ PASSPORt
//        DocReader.shared.rfidScenario.readEPassport = UserLocalStore.shared.ReadEPassport
//        
//      
//        
//        // MEACHINE READBLE ZONE DG1
//        DocReader.shared.rfidScenario.ePassportDataGroups.dG1 = UserLocalStore.shared.MachineReadableZone
//
//        // Biometry facial data DG2
//        DocReader.shared.rfidScenario.ePassportDataGroups.dG2 = UserLocalStore.shared.Biometry_FacialData
//
//        // Biometry fingerPrints DG3
//        DocReader.shared.rfidScenario.ePassportDataGroups.dG3 = UserLocalStore.shared.Biometry_Fingerprints
//
//        // Biometry Iris data DG4
//        DocReader.shared.rfidScenario.ePassportDataGroups.dG4 = UserLocalStore.shared.Biometry_IrisData
//
//        // Potraits DG5
//        DocReader.shared.rfidScenario.ePassportDataGroups.dG5 = UserLocalStore.shared.Portrait
//
//        // not define DG6
//        DocReader.shared.rfidScenario.ePassportDataGroups.dG6 = UserLocalStore.shared.NotDefinedDG6
//
//        // Singnuture Usual mark DG7
//        DocReader.shared.rfidScenario.ePassportDataGroups.dG7 = UserLocalStore.shared.SignatureUsualMarkImage
//
//        // not define DG6
//        DocReader.shared.rfidScenario.ePassportDataGroups.dG8 = UserLocalStore.shared.NotDefinedDG8
//        
//        // not define DG6
//        DocReader.shared.rfidScenario.ePassportDataGroups.dG9 = UserLocalStore.shared.NotDefinedDG9
//        
//        // not define DG6
//        DocReader.shared.rfidScenario.ePassportDataGroups.dG10 = UserLocalStore.shared.NotDefinedDG10
//        
//        // Additional personal details DG11
//        DocReader.shared.rfidScenario.ePassportDataGroups.dG11 = UserLocalStore.shared.AdditionalPersonalDetail
//        
//        // Additional document details DG12
//        DocReader.shared.rfidScenario.ePassportDataGroups.dG12 = UserLocalStore.shared.AdditionalDocumentDetail
//        
//        // OPtional details DG13
//        DocReader.shared.rfidScenario.ePassportDataGroups.dG13 = UserLocalStore.shared.OptionalDetail
//        
//        // Eac Info DG14
//        DocReader.shared.rfidScenario.ePassportDataGroups.dG14 = UserLocalStore.shared.EACInfo
//        
//        // Authentication info DG15
//        DocReader.shared.rfidScenario.ePassportDataGroups.dG15 = UserLocalStore.shared.ActiveAuthenticationInfo
//        
//        // Person Notify DG16
//        DocReader.shared.rfidScenario.ePassportDataGroups.dG16 = UserLocalStore.shared.PersonToNotify
//        
//        // Read E-ID
//        DocReader.shared.rfidScenario.readEID = UserLocalStore.shared.ReadElD
//        
//        // document type DG1
//        DocReader.shared.rfidScenario.eIDDataGroups.dG1 = UserLocalStore.shared.DocumentType
//        
//        // Issuing State
//        DocReader.shared.rfidScenario.eIDDataGroups.dG2 = UserLocalStore.shared.IssuingState
//        
//        // Date of expiry
//        DocReader.shared.rfidScenario.eIDDataGroups.dG3 = UserLocalStore.shared.DateOfExpiry
//        
//        // Given Name
//        DocReader.shared.rfidScenario.eIDDataGroups.dG4 = UserLocalStore.shared.GivenName
//        
//        // Family Name
//        DocReader.shared.rfidScenario.eIDDataGroups.dG5 = UserLocalStore.shared.FamilyName
//        
//        // Pseudonym
//        DocReader.shared.rfidScenario.eIDDataGroups.dG6 = UserLocalStore.shared.Pseudonym
//        
//        // Acadmic Title
//        DocReader.shared.rfidScenario.eIDDataGroups.dG7 = UserLocalStore.shared.AcademicTitle
//        
//        // Date of birth
//        DocReader.shared.rfidScenario.eIDDataGroups.dG8 = UserLocalStore.shared.DateOfBirth
//        
//        // Place of birth
//        DocReader.shared.rfidScenario.eIDDataGroups.dG9 = UserLocalStore.shared.PlaceOfBirth
//        
//        // Nationality
//        DocReader.shared.rfidScenario.eIDDataGroups.dG10 = UserLocalStore.shared.Nationality
//        
//        // Sex
//        DocReader.shared.rfidScenario.eIDDataGroups.dG11 = UserLocalStore.shared.Sex
//        
//        // Optional detail
//        DocReader.shared.rfidScenario.eIDDataGroups.dG12 = UserLocalStore.shared.OptionalDetailsDG12
//        
//        // Undefine DG13
//        DocReader.shared.rfidScenario.eIDDataGroups.dG13 = UserLocalStore.shared.UndefinedDG13
//        
//        // Undefine DG14
//        DocReader.shared.rfidScenario.eIDDataGroups.dG14 = UserLocalStore.shared.UndefinedDG14
//        
//        // Undefine DG15
//        DocReader.shared.rfidScenario.eIDDataGroups.dG15 = UserLocalStore.shared.UndefinedDG15
//        
//        // Undefine DG16
//        DocReader.shared.rfidScenario.eIDDataGroups.dG16 = UserLocalStore.shared.UndefinedDG16
//        
//        // Place of Registation
//        DocReader.shared.rfidScenario.eIDDataGroups.dG17 = UserLocalStore.shared.PlaceOfRegistrationDG17
//        
//        // Place of Registation
//        DocReader.shared.rfidScenario.eIDDataGroups.dG18 = UserLocalStore.shared.PlaceOfRegistrationDG18
//        
//        // Residence permit
//        DocReader.shared.rfidScenario.eIDDataGroups.dG19 = UserLocalStore.shared.ResidencePermit1DG19
//        
//        // Residence permit
//        DocReader.shared.rfidScenario.eIDDataGroups.dG20 = UserLocalStore.shared.ResidencePermit2DG20
//        
//        // Optional details DG21
//        DocReader.shared.rfidScenario.eIDDataGroups.dG21 = UserLocalStore.shared.OptionalDetailsDG21
//        
//        // Read E-DL
//        DocReader.shared.rfidScenario.readEDL = UserLocalStore.shared.ReadEDL
//        
//        // text data element
//        DocReader.shared.rfidScenario.eDLDataGroups.dG1 = UserLocalStore.shared.TextDataElementsDG1
//        
//        // License holder information
//        DocReader.shared.rfidScenario.eDLDataGroups.dG2  = UserLocalStore.shared.LicenseHolderInformationDG2
//        
//        // Issuing Authority details
//        DocReader.shared.rfidScenario.eDLDataGroups.dG3 = UserLocalStore.shared.IssuingAuthorityDetailsDG3
//        
//        // potraits Image
//        DocReader.shared.rfidScenario.eDLDataGroups.dG4 = UserLocalStore.shared.PortraitImageDG4
//        
//        // Signature Usual mark
//        DocReader.shared.rfidScenario.eDLDataGroups.dG5 = UserLocalStore.shared.SignatureUsualMarkImageDG5
//        
//        // biometry facial data
//        DocReader.shared.rfidScenario.eDLDataGroups.dG6 = UserLocalStore.shared.Biometry_FacialDataDG6
//        
//        // biometry fingerprints
//        DocReader.shared.rfidScenario.eDLDataGroups.dG7 = UserLocalStore.shared.Biometry_FingerprintDG7
//        
//        // biometry Iris data
//        DocReader.shared.rfidScenario.eDLDataGroups.dG8 = UserLocalStore.shared.Biometry_IrisDataDG8
//        
//        // biometry Other
//        DocReader.shared.rfidScenario.eDLDataGroups.dG9 = UserLocalStore.shared.Biometry_OtherDG9
//        
//        // not define
//        DocReader.shared.rfidScenario.eDLDataGroups.dG10 = UserLocalStore.shared.EDL_NotDefinedDG10
//        
//        // Optional domestic data
//        DocReader.shared.rfidScenario.eDLDataGroups.dG11 = UserLocalStore.shared.OptionalDomesticDataDG11
//        
//        // Non match alert
//        DocReader.shared.rfidScenario.eDLDataGroups.dG12 = UserLocalStore.shared.Non_MatchAlertDG12
//        
//        // Actice authentication info
//        DocReader.shared.rfidScenario.eDLDataGroups.dG13 = UserLocalStore.shared.ActiveAuthenticationInfoDG13
//        
//        // Eac Info
//        DocReader.shared.rfidScenario.eDLDataGroups.dG14 = UserLocalStore.shared.EACInfoDG14
//    }
    func setAppSettings() {
        
        // HANLDE LOCALLAY
        
        
        // FACE MATCHING
        // LIVENESS
        
      
        DocReader.shared.functionality.videoSessionPreset = AVCaptureSession.Preset.hd4K3840x2160
        
        
        DocReader.shared.customization.cameraFrameDefaultColor  = UIColor(red: 126/255, green: 87/255, blue: 196/255, alpha: 1)
//           DocReader.shared.customization.cameraPreviewBackgroundColor = .purple
//           DocReader.shared.customization.tintColor = .yellow
        DocReader.shared.customization.tintColor  = UIColor(red: 126/255, green: 87/255, blue: 196/255, alpha: 1)
        
        
        DocReader.shared.functionality.showSkipNextPageButton = false

        // Double Page Spread Proccessing
        DocReader.shared.processParams.doublePageSpread = UserLocalStore.shared.DoublePageSpreadProcessing == true ? 1 : 0
        
        // SAVE EVENT LOGS
        DocReader.shared.processParams.debugSaveLogs = UserLocalStore.shared.SaveEventLogs == true ? 1 : 0
        
        // SAVE IMAGE
        DocReader.shared.processParams.debugSaveImages = UserLocalStore.shared.SaveImages == true ? 1 : 0
        
        // SAVE CROPPED IMAGE
        DocReader.shared.processParams.debugSaveCroppedImages = UserLocalStore.shared.SaveCroppedImages == true ? 1 : 0
        
        // SAVE RFID SESSION
        DocReader.shared.processParams.debugSaveRFIDSession = UserLocalStore.shared.SaveRFIDSession == true ? 1 : 0
        
        // REPORT EVENT LOGS
        let path = DocReader.shared.processParams.sessionLogFolder
        print("Path: \(path ?? "nil")") // COPY CONTENT FOR THIS PATH AND SHOW
        
        // SHOW METADATA
        DocReader.shared.functionality.showMetadataInfo = UserLocalStore.shared.ShowMetadata
        
        
        // CAPTURE BUTTON
        DocReader.shared.functionality.showCaptureButton = UserLocalStore.shared.CaptureButton
        
        // CAMERA SWITCH BUTTON
        DocReader.shared.functionality.showCameraSwitchButton = UserLocalStore.shared.CameraSwitchButton

        
        //HELP
        DocReader.shared.customization.showHelpAnimation = UserLocalStore.shared.Help
        
        
        // TIMEOUT
        if let timeout = numberFormatter.number(from: UserLocalStore.shared.TimeOut) {
            DocReader.shared.processParams.timeout = timeout
        }

        // TIMEOUT STARTING FROM DOCUMENT DETECTION
        if let timeoutString = numberFormatter.number(from: UserLocalStore.shared.TimeOutDocumentDetection) {
            DocReader.shared.processParams.timeoutFromFirstDetect = timeoutString
        }
        
        
        // TIME OUT STARTING FROM DOCUMENT TYPE IDENTIFICATION
        if let documentId = numberFormatter.number(from: UserLocalStore.shared.TimeOutDocumentIdentification) {
            DocReader.shared.processParams.timeoutFromFirstDocType = documentId
        }
        
        // MOTION DETECTION
        DocReader.shared.functionality.videoCaptureMotionControl = UserLocalStore.shared.MotionDetection
        
        // FOCUSING DETECTION
        DocReader.shared.functionality.skipFocusingFrames = UserLocalStore.shared.FocusingDetection

        
        // PROCESSING MOEDS

        let captureModeString = captureModeToString(captureMode: UserLocalStore.shared.ProcessingModes)
        DocReader.shared.functionality.captureMode = captureModeString
        
        // CAMERA RESOLUTION

         let presetdata = preset(from:  UserLocalStore.shared.CameraResolution)
            DocReader.shared.functionality.videoSessionPreset = presetdata


        // ADJUST ZZOOM LEVEL
        DocReader.shared.functionality.isZoomEnabled  = UserLocalStore.shared.AdiustZoomLevel
        
        // ZOOM LEVEL
        if let zoomFactor = numberFormatter.number(from: UserLocalStore.shared.ZoomLevel) {
            DocReader.shared.functionality.zoomFactor = CGFloat(truncating: zoomFactor)
        }
        
        // MANUAL CROP
        DocReader.shared.processParams.manualCrop = UserLocalStore.shared.ManualCrop == true ? 1 : 0
        
        // MINIMUM DPI
        if let DPI = numberFormatter.number(from: UserLocalStore.shared.MinimumDPI) {
            DocReader.shared.processParams.minDPI = DPI
        }
        // PERPECTIVE ANGLE
        if let Angle = numberFormatter.number(from: UserLocalStore.shared.PerspectiveAngle) {
            DocReader.shared.processParams.perspectiveAngle = Angle
        }
        // INTEGRAL IMAGE
        DocReader.shared.processParams.integralImage = UserLocalStore.shared.IntegralImage == true ? 1 : 0

        // HOLOGRAM DETECTION
      
        
        // DocReader.shared.processParams.checkHologram  = UserLocalStore.shared.HologramDetection == true ? 1 : 0
      
        DocReader.shared.processParams.authenticityParams = AuthenticityParams.default()
        DocReader.shared.processParams.authenticityParams?.livenessParams = LivenessParams.default()
        DocReader.shared.processParams.authenticityParams?.livenessParams?.checkHolo = UserLocalStore.shared.HologramDetection == true ? true : false
        DocReader.shared.processParams.authenticityParams?.livenessParams?.checkOVI = UserLocalStore.shared.HologramDetection == true ? true : false
        DocReader.shared.processParams.authenticityParams?.livenessParams?.checkED = UserLocalStore.shared.HologramDetection == true ? true : false
        DocReader.shared.processParams.authenticityParams?.livenessParams?.checkMLI = UserLocalStore.shared.HologramDetection == true ? true : false
        DocReader.shared.processParams.authenticityParams?.checkImagePatterns = UserLocalStore.shared.HologramDetection == true ? true : false
        DocReader.shared.processParams.authenticityParams?.checkPhotoEmbedding = UserLocalStore.shared.HologramDetection == true ? true : false
        DocReader.shared.processParams.authenticityParams?.checkUVLuminiscence = UserLocalStore.shared.HologramDetection == true ? true : false

      
        
        
        // GLARE
        DocReader.shared.processParams.imageQA.glaresCheck = UserLocalStore.shared.ImgGlares == true ? 1 : 0
        
        // FOCUS
        DocReader.shared.processParams.imageQA.focusCheck = UserLocalStore.shared.ImgFocus == true ? 1 : 0
        
        // COLor
        DocReader.shared.processParams.imageQA.colornessCheck = UserLocalStore.shared.ImgColor == true ? 1 : 0
        
        // DPI

        if let threshold = numberFormatter.number(from: UserLocalStore.shared.DPIThreshold) {
        DocReader.shared.processParams.imageQA.dpiThreshold = threshold
        }
        
        // ANGLE   UserLocalStore.shared.AngleThreshold
        if let anglethreshold = numberFormatter.number(from: UserLocalStore.shared.AngleThreshold) {
        DocReader.shared.processParams.imageQA.angleThreshold = anglethreshold
        }
        
        // DOCUMENT
        if let document = numberFormatter.number(from: UserLocalStore.shared.DocumentPositionIndent) {
            DocReader.shared.processParams.imageQA.documentPositionIndent = document
        }
        
        // DATE FORMAT
        DocReader.shared.processParams.dateFormat = UserLocalStore.shared.DateFormat

        // DOCUMENT FILTER
//        DocReader.shared.processParams.documentIDList = [-274257313, -2004898043]
        if UserLocalStore.shared.DocumentFilter != "" {
            var dataAt = [NSNumber]()
            var fullName: String = UserLocalStore.shared.DocumentFilter
            let fullNameArr = fullName.components(separatedBy: ",")
            for i in 0..<fullNameArr.count {
                dataAt.append(Int(fullNameArr[i])! as NSNumber);
            }
            
            DocReader.shared.processParams.documentIDList = dataAt
        }
        
        // AUTH PROCEDURE TYPE
//        let authProcTypeString = authProcTypeToString(authProcType: UserLocalStore.shared.AuthenticationProcedureType)
//        DocReader.shared.rfidScenario.authProcType = authProcTypeString
//
//        // AUTH PROCEDURE TYPE
//        let procTypeString = accessControlProcTypeToString(procType: UserLocalStore.shared.BasicSecurityMessagingProcedure)
//        DocReader.shared.rfidScenario.baseSMProcedure = procTypeString
//
//        // PRIORITY OF DS CER
//        DocReader.shared.rfidScenario.pkdDSCertPriority = UserLocalStore.shared.PriorityUsingDSCertificates
//
//        // CSCA CERTIFICATE
//        DocReader.shared.rfidScenario.pkdUseExternalCSCA = UserLocalStore.shared.UseExternalCSCACertificates
//
//        // PKD CERTIFICATE
//        DocReader.shared.rfidScenario.trustedPKD = UserLocalStore.shared.TrustPKDCertificates
//
//        // PASSIVE AUTH
//        DocReader.shared.rfidScenario.passiveAuth = UserLocalStore.shared.PassiveAuthentication
//
//        // AA AFTER CA
//        DocReader.shared.rfidScenario.skipAA = UserLocalStore.shared.PerformAAAfterCA
//
//        // PROFILE TYE
//        if( UserLocalStore.shared.ProfilerType != "") {
//            if(UserLocalStore.shared.ProfilerType == "LSD and PKI Maintenance, v2.0, May21, 2014") {
//                DocReader.shared.rfidScenario.profilerType = RGLRFIDSdkProfilerTypeDoc9303LdsPkiMaintenance
//            }
//            else {
//                DocReader.shared.rfidScenario.profilerType = RGLRFIDSdkProfilerTypeDoc9303Edition2006
//            }
//        }
//
//
//        // STRICT PROTOCOL
//        DocReader.shared.rfidScenario.strictProcessing =  UserLocalStore.shared.StrictISOProtocol
//
//
//
//        // READ PASSPORt
//        DocReader.shared.rfidScenario.readEPassport = UserLocalStore.shared.ReadEPassport
//
//
//
//        // MEACHINE READBLE ZONE DG1
//        DocReader.shared.rfidScenario.ePassportDataGroups.dG1 = UserLocalStore.shared.MachineReadableZone
//
//        // Biometry facial data DG2
//        DocReader.shared.rfidScenario.ePassportDataGroups.dG2 = UserLocalStore.shared.Biometry_FacialData
//
//        // Biometry fingerPrints DG3
//        DocReader.shared.rfidScenario.ePassportDataGroups.dG3 = UserLocalStore.shared.Biometry_Fingerprints
//
//        // Biometry Iris data DG4
//        DocReader.shared.rfidScenario.ePassportDataGroups.dG4 = UserLocalStore.shared.Biometry_IrisData
//
//        // Potraits DG5
//        DocReader.shared.rfidScenario.ePassportDataGroups.dG5 = UserLocalStore.shared.Portrait
//
//        // not define DG6
//        DocReader.shared.rfidScenario.ePassportDataGroups.dG6 = UserLocalStore.shared.NotDefinedDG6
//
//        // Singnuture Usual mark DG7
//        DocReader.shared.rfidScenario.ePassportDataGroups.dG7 = UserLocalStore.shared.SignatureUsualMarkImage
//
//        // not define DG6
//        DocReader.shared.rfidScenario.ePassportDataGroups.dG8 = UserLocalStore.shared.NotDefinedDG8
//
//        // not define DG6
//        DocReader.shared.rfidScenario.ePassportDataGroups.dG9 = UserLocalStore.shared.NotDefinedDG9
//
//        // not define DG6
//        DocReader.shared.rfidScenario.ePassportDataGroups.dG10 = UserLocalStore.shared.NotDefinedDG10
//
//        // Additional personal details DG11
//        DocReader.shared.rfidScenario.ePassportDataGroups.dG11 = UserLocalStore.shared.AdditionalPersonalDetail
//
//        // Additional document details DG12
//        DocReader.shared.rfidScenario.ePassportDataGroups.dG12 = UserLocalStore.shared.AdditionalDocumentDetail
//
//        // OPtional details DG13
//        DocReader.shared.rfidScenario.ePassportDataGroups.dG13 = UserLocalStore.shared.OptionalDetail
//
//        // Eac Info DG14
//        DocReader.shared.rfidScenario.ePassportDataGroups.dG14 = UserLocalStore.shared.EACInfo
//
//        // Authentication info DG15
//        DocReader.shared.rfidScenario.ePassportDataGroups.dG15 = UserLocalStore.shared.ActiveAuthenticationInfo
//
//        // Person Notify DG16
//        DocReader.shared.rfidScenario.ePassportDataGroups.dG16 = UserLocalStore.shared.PersonToNotify
//
//        // Read E-ID
//        DocReader.shared.rfidScenario.readEID = UserLocalStore.shared.ReadElD
//
//        // document type DG1
//        DocReader.shared.rfidScenario.eIDDataGroups.dG1 = UserLocalStore.shared.DocumentType
//
//        // Issuing State
//        DocReader.shared.rfidScenario.eIDDataGroups.dG2 = UserLocalStore.shared.IssuingState
//
//        // Date of expiry
//        DocReader.shared.rfidScenario.eIDDataGroups.dG3 = UserLocalStore.shared.DateOfExpiry
//
//        // Given Name
//        DocReader.shared.rfidScenario.eIDDataGroups.dG4 = UserLocalStore.shared.GivenName
//
//        // Family Name
//        DocReader.shared.rfidScenario.eIDDataGroups.dG5 = UserLocalStore.shared.FamilyName
//
//        // Pseudonym
//        DocReader.shared.rfidScenario.eIDDataGroups.dG6 = UserLocalStore.shared.Pseudonym
//
//        // Acadmic Title
//        DocReader.shared.rfidScenario.eIDDataGroups.dG7 = UserLocalStore.shared.AcademicTitle
//
//        // Date of birth
//        DocReader.shared.rfidScenario.eIDDataGroups.dG8 = UserLocalStore.shared.DateOfBirth
//
//        // Place of birth
//        DocReader.shared.rfidScenario.eIDDataGroups.dG9 = UserLocalStore.shared.PlaceOfBirth
//
//        // Nationality
//        DocReader.shared.rfidScenario.eIDDataGroups.dG10 = UserLocalStore.shared.Nationality
//
//        // Sex
//        DocReader.shared.rfidScenario.eIDDataGroups.dG11 = UserLocalStore.shared.Sex
//
//        // Optional detail
//        DocReader.shared.rfidScenario.eIDDataGroups.dG12 = UserLocalStore.shared.OptionalDetailsDG12
//
//        // Undefine DG13
//        DocReader.shared.rfidScenario.eIDDataGroups.dG13 = UserLocalStore.shared.UndefinedDG13
//
//        // Undefine DG14
//        DocReader.shared.rfidScenario.eIDDataGroups.dG14 = UserLocalStore.shared.UndefinedDG14
//
//        // Undefine DG15
//        DocReader.shared.rfidScenario.eIDDataGroups.dG15 = UserLocalStore.shared.UndefinedDG15
//
//        // Undefine DG16
//        DocReader.shared.rfidScenario.eIDDataGroups.dG16 = UserLocalStore.shared.UndefinedDG16
//
//        // Place of Registation
//        DocReader.shared.rfidScenario.eIDDataGroups.dG17 = UserLocalStore.shared.PlaceOfRegistrationDG17
//
//        // Place of Registation
//        DocReader.shared.rfidScenario.eIDDataGroups.dG18 = UserLocalStore.shared.PlaceOfRegistrationDG18
//
//        // Residence permit
//        DocReader.shared.rfidScenario.eIDDataGroups.dG19 = UserLocalStore.shared.ResidencePermit1DG19
//
//        // Residence permit
//        DocReader.shared.rfidScenario.eIDDataGroups.dG20 = UserLocalStore.shared.ResidencePermit2DG20
//
//        // Optional details DG21
//        DocReader.shared.rfidScenario.eIDDataGroups.dG21 = UserLocalStore.shared.OptionalDetailsDG21
//
//        // Read E-DL
//        DocReader.shared.rfidScenario.readEDL = UserLocalStore.shared.ReadEDL
//
//        // text data element
//        DocReader.shared.rfidScenario.eDLDataGroups.dG1 = UserLocalStore.shared.TextDataElementsDG1
//
//        // License holder information
//        DocReader.shared.rfidScenario.eDLDataGroups.dG2  = UserLocalStore.shared.LicenseHolderInformationDG2
//
//        // Issuing Authority details
//        DocReader.shared.rfidScenario.eDLDataGroups.dG3 = UserLocalStore.shared.IssuingAuthorityDetailsDG3
//
//        // potraits Image
//        DocReader.shared.rfidScenario.eDLDataGroups.dG4 = UserLocalStore.shared.PortraitImageDG4
//
//        // Signature Usual mark
//        DocReader.shared.rfidScenario.eDLDataGroups.dG5 = UserLocalStore.shared.SignatureUsualMarkImageDG5
//
//        // biometry facial data
//        DocReader.shared.rfidScenario.eDLDataGroups.dG6 = UserLocalStore.shared.Biometry_FacialDataDG6
//
//        // biometry fingerprints
//        DocReader.shared.rfidScenario.eDLDataGroups.dG7 = UserLocalStore.shared.Biometry_FingerprintDG7
//
//        // biometry Iris data
//        DocReader.shared.rfidScenario.eDLDataGroups.dG8 = UserLocalStore.shared.Biometry_IrisDataDG8
//
//        // biometry Other
//        DocReader.shared.rfidScenario.eDLDataGroups.dG9 = UserLocalStore.shared.Biometry_OtherDG9
//
//        // not define
//        DocReader.shared.rfidScenario.eDLDataGroups.dG10 = UserLocalStore.shared.EDL_NotDefinedDG10
//
//        // Optional domestic data
//        DocReader.shared.rfidScenario.eDLDataGroups.dG11 = UserLocalStore.shared.OptionalDomesticDataDG11
//
//        // Non match alert
//        DocReader.shared.rfidScenario.eDLDataGroups.dG12 = UserLocalStore.shared.Non_MatchAlertDG12
//
//        // Actice authentication info
//        DocReader.shared.rfidScenario.eDLDataGroups.dG13 = UserLocalStore.shared.ActiveAuthenticationInfoDG13
//
//        // Eac Info
//        DocReader.shared.rfidScenario.eDLDataGroups.dG14 = UserLocalStore.shared.EACInfoDG14
    }
    
    //           DocReader.shared.processParams.doublePageSpread = true
    //           DocReader.shared.customization.cameraFrameActiveColor = .purple
    //           DocReader.shared.functionality.isZoomEnabled = true
    //
    //           DocReader.shared.functionality.zoomFactor = 10
    //           DocReader.shared.functionality.showCameraSwitchButton = true
    //           DocReader.shared.functionality.showCaptureButton = true
    //           DocReader.shared.functionality.showMetadataInfo = true
    //           DocReader.shared.processParams
               
               
               
               
    //           DocReader.shared.processParams.doublePageSpread = true
    //           DocReader.shared.processParams.timeout = 10
    ////           DocReader.shared.inputView?.motionEffects = true
    //           DocReader.shared.processParams.manualCrop = true
    //           DocReader.shared.processParams.integralImage
    
    func confirmSignUp(for username: String, with confirmationCode: String) async {
        do {
            let confirmSignUpResult = try await Amplify.Auth.confirmSignUp(
                for: username,
                confirmationCode: confirmationCode
            )
            print("Confirm sign up result completed: \(confirmSignUpResult.isSignUpComplete)")
        } catch let error as AuthError {
            print("An error occurred while confirming sign up \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    
    func signUp(username: String, password: String, email: String) async {
        let userAttributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        do {
            let signUpResult = try await Amplify.Auth.signUp(
                username: username,
                password: password,
                options: options
            )
            if case let .confirmUser(deliveryDetails, _, userId) = signUpResult.nextStep {
                print("Delivery details \(String(describing: deliveryDetails)) for userId: \(String(describing: userId))")
            } else {
                print("SignUp Complete")
            }
        } catch let error as AuthError {
            print("An error occurred while registering a user \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    
    func signIn() async {
        do {
            let signInResult = try await Amplify.Auth.signIn(
                username: "testuser",
                password: "Apple@123"
                )
            if signInResult.isSignedIn {
                print("Sign in succeeded")
                await fetchCurrentAuthSession()
            }
        } catch let error as AuthError {
            print("Sign in failed \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    
    
//    func hhh() async {
//        
//        do{
//            let auth = Amplify.Auth.getCurrentUser() {
//                // Assuming user is authenticated
//                auth.getTokens { (tokens, error) in
//                    if let error = error {
//                        print("Error getting tokens: \(error)")
//                        return
//                    }
//                    if let tokens = tokens {
//                        let accessToken = tokens.accessToken
//                        let idToken = tokens.idToken
//                        let sessionID = idToken?.tokenString // Session ID is typically within the ID token
//                        print("Session ID: \(sessionID ?? "N/A")")
//                    }
//                }
//                
//            }
//            
//        }
//    }
    
    
    func startCamera(value: String) {
        
//        var swiftUIView = MyView()
//        
//
//        swiftUIView.sessoinIdValue = value
//        
//               let hostingController = UIHostingController(rootView: swiftUIView)

    
       // navigationController?.pushViewController(hostingController, animated: true)
        
//        FaceLivenessDetectorView(
//              sessionID: value,
//              region: "us-east-1",
//              isPresented:  Binding<true>,
//              onCompletion: { result in
//                switch result {
//                case .success: break
//                  // ...
//                case .failure(let error): break
//                  // ...
//                default: break
//                  // ...
//                }
//              }
//            )
        
    }
    
    func dddasas () async{
        

        do {
            let session = try await Amplify.Auth.fetchAuthSession()

            // Get user sub or identity id
            if let identityProvider = session as? AuthCognitoIdentityProvider {
                
                let usersub = try identityProvider.getUserSub().get()
                let identityId = try identityProvider.getIdentityId().get()
                print("User sub - \(usersub) and identity id \(identityId)")
                startCamera(value: usersub)
            }


            
            
            // Get AWS credentials
            if let awsCredentialsProvider = session as? AuthAWSCredentialsProvider {
                let credentials = try awsCredentialsProvider.getAWSCredentials().get()
                // Do something with the credentials
                print(credentials.accessKeyId)
                print(credentials.secretAccessKey)
                
            }

            // Get cognito user pool token
            if let cognitoTokenProvider = session as? AuthCognitoTokensProvider {
                let tokens = try cognitoTokenProvider.getCognitoTokens().get()
                // Do something with the JWT tokens
                print(tokens.idToken)
            }
        } catch let error as AuthError {
            print("Fetch auth session failed with error - \(error)")
        } catch {
        }
    }
    
    
    func fetchCurrentAuthSession() async {
        do {
            
//            let sss = try await Amplify.Auth.getCurrentUser()
            
            
            let session = try await Amplify.Auth.fetchAuthSession()
            print("Is user signed in - \(session.isSignedIn)")
            
            print(session)
            
            if(session.isSignedIn == true) {
                startCamera(value: "ee")
            }
            else {
                await signIn()
            }
            
            
            
            
            
           // await dddasas ()
            
           // startCamera(value: auttt.userId)
            
            
//            auttt.getTokens { (tokens, error) in
//                if let error = error {
//                    print("Error getting tokens: \(error)")
//                    return
//                }
//                if let tokens = tokens {
//                    let accessToken = tokens.accessToken
//                    let idToken = tokens.idToken
//                    let sessionID = idToken?.tokenString // Session ID is typically within the ID token
//                    print("Session ID: \(sessionID ?? "N/A")")
//                }
//            }
            
            
            
            
        } catch let error as AuthError {
            print("Fetch session failed with error \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func testCode() {
        for scenario in DocReader.shared.availableScenarios {
            print(scenario)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    //MARK: Register Nib File
    
    func loadInitData(){
        optionsTV.register(UITableViewCell.self, forCellReuseIdentifier: "HomeCell")
        optionsTV.estimatedRowHeight = UITableView.automaticDimension
    }
    

    
    //MARK: Button Navigation
    
//    @IBAction func actionGoToSetting(_ sender: Any) {
//        let  vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    //MARK: Button Open Gallery
    
//    @IBAction func actionOpenGallery(_ sender: Any) {
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//                   imagePicker.sourceType = .photoLibrary
//                   present(imagePicker, animated: true, completion: nil)
//               } else {
//                   print("Can't open gallery")
//               }
//        
//    }
    //MARK: Image Picker Delegate Method
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            // Handle the selected image
            
            if( imageSourceType == "face") {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "FacematchingResults") as! FacematchingResults
                vc.capturedImage = selectedImage
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                UserLocalStore.shared.clickedIndex = 0
                let config = DocReader.RecognizeConfig(image: selectedImage)
                config.scenario = RGL_SCENARIO_FULL_PROCESS
                
                DocReader.shared.recognize(config: config) { (action, result, error) in
                    if action == .complete || action == .processTimeout  {
                            print(result?.rawResult as Any)
                            
                            if result?.chipPage != 0 && UserLocalStore.shared.RFIDChipProcessing == true {
                                self.startRFIDReading(result)
                            } else {
                                if ApplicationSetting.shared.isDataEncryptionEnabled {
                                    self.statusLabel.text = "Decrypting data..."
                                    self.activityIndicator.startAnimating()
                                    self.popUpView.isHidden = false
                                    self.processEncryptedResults(result!) { decryptedResult in
                                        DispatchQueue.main.async {
                                            self.popUpView.isHidden = true
                                            
                                            guard let results = decryptedResult else {
                                                print("Can't decrypt result")
                                                return
                                            }
                                            
                                           
                                            
                                            self.presentResults(results)
                                        }
                                    }
                                } else {
                                    self.presentResults(result!)
                                }
                            }
                            
                          
                                           
                         
                            
                        }
                    }
                    
                
            }
            
            
         
            
            
        }
        dismiss(animated: true, completion: nil)
    }

    // Delegate method to handle when the user cancels the image picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    
    //MARK: Button Open Camera
    
//    @IBAction func actionOpenCamera(_ sender: Any) {
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//                  imagePicker.sourceType = .camera
//                  present(imagePicker, animated: true, completion: nil)
//              } else {
//                 print("Please add Camera ")
//              }
//        
//    }
    
    
    
    
    //MARK: UITableView Delegate and Datasource Method
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return HomeDataManager.shared.getHomeData.count
       }
       
       // create a cell for each table view row
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


           var cell: HomeCell! = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as? HomeCell
                  if cell == nil {
                      tableView.register(UINib(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
                      cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as? HomeCell
                  }
           cell.title.text = HomeDataManager.shared.getHomeData[indexPath.row]["title"]
//           cell.title.text = "amplify_ui_liveness_get_ready_page_title".localizeString(string: "ar")
           cell.desc.text = HomeDataManager.shared.getHomeData[indexPath.row]["desc"]
           cell.img.image = UIImage(named: HomeDataManager.shared.getHomeData[indexPath.row]["image"]!)
           let clearView = UIView()
           clearView.backgroundColor = UIColor.clear
           cell.selectedBackgroundView = clearView

                  return cell
       }
       
   
    func fullProcessScanning(type : Int) {
        
        UserLocalStore.shared.allowTransaction = true
       
        let config = DocReader.ScannerConfig(scenario: "")
        //let config = DocReader.ScannerConfig()
        if(type == 0) {
           config.scenario = RGL_SCENARIO_FULL_AUTH   // RGL_SCENARIO_FULL_AUTH //RGL_SCENARIO_FULL_PROCESS
        }
       else if(type == 1) {
            config.scenario = RGL_SCENARIO_CREDIT_CARD
        }
       else if(type == 2) {
            config.scenario = RGL_SCENARIO_MRZ
        }
        else if(type == 3) {
             config.scenario = RGL_SCENARIO_BARCODE
         }
      
       
        DocReader.shared.showScanner(presenter: self, config: config) { [self] (action, result, error) in
           
            if action == .complete || action == .processTimeout {
                UserLocalStore.shared.allowTransaction = false
                
        
                 
                    if result?.chipPage != 0 && UserLocalStore.shared.RFIDChipProcessing == true {
                        UserLocalStore.shared.haveNFCChip = true
                       
                        self.startRFIDReading(result)
                    } else {
                        UserLocalStore.shared.haveNFCChip = false
                        if ApplicationSetting.shared.isDataEncryptionEnabled {
                            statusLabel.text = "Decrypting data..."
                            activityIndicator.startAnimating()
                            popUpView.isHidden = false
                            processEncryptedResults(result!) { decryptedResult in
                                DispatchQueue.main.async {
                                    self.popUpView.isHidden = true
                                    
                                    guard let results = decryptedResult else {
                                        print("Can't decrypt result")
                                        return
                                    }
                                    
                                   
                                    
                                    self.presentResults(results)
                                }
                            }
                        } else {
                            presentResults(result!)
                        }
                    }
                    
            
                
              
                
                
                
            
              
                               
             
                
            }
            else  if action == .cancel  {
                UserLocalStore.shared.allowTransaction = false
            }
        }
        
//  showCameraViewController()
    }
    
    
   
    
       // method to run when table view cell is tapped
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
          
           
           
//           let storyboard = UIStoryboard(name: "Main", bundle: nil)
//           let yourViewController = storyboard.instantiateViewController(withIdentifier: "TestLink") as! TestLink
//           self.present(yourViewController, animated: true, completion: nil)
//
//           
//           return
//           
          
           
           
         //  DocReader.shared.processParams.multipageProcessing = true
//           DocReader.shared.processParams.doublePageSpread = true
//           DocReader.shared.customization.cameraFrameActiveColor = .purple
//           DocReader.shared.functionality.isZoomEnabled = true
//           
//           DocReader.shared.functionality.zoomFactor = 10
//           DocReader.shared.functionality.showCameraSwitchButton = true
//           DocReader.shared.functionality.showCaptureButton = true
//           DocReader.shared.functionality.showMetadataInfo = true
//           DocReader.shared.processParams
           
           
           
           
//           DocReader.shared.processParams.doublePageSpread = true
//           DocReader.shared.processParams.timeout = 10
////           DocReader.shared.inputView?.motionEffects = true
//           DocReader.shared.processParams.manualCrop = true
//           DocReader.shared.processParams.integralImage
           
           UserLocalStore.shared.clickedIndex = indexPath.row
           
//           DocReader.shared.processParams.authenticityParams?.livenessParams?.checkHolo =  UserLocalStore.shared.HologramDetection == true ? 1 : 0
//       
//           DocReader.shared.processParams.authenticityParams?.livenessParams?.checkED = UserLocalStore.shared.HologramDetection == true ? 1 : 0
//           DocReader.shared.processParams.authenticityParams?.livenessParams?.checkOVI = UserLocalStore.shared.HologramDetection == true ? 1 : 0
//           DocReader.shared.processParams.authenticityParams?.livenessParams?.checkMLI = UserLocalStore.shared.HologramDetection == true ? 1 : 0
           
           
           
//           DocReader.shared.localizationHandler = { localizationKey in
//               // This will look up localization in `CustomLocalization.strings`.
//               let result = NSLocalizedString(localizationKey, tableName: "CustomLo", comment: "")
//
//               // Localization found in CustomLocalization.
//               if result != localizationKey {
//                   return result
//               }
//
//               // By returning nil we fallback to the default localization provided by SDK.
//               return nil
//           }
           
         
           isSpoofingType = false
           
        
           
           if(indexPath.row == 0 || indexPath.row == 3) {
               DocReader.shared.processParams.multipageProcessing = UserLocalStore.shared.MultipageProcessing == true ? 1 : 0

           }
           else {
               DocReader.shared.processParams.multipageProcessing = 0

           }
           
           
          // DocReader.shared.functionality.manualMultipageMode = true
           
           
            

               DocReader.shared.startNewSession()
           
          
           DocReader.shared.processParams.debugSaveLogs = true
           DocReader.shared.processParams.debugSaveCroppedImages = true
           DocReader.shared.processParams.debugSaveRFIDSession = true
           
           
//           DocReader.shared.processParams.respectImageQuality = true
//           DocReader.shared.processParams.imageQA.dpiThreshold = 150
//           DocReader.shared.processParams.imageQA.angleThreshold = 5
//           DocReader.shared.processParams.imageQA.focusCheck = true
//           DocReader.shared.processParams.imageQA.colornessCheck = true
//           DocReader.shared.processParams.imageQA.documentPositionIndent = 5
//           DocReader.shared.processParams.imageQA.expectedPass = [.imageResolution, .imageGlares]
//
//           DocReader.shared.processParams.imageQA.colornessCheck = true
//           
//           DocReader.shared.processParams.authenticityParams = AuthenticityParams.default()
//
//           DocReader.shared.processParams.authenticityParams?.livenessParams = LivenessParams.default()
//
//           
//           
//          
//
          
//           DocReader.shared.processParams.authenticityParams = AuthenticityParams.default()
//
//           DocReader.shared.processParams.authenticityParams?.checkImagePatterns = true
//           
//           DocReader.shared.processParams.authenticityParams = AuthenticityParams.default()
//
//           DocReader.shared.processParams.authenticityParams?.checkPhotoEmbedding = true
//           
//           DocReader.shared.processParams.authenticityParams?.livenessParams = LivenessParams.default()
        
          

           
          // topLayerView.isHidden = false
          // Loader.show()
           if indexPath.row == 0 {
              
               fullProcessScanning(type: 0)

           }
           
           
          else if indexPath.row == 1 {
              
              fullProcessScanning(type: 1)
              
//               let config = DocReader.ScannerConfig()
//               config.scenario = RGL_SCENARIO_CREDIT_CARD
//
//               DocReader.shared.showScanner(presenter: self, config: config) { [self] (action, result, error) in
//                   if action == .complete || action == .processTimeout {
//                       print(result?.rawResult as Any)
//                     
//                       
//                       if result?.chipPage != 0 && UserLocalStore.shared.RFIDChipProcessing == true {
//                           self.startRFIDReading(result)
//                       } else {
//                           if ApplicationSetting.shared.isDataEncryptionEnabled {
//                               statusLabel.text = "Decrypting data..."
//                               activityIndicator.startAnimating()
//                               popUpView.isHidden = false
//                               processEncryptedResults(result!) { decryptedResult in
//                                   DispatchQueue.main.async {
//                                       self.popUpView.isHidden = true
//                                       
//                                       guard let results = decryptedResult else {
//                                           print("Can't decrypt result")
//                                           return
//                                       }
//                                       
//                                      
//                                       
//                                       self.presentResults(results)
//                                   }
//                               }
//                           } else {
//                               presentResults(result!)
//                           }
//                       }
//                       
//                                      
//                   
//                       
//                   }
//               }
//               
        //showCameraViewController()

           }
           
           
           else if indexPath.row == 2 {
              // showCameraViewControllerForMrz()
               fullProcessScanning(type: 2)
//                let config = DocReader.ScannerConfig()
//                config.scenario = RGL_SCENARIO_MRZ
//
//                DocReader.shared.showScanner(presenter: self, config: config) { [self] (action, result, error) in
//                    if action == .complete || action == .processTimeout {
//                        print(result?.rawResult as Any)
//                      
//                                       
//                        if ApplicationSetting.shared.isDataEncryptionEnabled {
//                            statusLabel.text = "Decrypting data..."
//                            activityIndicator.startAnimating()
//                            popUpView.isHidden = false
//                            processEncryptedResults(result!) { decryptedResult in
//                                DispatchQueue.main.async {
//                                    self.popUpView.isHidden = true
//                                    
//                                    guard let results = decryptedResult else {
//                                        print("Can't decrypt result")
//                                        return
//                                    }
//                                    
//                                   
//                                    
//                                    self.presentResults(results)
//                                }
//                            }
//                        } else {
//                            presentResults(result!)
//                        }
//                        
//                    }
//                }
//                
         //showCameraViewController()

            }
           
//           else if indexPath.row == 3 {
//               
//              // fullProcessScanning(type: 3)
//               executePassiveLiveness()
//               
//
//                
//
//            }
//           
//           else if indexPath.row == 4 {
//               executeFaceMatching()
////               let config = DocReader.ScannerConfig(scenario: "")
////              //  let config = DocReader.ScannerConfig()
////                config.scenario = RGL_SCENARIO_OCR
////
////                DocReader.shared.showScanner(presenter: self, config: config) { [self] (action, result, error) in
////                    if action == .complete || action == .processTimeout {
////                        print(result?.rawResult as Any)
////                      
////                                       
////                        if ApplicationSetting.shared.isDataEncryptionEnabled {
////                            statusLabel.text = "Decrypting data..."
////                            activityIndicator.startAnimating()
////                            popUpView.isHidden = false
////                            processEncryptedResults(result!) { decryptedResult in
////                                DispatchQueue.main.async {
////                                    self.popUpView.isHidden = true
////                                    
////                                    guard let results = decryptedResult else {
////                                        print("Can't decrypt result")
////                                        return
////                                    }
////                                    
////                                   
////                                    
////                                    self.presentResults(results)
////                                }
////                            }
////                        } else {
////                            presentResults(result!)
////                        }
////                        
////                    }
////                }
//                
//
//            }
           
           else if indexPath.row == 3 {
              
               DocReader.shared.functionality.videoSessionPreset = AVCaptureSession.Preset.hd4K3840x2160
               DocReader.shared.processParams.imageQA.colornessCheck = true
               DocReader.shared.processParams.authenticityParams?.useLivenessCheck = 1
               DocReader.shared.processParams.authenticityParams?.livenessParams?.checkHolo = 1
               DocReader.shared.processParams.authenticityParams?.livenessParams?.checkOVI = 1
               DocReader.shared.processParams.authenticityParams?.livenessParams?.checkED = 1
               DocReader.shared.processParams.authenticityParams?.livenessParams?.checkMLI = 1
               DocReader.shared.processParams.authenticityParams?.checkImagePatterns = 1
               DocReader.shared.processParams.authenticityParams?.checkPhotoEmbedding = 1
               DocReader.shared.processParams.authenticityParams?.checkBarcodeFormat = 1
               DocReader.shared.processParams.authenticityParams?.checkPhotoComparison = 1
               DocReader.shared.processParams.authenticityParams?.checkUVLuminiscence = 1
               DocReader.shared.processParams.authenticityParams?.checkFibers = 1
               DocReader.shared.processParams.authenticityParams?.checkExtMRZ = 1
               DocReader.shared.processParams.authenticityParams?.checkExtOCR = 1
               DocReader.shared.processParams.authenticityParams?.checkIRB900 = 1
               DocReader.shared.processParams.authenticityParams?.checkIRVisibility = 1
               DocReader.shared.processParams.authenticityParams?.checkIPI = 1
               DocReader.shared.processParams.authenticityParams?.checkAxial = 1
               DocReader.shared.processParams.authenticityParams?.checkLetterScreen = 1
               
               DocReader.shared.processParams.imageQA.colornessCheck = true
               DocReader.shared.processParams.imageQA.focusCheck = true
               DocReader.shared.processParams.imageQA.glaresCheck = true
               DocReader.shared.processParams.imageQA.screenCapture = true
               DocReader.shared.processParams.imageQA.documentPositionIndent = true
               
               isSpoofingType = true
               fullProcessScanning(type: 0)
//               let vc = self.storyboard?.instantiateViewController(withIdentifier: "IDSpoofingResults") as! IDSpoofingResults
//              // vc.completeResults = results
//               self.navigationController?.pushViewController(vc, animated: true)
//               
         

            }
           
           else if indexPath.row == 4 {
               executePassiveLiveness()
            }
           
           else if indexPath.row == 5 {
               executeFaceMatching()
            }
           
           else{
               print("You tapped cell number \(indexPath.row).")
               let vc = self.storyboard?.instantiateViewController(withIdentifier: "StartProcessViewController") as! StartProcessViewController
               self.navigationController?.pushViewController(vc, animated: true)
           }

       }

    
    func executePassiveLiveness() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PassiveLivenessResults") as! PassiveLivenessResults
        self.navigationController?.pushViewController(vc, animated: true)
       //
    }
    
    func executeFaceMatching() {
        imageSourceType = "face"
        let actionSheet = UIAlertController(title: "choose_image".localizeString(string: HomeDataManager.shared.languageCodeString), message: nil, preferredStyle: .actionSheet)
                
                // Option for Camera
                actionSheet.addAction(UIAlertAction(title: "camera".localizeString(string: HomeDataManager.shared.languageCodeString), style: .default, handler: { _ in
                    self.openCamera()
                }))
                
                // Option for Gallery
                actionSheet.addAction(UIAlertAction(title: "gallery".localizeString(string: HomeDataManager.shared.languageCodeString), style: .default, handler: { _ in
                    self.openGallery()
                }))
                
                // Cancel option
                actionSheet.addAction(UIAlertAction(title: "cancel".localizeString(string: HomeDataManager.shared.languageCodeString), style: .cancel, handler: nil))
                
                self.present(actionSheet, animated: true, completion: nil)
    }
    
    func openCamera() {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let pickerController = UIImagePickerController()
                pickerController.delegate = self
                pickerController.sourceType = .camera
               // pickerController.allowsEditing = true
                self.present(pickerController, animated: true, completion: nil)
            } else {
                // Show alert if camera is not available
                let alert = UIAlertController(title: "Error", message: "Camera not available", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        // MARK: - Open Gallery
        func openGallery() {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let pickerController = UIImagePickerController()
                pickerController.delegate = self
                pickerController.sourceType = .photoLibrary
                //pickerController.allowsEditing = true
                self.present(pickerController, animated: true, completion: nil)
            }
        }
    
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
    }
    
    
    
    // MARK: - Private methods

    lazy var onlineProcessing: CustomizationItem = {
        let item = CustomizationItem("Online Processing") { [weak self] in
            guard let self = self else { return }
            let container = UINavigationController(rootViewController: OnlineProcessingViewController())
            container.modalPresentationStyle = .fullScreen
            self.present(container, animated: true, completion: nil)
        }
        return item
    }()

    private func initSectionsWithoutLicence() {
        let childModeSection = CustomizationSection("Custom", [onlineProcessing])
        sectionsData.append(childModeSection)
    }
    
    private func initSections() {
        // 1. Default
        let defaultScanner = CustomizationItem("Default (showScanner)") {
            DocReader.shared.functionality = ApplicationSetting.shared.functionality
        }
        
        defaultScanner.resetFunctionality = false
        let stillImage = CustomizationItem("Gallery (recognizeImages)")
        stillImage.actionType = .gallery
        let recognizeImageInput = CustomizationItem("Recognize images with light type") { [weak self] in
            guard let self = self else { return }
            self.recognizeImagesWithImageInput()
        }
        
        recognizeImageInput.actionType = .custom
        let defaultSection = CustomizationSection("Default", [defaultScanner, stillImage, recognizeImageInput])
        sectionsData.append(defaultSection)
        
        // 2. Custom modes
        let childModeScanner = CustomizationItem("Child mode") { [weak self] in
            guard let self = self else { return }
            self.showAsChildViewController()
        }
        childModeScanner.actionType = .custom
        let manualMultipageMode = CustomizationItem("Manual multipage mode") { [weak self] in
            guard let self = self else { return }
            // Set default copy of functionality
            DocReader.shared.functionality = ApplicationSetting.shared.functionality
            // Manual multipage mode
            DocReader.shared.functionality.manualMultipageMode = true
            DocReader.shared.startNewSession()
            self.showScannerForManualMultipage()
        }
        manualMultipageMode.resetFunctionality = false
        manualMultipageMode.actionType = .custom
        let customModedSection = CustomizationSection("Custom", [childModeScanner, manualMultipageMode, onlineProcessing])
        sectionsData.append(customModedSection)
        
        // 3. Custom camera frame
        let customBorderWidth = CustomizationItem("Custom border width") { () -> (Void) in
            DocReader.shared.customization.cameraFrameBorderWidth = 10
        }
        let customBorderColor = CustomizationItem("Custom border color") { () -> (Void) in
            DocReader.shared.customization.cameraFrameDefaultColor = .red
            DocReader.shared.customization.cameraFrameActiveColor = .purple
        }
        let customShape = CustomizationItem("Custom shape") { () -> (Void) in
            DocReader.shared.customization.cameraFrameShapeType = .corners
            DocReader.shared.customization.cameraFrameLineLength = 40
            DocReader.shared.customization.cameraFrameCornerRadius = 10
            DocReader.shared.customization.cameraFrameLineCap = .round
        }
        let customOffset = CustomizationItem("Custom offset") { () -> (Void) in
            DocReader.shared.customization.cameraFrameOffsetWidth = 50
        }
        let customAspectRatio = CustomizationItem("Custom aspect ratio") { () -> (Void) in
            DocReader.shared.customization.cameraFramePortraitAspectRatio = 1.0
            DocReader.shared.customization.cameraFrameLandscapeAspectRatio = 1.0
        }
        let customFramePosition = CustomizationItem("Custom position") { () -> (Void) in
            DocReader.shared.customization.cameraFrameVerticalPositionMultiplier = 0.5
        }
        
        let customCameraFrameItems = [customBorderWidth, customBorderColor, customShape, customOffset, customAspectRatio, customFramePosition]
        let customCameraFrameSection = CustomizationSection("Custom camera frame", customCameraFrameItems)
        sectionsData.append(customCameraFrameSection)
        
        // 4. Custom toolbar
        let customTorchButton = CustomizationItem("Custom torch button") { () -> (Void) in
            DocReader.shared.functionality.showTorchButton = true
            DocReader.shared.customization.torchButtonOnImage = UIImage(named: "light-on")
            DocReader.shared.customization.torchButtonOffImage = UIImage(named: "light-off")
        }
        let customCameraSwitch = CustomizationItem("Custom camera switch button") { () -> (Void) in
            DocReader.shared.functionality.showCameraSwitchButton = true
            DocReader.shared.customization.cameraSwitchButtonImage = UIImage(named: "camera")
        }
        let customCaptureButton = CustomizationItem("Custom capture button") { () -> (Void) in
            DocReader.shared.functionality.showCaptureButton = true
            DocReader.shared.functionality.showCaptureButtonDelayFromStart = 0
            DocReader.shared.functionality.showCaptureButtonDelayFromDetect = 0
            DocReader.shared.customization.captureButtonImage = UIImage(named: "palette")
        }
        let customChangeFrameButton = CustomizationItem("Custom change frame button") { () -> (Void) in
            DocReader.shared.functionality.showChangeFrameButton = true
            DocReader.shared.customization.changeFrameButtonExpandImage = UIImage(named: "expand")
            DocReader.shared.customization.changeFrameButtonCollapseImage = UIImage(named: "collapse")
        }
        let customCloseButton = CustomizationItem("Custom close button") { () -> (Void) in
            DocReader.shared.functionality.showCloseButton = true
            DocReader.shared.customization.closeButtonImage = UIImage(named: "close")
        }
        let customSizeOfToolbar = CustomizationItem("Custom size of the toolbar") { () -> (Void) in
            DocReader.shared.customization.toolbarSize = 120
            DocReader.shared.customization.torchButtonOnImage = UIImage(named: "light-on")
            DocReader.shared.customization.torchButtonOffImage = UIImage(named: "light-off")
            DocReader.shared.customization.closeButtonImage = UIImage(named: "big_close")
            //DocReader.shared.customization.
        }
        
        let customToolbarItems = [customTorchButton, customCameraSwitch, customCaptureButton, customChangeFrameButton, customCloseButton, customSizeOfToolbar]
        let customToolbarSection = CustomizationSection("Custom toolbar", customToolbarItems)
        sectionsData.append(customToolbarSection)
        
        // 5. Custom status messages
        let customText = CustomizationItem("Custom text") { () -> (Void) in
            DocReader.shared.customization.showStatusMessages = true
            DocReader.shared.customization.status = "Custom status"
        }
        
        let customTextFont = CustomizationItem("Custom text font") { () -> (Void) in
            DocReader.shared.customization.showStatusMessages = true
            DocReader.shared.customization.statusTextFont = UIFont.systemFont(ofSize: 24, weight: .semibold)
        }
        
        let customTextColor = CustomizationItem("Custom text color") { () -> (Void) in
            DocReader.shared.customization.showStatusMessages = true
            DocReader.shared.customization.statusTextColor = .blue
        }
        let customStatusPosition = CustomizationItem("Custom position") { () -> (Void) in
            DocReader.shared.customization.showStatusMessages = true
            DocReader.shared.customization.statusPositionMultiplier = 0.5
        }
        
        let customStatusItems = [customText, customTextFont, customTextColor, customStatusPosition]
        let customStatusSection = CustomizationSection("Custom status messages", customStatusItems)
        sectionsData.append(customStatusSection)
        
        // 6. Custom result status messages
        let customResultStatusText = CustomizationItem("Custom text") { () -> (Void) in
            DocReader.shared.customization.showResultStatusMessages = true
            DocReader.shared.customization.resultStatus = "Custom result status"
        }
        let customResultStatusFont = CustomizationItem("Custom text font") { () -> (Void) in
            DocReader.shared.customization.showResultStatusMessages = true
            DocReader.shared.customization.resultStatusTextFont = UIFont.systemFont(ofSize: 24, weight: .semibold)
        }
        let customResultStatusColor = CustomizationItem("Custom text color") { () -> (Void) in
            DocReader.shared.customization.showResultStatusMessages = true
            DocReader.shared.customization.resultStatusTextColor = .blue
        }
        let customResultStatusBackColor = CustomizationItem("Custom background color") { () -> (Void) in
            DocReader.shared.customization.showResultStatusMessages = true
            DocReader.shared.customization.resultStatusBackgroundColor = .blue
        }
        let customResultStatusPosition = CustomizationItem("Custom position") { () -> (Void) in
            DocReader.shared.customization.showResultStatusMessages = true
            DocReader.shared.customization.resultStatusPositionMultiplier = 0.5
        }
        
        let customResultStatusItems = [customResultStatusText, customResultStatusFont, customResultStatusColor, customResultStatusBackColor, customResultStatusPosition]
        let customResultStatusSection = CustomizationSection("Custom result status messages", customResultStatusItems)
        sectionsData.append(customResultStatusSection)
        
        // 7. Free custom status
        let freeCustomTextAndPostion = CustomizationItem("Free text + position") { () -> (Void) in
            let fontAttributes =  [NSAttributedString.Key.foregroundColor: UIColor.red, NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 18)]
            DocReader.shared.customization.customLabelStatus = NSAttributedString(string: "Hello, world!", attributes: fontAttributes)
            DocReader.shared.customization.customStatusPositionMultiplier = 0.5
        }
        
        let customUILayerModeStatic = CustomizationItem("Custom Status & Images & Buttons") { [weak self] in
            guard let self = self else { return }
            self.setupCustomUIFromFile()
        }
        let customUILayerButtons = CustomizationItem("Custom Buttons") { [weak self] in
            guard let self = self else { return }
            self.setupCustomUIButtonsFromFile()
        }
        
        let customUILayerModeAnimated = CustomizationItem("Custom Status Animated") { [weak self] in
            guard let self = self else { return }
            self.isCustomUILayerEnabled = true
            self.animationTimer.fire()
        }
        
        let freeCustomStatusItems = [freeCustomTextAndPostion, customUILayerModeStatic, customUILayerButtons, customUILayerModeAnimated]
        let freeCustomStatusSection = CustomizationSection("Free custom status", freeCustomStatusItems)
        sectionsData.append(freeCustomStatusSection)
        
        // 8. Custom animations
        let customAnimationHelpImage = CustomizationItem("Help animation image") { () -> (Void) in
            DocReader.shared.customization.showHelpAnimation = true
            DocReader.shared.customization.helpAnimationImage = UIImage(named: "credit-card")
        }
        let customAnimationNextPageImage = CustomizationItem("Custom the next page animation") { () -> (Void) in
            DocReader.shared.customization.showNextPageAnimation = true
            DocReader.shared.customization.multipageAnimationFrontImage = UIImage(named: "1")
            DocReader.shared.customization.multipageAnimationBackImage = UIImage(named: "2")
        }
        
        let customAnimationItems = [customAnimationHelpImage, customAnimationNextPageImage]
        let customAnimationSection = CustomizationSection("Custom animations", customAnimationItems)
        sectionsData.append(customAnimationSection)
        
        // 9. Custon tint color
        let customTintColor = CustomizationItem("Activity indicator") { () -> (Void) in
            DocReader.shared.customization.activityIndicatorColor = .red
        }
        let custonNextPageButton = CustomizationItem("Next page button") { () -> (Void) in
            DocReader.shared.functionality.showSkipNextPageButton = true
            DocReader.shared.customization.multipageButtonBackgroundColor = .red
        }
        let customAllVisualElements = CustomizationItem("All visual elements") { () -> (Void) in
            DocReader.shared.customization.tintColor = .blue
        }
        
        let customTintColorItems = [customTintColor, custonNextPageButton, customAllVisualElements]
        let customTintColorSection = CustomizationSection("Custom tint color", customTintColorItems)
        sectionsData.append(customTintColorSection)
        
        // 10. Custom background
        let noBackgroundMask = CustomizationItem("No background mask") { () -> (Void) in
            DocReader.shared.customization.showBackgroundMask = false
        }
        let customBackgroundAlpha = CustomizationItem("Custom alpha") { () -> (Void) in
            DocReader.shared.customization.backgroundMaskAlpha = 0.8
        }
        let customBackgroundImage = CustomizationItem("Custom background image") { () -> (Void) in
            DocReader.shared.customization.borderBackgroundImage = UIImage(named: "viewfinder")
        }
        
        let customBackgroundItems = [noBackgroundMask, customBackgroundAlpha, customBackgroundImage]
        let customBackgroundSection = CustomizationSection("Custom background", customBackgroundItems)
        sectionsData.append(customBackgroundSection)
    }
    
    private func enableUserInterfaceOnSuccess() {
       popUpView.isHidden = true
       optionsTV.isHidden = false
        bottomView.isUserInteractionEnabled = true
        if let scenario = DocReader.shared.availableScenarios.first {
            selectedScenario = scenario.identifier
        }
    }
    
    private func showScannerForManualMultipage() {
        let config = DocReader.ScannerConfig(scenario: "")
        
       // let config = DocReader.ScannerConfig()
        config.scenario = selectedScenario
        
        DocReader.shared.showScanner(presenter: self, config:config) { [weak self] (action, result, error) in
            guard let self = self else { return }
            switch action {
            case .cancel:
                print("Cancelled by user")
                DocReader.shared.functionality.manualMultipageMode = false
            case .complete, .processTimeout:
                guard let results = result else {
                    return
                }
                if results.morePagesAvailable != 0 {
                    // Scan next page in manual mode
                    DocReader.shared.startNewPage()
                    self.showScannerForManualMultipage()
                } else if !results.isResultsEmpty() {
                    self.showResultScreen(results)
                    DocReader.shared.functionality.manualMultipageMode = false
                }
            case .error:
                print("Error")
                guard let error = error else { return }
                print("Error string: \(error)")
            case .process:
                guard let result = result else { return }
                print("Scaning not finished. Result: \(result)")
            default:
                break
            }
        }
    }
    
    private func recognizeImagesWithImageInput() {
        let whiteImage = UIImage(named: "white.bmp")
        let uvImage = UIImage(named: "uv.bmp")
        let irImage = UIImage(named: "ir.bmp")
        
        let whiteInput = DocReader.ImageInput(image: whiteImage!, light: .white, pageIndex: 0)
        let uvInput = DocReader.ImageInput(image: uvImage!, light: .UV, pageIndex: 0)
        let irInput = DocReader.ImageInput(image: irImage!, light: .infrared, pageIndex: 0)
        let imageInputs = [whiteInput, irInput, uvInput]
        
        let config = DocReader.RecognizeConfig(imageInputs: imageInputs)
        config.scenario = selectedScenario
        DocReader.shared.recognize(config:config) { action, results, error in
            switch action {
            case .cancel:
                self.stopCustomUIChanges()
                print("Cancelled by user")
            case .complete, .processTimeout:
                self.stopCustomUIChanges()
                guard let opticalResults = results else {
                    return
                }
                self.showResultScreen(opticalResults)
            case .error:
                self.stopCustomUIChanges()
                print("Error")
                guard let error = error else { return }
                print("Error string: \(error)")
            case .process:
                guard let result = results else { return }
                print("Scaning not finished. Result: \(result)")
            case .morePagesAvailable:
                print("This status couldn't be here, it uses for -recognizeImage function")
            default:
                break
            }
        }
    }
    
    private func showAsChildViewController() {
        let mainStoryboard = UIStoryboard(name: kMainStoryboardId, bundle: nil)

    }
    
    private func startRFIDReading(_ opticalResults: DocumentReaderResults? = nil) {
        if ApplicationSetting.shared.useCustomRfidController {
            let mainStoryboard = UIStoryboard(name: kMainStoryboardId, bundle: nil)
            guard let rfidController = self.storyboard?.instantiateViewController(withIdentifier: "DocumentReaderVC") as? DocumentReaderVC else {
                return
            }
            rfidController.modalPresentationStyle = .fullScreen
            rfidController.opticalResults = opticalResults
            rfidController.completionHandler = { (results) in
                self.showResultScreen(results)
            }
            present(rfidController, animated: true, completion: nil)
        } else {
            DocReader.shared.startRFIDReader(fromPresenter: self, completion: { [weak self] (action, results, error) in
                guard let self = self else { return }
                switch action {
                case .complete:
                    guard let results = results else {
                        return
                    }
                    self.showResultScreen(results)
                case .cancel:
                    guard let results = opticalResults else {
                        return
                    }
                    self.showResultScreen(results)
                case .processTimeout:
                    self.view.makeToast("something_went_wrong".localizeString(string: HomeDataManager.shared.languageCodeString), duration: 2)
                    guard let results = results else {
                        return
                    }
                    self.showResultScreen(results)
                    
                case .error:
                    print("Error---")
                    self.view.makeToast("something_went_wrong".localizeString(string: HomeDataManager.shared.languageCodeString), duration: 2)
                    guard let results = opticalResults else {
                        return
                    }
                    self.showResultScreen(results)
                default:
                    break
                }
            })
        }
    }
    
    private func showResultScreen(_ results: DocumentReaderResults) {
        if ApplicationSetting.shared.isDataEncryptionEnabled {
            statusLabel.text = "Decrypting data..."
            activityIndicator.startAnimating()
            popUpView.isHidden = false
            processEncryptedResults(results) { decryptedResult in
                DispatchQueue.main.async {
                    self.popUpView.isHidden = true
                    
                    guard let results = decryptedResult else {
                        print("Can't decrypt result")
                        return
                    }
                    self.presentResults(results)
                }
            }
        } else {
            presentResults(results)
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    var audioPlayer: AVAudioPlayer?
   
    
    private func presentResults(_ results: DocumentReaderResults) {
        
      
        if(isSpoofingType == true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "IDSpoofingResults") as! IDSpoofingResults
                vc.completeResults = results
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
            
        }
        else {
            UserLocalStore.shared.documentMisMatch = false
         
            var docStatusCode = 0
            var isDigitalScreen = false
            var isColorness = false
            
            UserLocalStore.shared.haveError = ""
            
            if !isConnectedToNetwork(){
                self.view.makeToast("internet_error".localizeString(string: HomeDataManager.shared.languageCodeString))
                return
            }
            
            
            if (results.textResult.fields.count == 0){
                self.view.makeToast("valid_document".localizeString(string: HomeDataManager.shared.languageCodeString))
                return
            }
            var countriesArray = [String]()
            var numberArray = [String]()
            var issueArray = [String]()
            var namesArray = [String]()
            
            for i in 0 ..< (results.authenticityResults?.checks?.count ?? 0) {
                    if(results.authenticityResults?.checks![i].type.rawValue == 2097152 &&
                       results.authenticityResults?.checks![i].status.rawValue == 0) {
                        isDigitalScreen = true
                    }
                
                
            }
            if(results.imageQualityGroup?.count != 0) {
                if results.imageQualityGroup?[0].imageQualityList.count ?? 0 > 0 {
                    for i in 0 ..< (results.imageQualityGroup?[0].imageQualityList.count ?? 0) {
                            if(results.imageQualityGroup![0].imageQualityList[i].type == "3" &&
                               results.imageQualityGroup![0].imageQualityList[i].result.rawValue != 1) {
                                isColorness = true
                            }
                        }
                }
            }
         
            
            
           // po results.authenticityResults?.checks![1].type.rawValue
            
            for i in 0 ..< results.textResult.fields.count {
                
                if(results.textResult.fields[i].fieldName.lowercased() == "document status") {
                    docStatusCode = results.textResult.fields[i].fieldType.rawValue
                
                }
                
                print(results.textResult.fields[i].fieldName)
                print(results.textResult.fields[i].fieldType)
                print(results.textResult.fields[i].value)
                
            let fieldName = results.textResult.fields[i].fieldName
               
                if(countriesArray.count == 0) {
                    if(fieldName.lowercased().contains("country")) {
                        if(results.textResult.fields[i].values.count >= 2) {
                            for k in 0 ..< results.textResult.fields[i].values.count {
                                countriesArray.append(results.textResult.fields[i].values[k].value)
                            }
                        }
                    }
                }
               
               // || fieldName.lowercased().contains("personal number")
                
                if(numberArray.count == 0) {
                    if(fieldName.lowercased().contains("document number") ) {
                        if(results.textResult.fields[i].values.count >= 2) {
                            for k in 0 ..< results.textResult.fields[i].values.count {
                                numberArray.append(results.textResult.fields[i].values[k].value)
                            }
                        }
                    }
                }
                
              
                if(issueArray.count == 0) {
                    if(fieldName.lowercased().contains("issue")) {
                        if(results.textResult.fields[i].values.count >= 2) {
                            for k in 0 ..< results.textResult.fields[i].values.count {
                                issueArray.append(results.textResult.fields[i].values[k].value)
                            }
                        }
                    }
                }
                
                
                if(namesArray.count == 0) {
                    if(fieldName.lowercased().contains("surname and given names")) {
                        if(results.textResult.fields[i].values.count >= 2) {
                            for k in 0 ..< results.textResult.fields[i].values.count {
                                namesArray.append(results.textResult.fields[i].values[k].value)
                            }
                        }
                    }
                }
            
            
            
        }
            
           // && results.documentType?.count ?? 0 < 2
            
            
            if ((results.documentType?[0].dDescription == "Identity Card" || results.documentType?[0].dDescription == "Driving License") ) {
                if(results.documentType?.count ?? 0 < 2) {
                    UserLocalStore.shared.haveError = "yes"
                    //self.view.makeToast("Document missmatched", duration: 4)
                }
            }
            
            if(docStatusCode == 682) {
             
              UserLocalStore.shared.haveError = "yes"
              self.view.makeToast("specimen_copy".localizeString(string: HomeDataManager.shared.languageCodeString), duration: 4)
              
          }
             
    //        if(isDigitalScreen == true) {
    //            UserLocalStore.shared.haveError = "yes"
    //            self.view.makeToast("Digital Screen Document", duration: 4)
    //
    //        }
            
            if(isColorness == true) {
                UserLocalStore.shared.haveError = "yes"
                self.view.makeToast("Image_colorness".localizeString(string: HomeDataManager.shared.languageCodeString), duration: 4)

            }
             if(numberArray.count != 0) {
                let allItemsEqual = numberArray.allSatisfy { $0 == numberArray.first }
                if(allItemsEqual == false) {
                   // self.view.makeToast("Document missmatched", duration: 4)
                    UserLocalStore.shared.haveError = "yes"
                }
              
            }
                 
              if(countriesArray.count != 0) {
                let allItemsEqual = countriesArray.allSatisfy { $0 == countriesArray.first }
                if(allItemsEqual == false) {
                   // self.view.makeToast("Document missmatched", duration: 4)
                    UserLocalStore.shared.haveError = "yes"
                }
                
                
            }
            
                    
            if(issueArray.count != 0) {
                        let allItemsEqual = issueArray.allSatisfy { $0 == issueArray.first }
                        if(allItemsEqual == false) {
                           // self.view.makeToast("Document missmatched", duration: 4)
                            UserLocalStore.shared.haveError = "yes"
                        }
                      
                    }
                    
    //        if(namesArray.count != 0) {
    //                    let allItemsEqual = namesArray.allSatisfy { $0 == namesArray.first }
    //                    if(allItemsEqual == false) {
    //                        self.view.makeToast("Document missmatched", duration: 4, image: UIImage(named: "Toast"))
    //                        UserLocalStore.shared.haveError = "yes"
    //                    }
    //
    //                }
            
            if(UserLocalStore.shared.haveError != "") {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    self.handleDataForNavigation(results)
                }
            }
            else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                    self.handleDataForNavigation(results)
                }
            }
            
          
         
              
            
            
            
            
            
            
            
            
            
            
            
            
    //
    //        if ((results.documentType?[0].dDescription == "Identity Card" || results.documentType?[0].dDescription == "Driving License") ) {
    //            if(results.documentType?.count ?? 0 < 2) {
    //                Alert.shared.displayMyAlertMessage(title: "Alert", message: "Document missmatched", actionTitle: "Ok") {
    //                    print("doesn't match document")
    //                    UserLocalStore.shared.documentMisMatch = true
    //                    UserLocalStore.shared.haveError = "yes"
    //                    self.handleDataForNavigation(results)
    //                }
    //            }
    //            else {
    //
    //                  if(docStatusCode == 682) {
    //
    //                        Alert.shared.displayMyAlertMessage(title: "Alert", message: "Specimen Copy", actionTitle: "Ok") {
    //                            print("doesn't match document")
    //                            UserLocalStore.shared.haveError = "yes"
    //                            self.handleDataForNavigation(results)
    //                        }
    //                      //  return
    //
    //                }
    //
    //                else  if(isDigitalScreen == true) {
    //
    //                        Alert.shared.displayMyAlertMessage(title: "Alert", message: "Digital Screen Document", actionTitle: "Ok") {
    //                            print("doesn't match document")
    //                            UserLocalStore.shared.haveError = "yes"
    //                            self.handleDataForNavigation(results)
    //                        }
    //                      //  return
    //
    //                }
    //
    //                else  if(isColorness == true) {
    //
    //                        Alert.shared.displayMyAlertMessage(title: "Alert", message: "Image is colorness", actionTitle: "Ok") {
    //                            print("doesn't match document")
    //                            UserLocalStore.shared.haveError = "yes"
    //                            self.handleDataForNavigation(results)
    //                        }
    //                      //  return
    //
    //                }
    //
    //        //      else  if(countriesArray.count != 0) {
    //        //            let allItemsEqual = countriesArray.allSatisfy { $0 == countriesArray.first }
    //        //            if(allItemsEqual == false) {
    //        //                Alert.shared.displayMyAlertMessage(title: "Alert", message: "Document missmatched", actionTitle: "Ok") {
    //        //                    print("doesn't match document")
    //        //                    UserLocalStore.shared.haveError = "yes"
    //        //                    self.handleDataForNavigation(results)
    //        //                }
    //        //               // return
    //        //            }
    //        //          else {
    //        //              handleDataForNavigation(results)
    //        //          }
    //        //        }
    //
    //                else if(numberArray.count != 0) {
    //                    let allItemsEqual = numberArray.allSatisfy { $0 == numberArray.first }
    //                    if(allItemsEqual == false) {
    //                        Alert.shared.displayMyAlertMessage(title: "Alert", message: "Document missmatched", actionTitle: "Ok") {
    //                            print("doesn't match document")
    //                            UserLocalStore.shared.haveError = "yes"
    //                            self.handleDataForNavigation(results)
    //                        }
    //                      //  return
    //                    }
    //                    else {
    //                        handleDataForNavigation(results)
    //                    }
    //                }
    //
    //        //        else  if(issueArray.count != 0) {
    //        //            let allItemsEqual = issueArray.allSatisfy { $0 == issueArray.first }
    //        //            if(allItemsEqual == false) {
    //        //                Alert.shared.displayMyAlertMessage(title: "Alert", message: "Document missmatched", actionTitle: "Ok") {
    //        //                    print("doesn't match document")
    //        //                    UserLocalStore.shared.haveError = "yes"
    //        //                    self.handleDataForNavigation(results)
    //        //                }
    //        //                //return
    //        //            }
    //        //            else {
    //        //                handleDataForNavigation(results)
    //        //            }
    //        //        }
    //        //        else  if(namesArray.count != 0) {
    //        //            let allItemsEqual = namesArray.allSatisfy { $0 == namesArray.first }
    //        //            if(allItemsEqual == false) {
    //        //                Alert.shared.displayMyAlertMessage(title: "Alert", message: "Document missmatched", actionTitle: "Ok") {
    //        //                    print("doesn't match document")
    //        //                    UserLocalStore.shared.haveError = "yes"
    //        //                    self.handleDataForNavigation(results)
    //        //                }
    //        //               // return
    //        //            }
    //        //            else {
    //        //                handleDataForNavigation(results)
    //        //            }
    //        //        }
    //
    //
    //                else {
    //                    handleDataForNavigation(results)
    //                }
    //
    //            }
    //
    //
    //
    //        }
    //        else {
    //            Alert.shared.displayMyAlertMessage(title: "Alert", message: "Something went wrong", actionTitle: "Ok") {
    //                print("doesn't match document")
    //
    //            }
    //        }
     
        
        }
        
        
 
    }
    
    func handleDataForNavigation(_ results: DocumentReaderResults)  {
        
        if (UserLocalStore.shared.Vibration == true) {
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
            if (UserLocalStore.shared.SoundEnabled == true) {
                let soundFileName = UserLocalStore.shared.SelectedSound
                       
                       // Load the sound file
                       if let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: "mp3") {
                           do {
                               audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                               audioPlayer?.play()
                           } catch {
                               print("Error loading sound file: \(error.localizedDescription)")
                           }
                       }
            }
            
//       let vc = self.storyboard?.instantiateViewController(withIdentifier: "TesteRFID") as? TesteRFID
//        vc?.results = results
//        self.navigationController?.pushViewController(vc!, animated: true)
        
        
        if( UserLocalStore.shared.clickedIndex == 0) {
            if(UserLocalStore.shared.Liveness == true || UserLocalStore.shared.FaceMatching == true) {
                guard let resultsViewController = self.storyboard?.instantiateViewController(withIdentifier: "StartProcessViewController") as? StartProcessViewController else {
                        return
                    }
                resultsViewController.results = results
                resultsViewController.modalPresentationStyle = .fullScreen
                self.present(resultsViewController, animated: true, completion: nil)
            }
            else {
                guard let resultsViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserInfoVC") as? UserInfoVC else {
                        return
                    }
                resultsViewController.results = results
                resultsViewController.getUserSessionId = ""
                resultsViewController.faceLiveness = false
                resultsViewController.modalPresentationStyle = .fullScreen
                self.present(resultsViewController, animated: true, completion: nil)
            }
            
         
        }
        else {
            

            guard let resultsViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserInfoVC") as? UserInfoVC else {
                    return
                }
            resultsViewController.results = results
            resultsViewController.getUserSessionId = ""
            resultsViewController.faceLiveness = false
            resultsViewController.modalPresentationStyle = .fullScreen
            self.present(resultsViewController, animated: true, completion: nil)
        }
        
       
    }
    
    
    private func showSettingsScreen() {
//        let mainStoryboard = UIStoryboard(name: kMainStoryboardId, bundle: nil)

    }
    
    private func showHelpPopup() {
        let actionSheet = UIAlertController(title: nil, message: "Information",
                                            preferredStyle: .actionSheet)
        
        let actionDocs = UIAlertAction(title: "Documents", style: .default) { _ in
            self.openSafariWith("https://docs.regulaforensics.com/home/faq/machine-readable-travel-documents")
        }
        actionSheet.addAction(actionDocs)
        let actionCore = UIAlertAction(title: "Core", style: .default) { _ in
            self.openSafariWith("https://docs.regulaforensics.com/develop/doc-reader-sdk/mobile/ios/optimization/core")
        }
        actionSheet.addAction(actionCore)
        let actionScenarios = UIAlertAction(title: "Scenarios", style: .default) { _ in
            self.openSafariWith("https://docs.regulaforensics.com/develop/doc-reader-sdk/mobile/ios/document-processing/scenario")
        }
        actionSheet.addAction(actionScenarios)
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
//        actionSheet.popoverPresentationController?.barButtonItem = self.helpBarButton
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func openSafariWith(_ link: String) {
        guard let url = URL(string: link) else { return }
        let controller = SFSafariViewController(url: url)
        self.present(controller, animated: true, completion: nil)
    }
    
    private func showCameraViewController() {
       
        
        let config = DocReader.ScannerConfig(scenario: "")
        
       // let config = DocReader.ScannerConfig()
        
        
        
        config.scenario = selectedScenario
        
        DocReader.shared.showScanner(presenter: self, config:config) { [weak self] (action, result, error) in
            guard let self = self else { return }
            
            switch action {
            case .cancel:
                self.stopCustomUIChanges()
                print("Cancelled by user")
            case .complete, .processTimeout:
                self.stopCustomUIChanges()
                guard let opticalResults = result else {
                    return
                }
                if opticalResults.chipPage != 0 && ApplicationSetting.shared.isRfidEnabled {
                    self.startRFIDReading(opticalResults)
                } else {
                    self.showResultScreen(opticalResults)
                }
            case .error:
                self.stopCustomUIChanges()
                print("Error")
                guard let error = error else { return }
                print("Error string: \(error)")
            case .process:
                guard let result = result else { return }
                print("Scaning not finished. Result: \(result)")
                print(result.rawResult)
            case .morePagesAvailable:
                print("This status couldn't be here, it uses for -recognizeImage function")
            default:
                break
            }
        }
    }

    
    private func showCameraViewControllerForMrz() {
      //  let config = DocReader.ScannerConfig()
        let config = DocReader.ScannerConfig(scenario: "")
        config.scenario = selectedScenario
        
        DocReader.shared.showScanner(presenter: self, config:config) { [weak self] (action, result, error) in
            guard let self = self else { return }
            
            switch action {
            case .cancel:
                self.stopCustomUIChanges()
                print("Cancelled by user")
            case .complete, .processTimeout:
                self.stopCustomUIChanges()
                guard let opticalResults = result else {
                    return
                }
                if opticalResults.chipPage != 0 && UserLocalStore.shared.RFIDChipProcessing == true {
                    self.startRFIDReading(opticalResults)
                } else {
                    self.showResultScreen(opticalResults)
                }
            case .error:
                self.stopCustomUIChanges()
                print("Error")
                guard let error = error else { return }
                print("Error string: \(error)")
            case .process:
                guard let result = result else { return }
                print("Scaning not finished. Result: \(result)")
                print(result.rawResult)
            case .morePagesAvailable:
                print("This status couldn't be here, it uses for -recognizeImage function")
            default:
                break
            }
        }
    }
  
    // MARK: - Encrypted processing
    private func processEncryptedResults(_ encrypted: DocumentReaderResults, completion: ((DocumentReaderResults?) -> (Void))?) {
        let json = encrypted.rawResult
        
        let data = Data(json.utf8)

        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                guard let containers = json["ContainerList"] as? [String: Any] else {
                    completion?(nil)
                    return
                }
                guard let list = containers["List"] as? [[String: Any]] else {
                    completion?(nil)
                    return
                }
                
                let processParam:[String: Any] = [
                    "scenario": RGL_SCENARIO_FULL_PROCESS,
                    "alreadyCropped": true
                ]
                let params:[String: Any] = [
                    "List": list,
                    "processParam": processParam
                ]
                
                guard let jsonData = try? JSONSerialization.data(withJSONObject: params, options: []) else {
                    completion?(nil)
                    return
                }
                sendDecryptionRequest(jsonData) { result in
                    completion?(result)
                }
            }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
    }
    
    private func sendDecryptionRequest(_ jsonData: Data, _ completion: ((DocumentReaderResults?) -> (Void))? ) {
        guard let url = URL(string: "https://api.regulaforensics.com/api/process") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            guard let jsonData = data else {
                completion?(nil)
                return
            }
            
            let decryptedResult = String(data: jsonData, encoding: .utf8)
                .flatMap { DocumentReaderResults.initWithRawString($0) }
            completion?(decryptedResult)
        })

        task.resume()
    }
    
    // MARK: - RFID additions
    
    private func getRfidCertificates(bundleName: String) -> [PKDCertificate] {
        var certificates: [PKDCertificate] = []
        let masterListURL = Bundle.main.bundleURL.appendingPathComponent(bundleName)
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: masterListURL, includingPropertiesForKeys: [URLResourceKey.nameKey, URLResourceKey.isDirectoryKey], options: .skipsHiddenFiles)
            
            for content in contents {
                if let cert = try? Data(contentsOf: content)  {
                    certificates.append(PKDCertificate.init(binaryData: cert, resourceType: PKDCertificate.findResourceType(typeName: content.pathExtension), privateKey: nil))
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return certificates
    }
    
    func getRfidTACertificates() -> [PKDCertificate] {
        var paCertificates: [PKDCertificate] = []
        let masterListURL = Bundle.main.bundleURL.appendingPathComponent("CertificatesTA.bundle")
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: masterListURL, includingPropertiesForKeys: [URLResourceKey.nameKey, URLResourceKey.isDirectoryKey], options: .skipsHiddenFiles)
            
            var filesCertMap: [String: [URL]] = [:]
            
            for content in contents {
                let fileName = content.deletingPathExtension().lastPathComponent
                if filesCertMap[fileName] == nil {
                    filesCertMap[fileName] = []
                }
                filesCertMap[fileName]?.append(content.absoluteURL)
            }
            
            for (_, certificates) in filesCertMap {
                var binaryData: Data?
                var privateKey: Data?
                for cert in certificates {
                    if let data = try? Data(contentsOf: cert) {
                        if cert.pathExtension.elementsEqual("cvCert") {
                            binaryData = data
                        } else {
                            privateKey = data
                        }
                    }
                }
                if let data = binaryData {
                    paCertificates.append(PKDCertificate.init(binaryData: data, resourceType: .certificate_TA, privateKey: privateKey))
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return paCertificates
    }
    
    private func setupCustomUIFromFile() {
        if let path = Bundle.main.path(forResource: "layer", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
                DocReader.shared.customization.actionDelegate = self
                DocReader.shared.customization.customUILayerJSON = jsonDict
            } catch {
                
            }
        }
    }
    
    private func setupCustomUIButtonsFromFile() {
        if let path = Bundle.main.path(forResource: "buttons", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
                
                DocReader.shared.functionality.showTorchButton = false
                DocReader.shared.functionality.showCloseButton = false
                
                DocReader.shared.customization.actionDelegate = self
                DocReader.shared.customization.customUILayerJSON = jsonDict
            } catch {
                
            }
        }
    }
        
    @objc func fireTimer() {
     
        guard isCustomUILayerEnabled else {
            return
        }
        
        guard let jsonData = customLayerJsonString.data(using: .utf8) else {
            return
        }
        
        guard var model = try? JSONDecoder().decode(CustomUILayerModel.self, from: jsonData) else {
            return
        }
        
        guard var object = model.objects.first else {
            return
        }
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        object.label.text = "Custom label that showing current time: \(dateFormatter.string(from: date))"
        
        let ct = CACurrentMediaTime()
        object.label.position.v = 1.0 + sin(ct) * 0.5 // Move vertically from 0.5 to 1.5
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        model.objects = [object]

        do {
            let data = try encoder.encode(model)
            if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                DocReader.shared.customization.customUILayerJSON = jsonDict
            }
        } catch {
            
        }
    }
    
    private func stopCustomUIChanges() {
        isCustomUILayerEnabled = false
        DocReader.shared.customization.customUILayerJSON = nil
    }
}



// MARK: - DocReader.CustomizationActionDelegate
extension ViewController: DocReader.CustomizationActionDelegate {
    func onCustomButtonTapped(withTag tag: Int) {
        print("Button with \(tag) tag pressed")
    }
}



// MARK: - RGLDocReaderRFIDDelegate

extension ViewController: RGLDocReaderRFIDDelegate {
    func onRequestPACertificates(withSerial serialNumber: Data!, issuer: PAResourcesIssuer!, callback: (([PKDCertificate]?) -> Void)!) {
        let certificates = self.getRfidCertificates(bundleName: "Certificates.bundle")
        callback(certificates)
    }
    
    func onRequestTACertificates(withKey keyCAR: String!, callback: (([PKDCertificate]?) -> Void)!) {
        let certificates = self.getRfidTACertificates()
        callback(certificates)
    }
    
    func onRequestTASignature(with challenge: TAChallenge!, callback: ((Data?) -> Void)!) {
        callback(nil)
    }
}

extension PKDCertificate {
    static func findResourceType(typeName: String) -> PKDResourceType {
        switch typeName.lowercased() {
        case "pa":
            return PKDResourceType.certificate_PA
        case "ta":
            return PKDResourceType.certificate_TA
        case "ldif":
            return PKDResourceType.LDIF
        case "crl":
            return PKDResourceType.CRL
        case "ml":
            return PKDResourceType.ML
        case "defl":
            return PKDResourceType.defL
        case "devl":
            return PKDResourceType.devL
        case "bl":
            return PKDResourceType.BL
        default:
            return PKDResourceType.certificate_PA
        }
    }
}

    
extension String {
  func localizeString(string: String) -> String {
    
      let path = Bundle.main.path(forResource: string, ofType: "lproj")
      let bundle = Bundle(path: path!)
      return NSLocalizedString(self, tableName: nil, bundle: bundle!,
      value: "", comment: "")
  }

}






//
//  ViewController.swift
//  ipass_plus
//
//  Created by MOBILE on 30/01/24.
//

//import UIKit
//import DocumentReader
//import SafariServices
//import Amplify
//import FaceLiveness
//import SwiftUI
//import AWSPluginsCore
//import AVFoundation
//import Toast_Swift
//
//
////  ACtual code -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//
//
//class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
//
//    //MARK: IBoutlets
//    @IBOutlet weak var bottomView: UIView!
//    @IBOutlet weak var optionsTV: UITableView!
//    @IBOutlet weak var statusLabel: UILabel!
//    @IBOutlet weak var popUpView: UIView!
//    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
//    @IBOutlet weak var actionSettingBtn: UIButton!
//    @IBOutlet weak var actionCameraBtn: UIButton!
//    @IBOutlet weak var actionOpenGalleryBtn: UIButton!
//    
//    
//    
//    func testDismiss() {
//        print("DISMISSED")
//    }
//    
//    
//    //MARK: Propertes
//    let numberFormatter = NumberFormatter()
//    let imagePicker = UIImagePickerController()
//    private var selectedScenario: String?
//    var isCustomUILayerEnabled: Bool = false
//    private var sectionsData: [CustomizationSection] = []
//
//    lazy var animationTimer = Timer.scheduledTimer(timeInterval: 1.0/60, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
//    
//    
//    let customLayerJsonString =
//    """
//    {
//    "objects": [
//    {
//    "label": {
//      "text": "Searching document...",
//      "fontStyle": "normal",
//      "fontColor": "#FF444444",
//      "fontSize": 24,
//      "alignment": "center",
//      "background": "#BBDDDDDD",
//      "borderRadius": 10,
//      "padding": {
//        "start": 20,
//        "end": 20,
//        "top": 20,
//        "bottom": 20
//      },
//      "position": {
//        "v": 1.0
//      },
//      "margin": {
//        "start": 24,
//        "end": 24
//      }
//    }
//    }]
//    }
//    """
//    
//    //MARK: View Life Cycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//       
//        bottomView.isUserInteractionEnabled = false
//        imagePicker.delegate = self
//        imagePicker.allowsEditing = false
//        loadInitData()
//        optionsTV.isHidden = true
//        
//        testCode()
//        DocumentReaderService.shared.initializeDatabaseAndAPI(progress: { [weak self] state in
//            guard let self = self else { return }
//            switch state {
//            case .downloadingDatabase(progress: let progress):
//                DispatchQueue.main.async {
//                    let progressValue = String(format: "%.1f", progress * 3)
//                    self.statusLabel.text = "Downloading database: \(progressValue)%"
//                }
//            case .initializingAPI:
//                self.statusLabel.text = "Initializing..."
//                self.activityIndicator.stopAnimating()
//            case .completed:
//                DispatchQueue.main.async {
//                    self.enableUserInterfaceOnSuccess()
//                    self.initSections()
//                }
//                //                self.optionsTV.reloadData()
//            case .error(let text):
//                DispatchQueue.main.async {
//                    self.statusLabel.text = text
//                    self.enableUserInterfaceOnSuccess()
//                    self.initSectionsWithoutLicence()
//                    //
//                }
//                //                    self.optionsTV.reloadData()
//                print(text)
//            }
//        })
//        
//        // startCamera(value: "")
//        //startCamera(value: "")
//        //        Task {
//        ////
//        ////          //  await dddasas()
//        ////
//        ////            //await fetchCurrentAuthSession()
//        ////        //await signIn()
//        ////          //  await signUp(username:"testuser", password:"Apple@123", email: "appsdev096@gmail.com")
//        ////
//        ////           // await confirmSignUp(for:"testuser", with: "088811")
//        ////
//        //  await fetchCurrentAuthSession()
//        //        }
//        
////        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
//       // setAppSettings()
//        
//        actionSettingBtn.addTarget(self, action: #selector(didTapSettingBtn(_:)), for: .touchUpInside)
//        
//        actionCameraBtn.addTarget(self, action: #selector(didTapCameraBtn(_:)), for: .touchUpInside)
//        
//        actionOpenGalleryBtn.addTarget(self, action: #selector(didTapGalleryBtn(_:)), for: .touchUpInside)
//        
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        
//        
//        setAppSettings()
//    }
//    //MARK: Button Navigations
//
//    @objc func didTapSettingBtn(_ sender: UIButton){
//        let  vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)
////        self.navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    @objc func didTapCameraBtn(_ sender: UIButton){
////        if UIImagePickerController.isSourceTypeAvailable(.camera) {
////                  imagePicker.sourceType = .camera
////                  present(imagePicker, animated: true, completion: nil)
////              } else {
////                 print("Please add Camera ")
////              }
//        
//        
//        UserLocalStore.shared.clickedIndex = 0
//        
//           
//            let config = DocReader.ScannerConfig()
//            config.scenario = RGL_SCENARIO_FULL_PROCESS
//            
//           
//
//
//            DocReader.shared.showScanner(presenter: self, config: config) { [self] (action, result, error) in
//                if action == .complete || action == .processTimeout {
//                    print(result?.rawResult as Any)
//                    
//                    if result?.chipPage != 0 && UserLocalStore.shared.RFIDChipProcessing == true {
//                        self.startRFIDReading(result)
//                    } else {
//                        if ApplicationSetting.shared.isDataEncryptionEnabled {
//                            statusLabel.text = "Decrypting data..."
//                            activityIndicator.startAnimating()
//                            popUpView.isHidden = false
//                            processEncryptedResults(result!) { decryptedResult in
//                                DispatchQueue.main.async {
//                                    self.popUpView.isHidden = true
//                                    
//                                    guard let results = decryptedResult else {
//                                        print("Can't decrypt result")
//                                        return
//                                    }
//                                    
//                                   
//                                    
//                                    self.presentResults(results)
//                                }
//                            }
//                        } else {
//                            presentResults(result!)
//                        }
//                    }
//                    
//                  
//                                   
//                 
//                    
//                }
//            }
//            
//        
//    }
//
//    @objc func didTapGalleryBtn(_ sender: UIButton){
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//                   imagePicker.sourceType = .photoLibrary
//                   present(imagePicker, animated: true, completion: nil)
//               } else {
//                   print("Can't open gallery")
//               }
//        
//  
//    }
//    
//    func captureModeToString(captureMode: String) -> CaptureMode {
//        switch captureMode {
//        case "Auto":
//            return .auto
//        case "Video processing":
//            return .captureVideo
//        case "Frame processing":
//            return .captureFrame
//        default:
//            return .auto
//        }
//    }
//
//    // For String data
//    func zoomFactorToString(zoomFactor: CGFloat) -> String {
//        let newData = String(Double(zoomFactor))
//        return newData
//    }
//    // For
//    func captureSessionPresetToString(preset: AVCaptureSession.Preset) -> String {
//        return preset.rawValue
//    }
//    // For Authentication Procedure
//    func authProcTypeToString(authProcType: String) -> RFIDAuthenticationProcedureType {
//        switch authProcType {
//            case "Undefined":
//            return .undefined
//            case "Standard inspection procedure":
//            return .standard
//            case "Advanced inspection procedure":
//            return .advanced
//            case "General inspection procedure":
//            return .general
//        default:
//            return .undefined
//        }
//    }
//
//    // For Basic Security messaging procedure
//    func accessControlProcTypeToString(procType: String) -> RFIDAccessControlProcedureType {
//        switch procType {
//            case "Undefined":
//            return .undefined
//            case "BAC":
//            return .bac
//            case "PACE":
//            return .pace
//            case "CA":
//            return .ca
//            case "TA":
//            return .ta
//            case "AA":
//            return .aa
//            case "RI":
//            return .ri
//            case "CardInfo":
//            return .ca
//        default:
//            return .undefined
//        }
//    }
//
//    func preset(from string: String) -> AVCaptureSession.Preset? {
//           switch string {
//           case "Photo": return .photo
//           case "High": return .high
//           case "Medium": return .medium
//           case "Low": return .low
//           case "352×288": return .cif352x288
//           case "640×480": return .vga640x480
//           case "1280×720": return .hd1280x720
//           case "1920×1080": return .hd1920x1080
//           case "3840×2160": return .hd4K3840x2160
//           case "iFrame960×540": return .iFrame960x540
//           case "iFrame1280x720": return .iFrame1280x720
//           case "inputPriority": return .inputPriority
//           default: return nil
//           }
//       }
//    
//    func setAppSettings() {
//        
//        // HANLDE LOCALLAY
//        
//        
//        // FACE MATCHING
//        // LIVENESS
//        
//      
//        
//        DocReader.shared.customization.cameraFrameDefaultColor  = UIColor(red: 126/255, green: 87/255, blue: 196/255, alpha: 1)
////           DocReader.shared.customization.cameraPreviewBackgroundColor = .purple
////           DocReader.shared.customization.tintColor = .yellow
//        DocReader.shared.customization.tintColor  = UIColor(red: 126/255, green: 87/255, blue: 196/255, alpha: 1)
//        
//        
//        DocReader.shared.functionality.showSkipNextPageButton = false
//
//        // Double Page Spread Proccessing
//        DocReader.shared.processParams.doublePageSpread = UserLocalStore.shared.DoublePageSpreadProcessing == true ? 1 : 0
//        
//        // SAVE EVENT LOGS
//        DocReader.shared.processParams.debugSaveLogs = UserLocalStore.shared.SaveEventLogs == true ? 1 : 0
//        
//        // SAVE IMAGE
//        DocReader.shared.processParams.debugSaveImages = UserLocalStore.shared.SaveImages == true ? 1 : 0
//        
//        // SAVE CROPPED IMAGE
//        DocReader.shared.processParams.debugSaveCroppedImages = UserLocalStore.shared.SaveCroppedImages == true ? 1 : 0
//        
//        // SAVE RFID SESSION
//        DocReader.shared.processParams.debugSaveRFIDSession = UserLocalStore.shared.SaveRFIDSession == true ? 1 : 0
//        
//        // REPORT EVENT LOGS
//        let path = DocReader.shared.processParams.sessionLogFolder
//        print("Path: \(path ?? "nil")") // COPY CONTENT FOR THIS PATH AND SHOW
//        
//        // SHOW METADATA
//        DocReader.shared.functionality.showMetadataInfo = UserLocalStore.shared.ShowMetadata
//        
//        
//        // CAPTURE BUTTON
//        DocReader.shared.functionality.showCaptureButton = UserLocalStore.shared.CaptureButton
//        
//        // CAMERA SWITCH BUTTON
//        DocReader.shared.functionality.showCameraSwitchButton = UserLocalStore.shared.CameraSwitchButton
//
//        
//        //HELP
//        DocReader.shared.customization.showHelpAnimation = UserLocalStore.shared.Help
//        
//        
//        // TIMEOUT
//        if let timeout = numberFormatter.number(from: UserLocalStore.shared.TimeOut) {
//            DocReader.shared.processParams.timeout = timeout
//        }
//
//        // TIMEOUT STARTING FROM DOCUMENT DETECTION
//        if let timeoutString = numberFormatter.number(from: UserLocalStore.shared.TimeOutDocumentDetection) {
//            DocReader.shared.processParams.timeoutFromFirstDetect = timeoutString
//        }
//        
//        
//        // TIME OUT STARTING FROM DOCUMENT TYPE IDENTIFICATION
//        if let documentId = numberFormatter.number(from: UserLocalStore.shared.TimeOutDocumentIdentification) {
//            DocReader.shared.processParams.timeoutFromFirstDocType = documentId
//        }
//        
//        // MOTION DETECTION
//        DocReader.shared.functionality.videoCaptureMotionControl = UserLocalStore.shared.MotionDetection
//        
//        // FOCUSING DETECTION
//        DocReader.shared.functionality.skipFocusingFrames = UserLocalStore.shared.FocusingDetection
//
//        
//        // PROCESSING MOEDS
//
//        let captureModeString = captureModeToString(captureMode: UserLocalStore.shared.ProcessingModes)
//        DocReader.shared.functionality.captureMode = captureModeString
//        
//        // CAMERA RESOLUTION
//
//         let presetdata = preset(from:  UserLocalStore.shared.CameraResolution)
//            DocReader.shared.functionality.videoSessionPreset = presetdata
//
//
//        // ADJUST ZZOOM LEVEL
//        DocReader.shared.functionality.isZoomEnabled  = UserLocalStore.shared.AdiustZoomLevel
//        
//        // ZOOM LEVEL
//        if let zoomFactor = numberFormatter.number(from: UserLocalStore.shared.ZoomLevel) {
//            DocReader.shared.functionality.zoomFactor = CGFloat(truncating: zoomFactor)
//        }
//        
//        // MANUAL CROP
//        DocReader.shared.processParams.manualCrop = UserLocalStore.shared.ManualCrop == true ? 1 : 0
//        
//        // MINIMUM DPI
//        if let DPI = numberFormatter.number(from: UserLocalStore.shared.MinimumDPI) {
//            DocReader.shared.processParams.minDPI = DPI
//        }
//        // PERPECTIVE ANGLE
//        if let Angle = numberFormatter.number(from: UserLocalStore.shared.PerspectiveAngle) {
//            DocReader.shared.processParams.perspectiveAngle = Angle
//        }
//        // INTEGRAL IMAGE
//        DocReader.shared.processParams.integralImage = UserLocalStore.shared.IntegralImage == true ? 1 : 0
//
//        // HOLOGRAM DETECTION
//        DocReader.shared.processParams.checkHologram  = UserLocalStore.shared.HologramDetection == true ? 1 : 0
//        
//        // GLARE
//        DocReader.shared.processParams.imageQA.glaresCheck = UserLocalStore.shared.ImgGlares == true ? 1 : 0
//        
//        // FOCUS
//        DocReader.shared.processParams.imageQA.focusCheck = UserLocalStore.shared.ImgFocus == true ? 1 : 0
//        
//        // COLor
//        DocReader.shared.processParams.imageQA.colornessCheck = UserLocalStore.shared.ImgColor == true ? 1 : 0
//        
//        // DPI
//
//        if let threshold = numberFormatter.number(from: UserLocalStore.shared.DPIThreshold) {
//        DocReader.shared.processParams.imageQA.dpiThreshold = threshold
//        }
//        
//        // ANGLE   UserLocalStore.shared.AngleThreshold
//        if let anglethreshold = numberFormatter.number(from: UserLocalStore.shared.AngleThreshold) {
//        DocReader.shared.processParams.imageQA.angleThreshold = anglethreshold
//        }
//        
//        // DOCUMENT
//        if let document = numberFormatter.number(from: UserLocalStore.shared.DocumentPositionIndent) {
//            DocReader.shared.processParams.imageQA.documentPositionIndent = document
//        }
//        
//        // DATE FORMAT
//        DocReader.shared.processParams.dateFormat = UserLocalStore.shared.DateFormat
//
//        // DOCUMENT FILTER
////        DocReader.shared.processParams.documentIDList = [-274257313, -2004898043]
//        if UserLocalStore.shared.DocumentFilter != "" {
//            var dataAt = [NSNumber]()
//            var fullName: String = UserLocalStore.shared.DocumentFilter
//            let fullNameArr = fullName.components(separatedBy: ",")
//            for i in 0..<fullNameArr.count {
//                dataAt.append(Int(fullNameArr[i])! as NSNumber);
//            }
//            
//            DocReader.shared.processParams.documentIDList = dataAt
//        }
//        
//        // AUTH PROCEDURE TYPE
////        let authProcTypeString = authProcTypeToString(authProcType: UserLocalStore.shared.AuthenticationProcedureType)
////        DocReader.shared.rfidScenario.authProcType = authProcTypeString
////
////        // AUTH PROCEDURE TYPE
////        let procTypeString = accessControlProcTypeToString(procType: UserLocalStore.shared.BasicSecurityMessagingProcedure)
////        DocReader.shared.rfidScenario.baseSMProcedure = procTypeString
////
////        // PRIORITY OF DS CER
////        DocReader.shared.rfidScenario.pkdDSCertPriority = UserLocalStore.shared.PriorityUsingDSCertificates
////
////        // CSCA CERTIFICATE
////        DocReader.shared.rfidScenario.pkdUseExternalCSCA = UserLocalStore.shared.UseExternalCSCACertificates
////
////        // PKD CERTIFICATE
////        DocReader.shared.rfidScenario.trustedPKD = UserLocalStore.shared.TrustPKDCertificates
////
////        // PASSIVE AUTH
////        DocReader.shared.rfidScenario.passiveAuth = UserLocalStore.shared.PassiveAuthentication
////
////        // AA AFTER CA
////        DocReader.shared.rfidScenario.skipAA = UserLocalStore.shared.PerformAAAfterCA
////
////        // PROFILE TYE
////        if( UserLocalStore.shared.ProfilerType != "") {
////            if(UserLocalStore.shared.ProfilerType == "LSD and PKI Maintenance, v2.0, May21, 2014") {
////                DocReader.shared.rfidScenario.profilerType = RGLRFIDSdkProfilerTypeDoc9303LdsPkiMaintenance
////            }
////            else {
////                DocReader.shared.rfidScenario.profilerType = RGLRFIDSdkProfilerTypeDoc9303Edition2006
////            }
////        }
////
////
////        // STRICT PROTOCOL
////        DocReader.shared.rfidScenario.strictProcessing =  UserLocalStore.shared.StrictISOProtocol
////
////
////
////        // READ PASSPORt
////        DocReader.shared.rfidScenario.readEPassport = UserLocalStore.shared.ReadEPassport
////
////
////
////        // MEACHINE READBLE ZONE DG1
////        DocReader.shared.rfidScenario.ePassportDataGroups.dG1 = UserLocalStore.shared.MachineReadableZone
////
////        // Biometry facial data DG2
////        DocReader.shared.rfidScenario.ePassportDataGroups.dG2 = UserLocalStore.shared.Biometry_FacialData
////
////        // Biometry fingerPrints DG3
////        DocReader.shared.rfidScenario.ePassportDataGroups.dG3 = UserLocalStore.shared.Biometry_Fingerprints
////
////        // Biometry Iris data DG4
////        DocReader.shared.rfidScenario.ePassportDataGroups.dG4 = UserLocalStore.shared.Biometry_IrisData
////
////        // Potraits DG5
////        DocReader.shared.rfidScenario.ePassportDataGroups.dG5 = UserLocalStore.shared.Portrait
////
////        // not define DG6
////        DocReader.shared.rfidScenario.ePassportDataGroups.dG6 = UserLocalStore.shared.NotDefinedDG6
////
////        // Singnuture Usual mark DG7
////        DocReader.shared.rfidScenario.ePassportDataGroups.dG7 = UserLocalStore.shared.SignatureUsualMarkImage
////
////        // not define DG6
////        DocReader.shared.rfidScenario.ePassportDataGroups.dG8 = UserLocalStore.shared.NotDefinedDG8
////
////        // not define DG6
////        DocReader.shared.rfidScenario.ePassportDataGroups.dG9 = UserLocalStore.shared.NotDefinedDG9
////
////        // not define DG6
////        DocReader.shared.rfidScenario.ePassportDataGroups.dG10 = UserLocalStore.shared.NotDefinedDG10
////
////        // Additional personal details DG11
////        DocReader.shared.rfidScenario.ePassportDataGroups.dG11 = UserLocalStore.shared.AdditionalPersonalDetail
////
////        // Additional document details DG12
////        DocReader.shared.rfidScenario.ePassportDataGroups.dG12 = UserLocalStore.shared.AdditionalDocumentDetail
////
////        // OPtional details DG13
////        DocReader.shared.rfidScenario.ePassportDataGroups.dG13 = UserLocalStore.shared.OptionalDetail
////
////        // Eac Info DG14
////        DocReader.shared.rfidScenario.ePassportDataGroups.dG14 = UserLocalStore.shared.EACInfo
////
////        // Authentication info DG15
////        DocReader.shared.rfidScenario.ePassportDataGroups.dG15 = UserLocalStore.shared.ActiveAuthenticationInfo
////
////        // Person Notify DG16
////        DocReader.shared.rfidScenario.ePassportDataGroups.dG16 = UserLocalStore.shared.PersonToNotify
////
////        // Read E-ID
////        DocReader.shared.rfidScenario.readEID = UserLocalStore.shared.ReadElD
////
////        // document type DG1
////        DocReader.shared.rfidScenario.eIDDataGroups.dG1 = UserLocalStore.shared.DocumentType
////
////        // Issuing State
////        DocReader.shared.rfidScenario.eIDDataGroups.dG2 = UserLocalStore.shared.IssuingState
////
////        // Date of expiry
////        DocReader.shared.rfidScenario.eIDDataGroups.dG3 = UserLocalStore.shared.DateOfExpiry
////
////        // Given Name
////        DocReader.shared.rfidScenario.eIDDataGroups.dG4 = UserLocalStore.shared.GivenName
////
////        // Family Name
////        DocReader.shared.rfidScenario.eIDDataGroups.dG5 = UserLocalStore.shared.FamilyName
////
////        // Pseudonym
////        DocReader.shared.rfidScenario.eIDDataGroups.dG6 = UserLocalStore.shared.Pseudonym
////
////        // Acadmic Title
////        DocReader.shared.rfidScenario.eIDDataGroups.dG7 = UserLocalStore.shared.AcademicTitle
////
////        // Date of birth
////        DocReader.shared.rfidScenario.eIDDataGroups.dG8 = UserLocalStore.shared.DateOfBirth
////
////        // Place of birth
////        DocReader.shared.rfidScenario.eIDDataGroups.dG9 = UserLocalStore.shared.PlaceOfBirth
////
////        // Nationality
////        DocReader.shared.rfidScenario.eIDDataGroups.dG10 = UserLocalStore.shared.Nationality
////
////        // Sex
////        DocReader.shared.rfidScenario.eIDDataGroups.dG11 = UserLocalStore.shared.Sex
////
////        // Optional detail
////        DocReader.shared.rfidScenario.eIDDataGroups.dG12 = UserLocalStore.shared.OptionalDetailsDG12
////
////        // Undefine DG13
////        DocReader.shared.rfidScenario.eIDDataGroups.dG13 = UserLocalStore.shared.UndefinedDG13
////
////        // Undefine DG14
////        DocReader.shared.rfidScenario.eIDDataGroups.dG14 = UserLocalStore.shared.UndefinedDG14
////
////        // Undefine DG15
////        DocReader.shared.rfidScenario.eIDDataGroups.dG15 = UserLocalStore.shared.UndefinedDG15
////
////        // Undefine DG16
////        DocReader.shared.rfidScenario.eIDDataGroups.dG16 = UserLocalStore.shared.UndefinedDG16
////
////        // Place of Registation
////        DocReader.shared.rfidScenario.eIDDataGroups.dG17 = UserLocalStore.shared.PlaceOfRegistrationDG17
////
////        // Place of Registation
////        DocReader.shared.rfidScenario.eIDDataGroups.dG18 = UserLocalStore.shared.PlaceOfRegistrationDG18
////
////        // Residence permit
////        DocReader.shared.rfidScenario.eIDDataGroups.dG19 = UserLocalStore.shared.ResidencePermit1DG19
////
////        // Residence permit
////        DocReader.shared.rfidScenario.eIDDataGroups.dG20 = UserLocalStore.shared.ResidencePermit2DG20
////
////        // Optional details DG21
////        DocReader.shared.rfidScenario.eIDDataGroups.dG21 = UserLocalStore.shared.OptionalDetailsDG21
////
////        // Read E-DL
////        DocReader.shared.rfidScenario.readEDL = UserLocalStore.shared.ReadEDL
////
////        // text data element
////        DocReader.shared.rfidScenario.eDLDataGroups.dG1 = UserLocalStore.shared.TextDataElementsDG1
////
////        // License holder information
////        DocReader.shared.rfidScenario.eDLDataGroups.dG2  = UserLocalStore.shared.LicenseHolderInformationDG2
////
////        // Issuing Authority details
////        DocReader.shared.rfidScenario.eDLDataGroups.dG3 = UserLocalStore.shared.IssuingAuthorityDetailsDG3
////
////        // potraits Image
////        DocReader.shared.rfidScenario.eDLDataGroups.dG4 = UserLocalStore.shared.PortraitImageDG4
////
////        // Signature Usual mark
////        DocReader.shared.rfidScenario.eDLDataGroups.dG5 = UserLocalStore.shared.SignatureUsualMarkImageDG5
////
////        // biometry facial data
////        DocReader.shared.rfidScenario.eDLDataGroups.dG6 = UserLocalStore.shared.Biometry_FacialDataDG6
////
////        // biometry fingerprints
////        DocReader.shared.rfidScenario.eDLDataGroups.dG7 = UserLocalStore.shared.Biometry_FingerprintDG7
////
////        // biometry Iris data
////        DocReader.shared.rfidScenario.eDLDataGroups.dG8 = UserLocalStore.shared.Biometry_IrisDataDG8
////
////        // biometry Other
////        DocReader.shared.rfidScenario.eDLDataGroups.dG9 = UserLocalStore.shared.Biometry_OtherDG9
////
////        // not define
////        DocReader.shared.rfidScenario.eDLDataGroups.dG10 = UserLocalStore.shared.EDL_NotDefinedDG10
////
////        // Optional domestic data
////        DocReader.shared.rfidScenario.eDLDataGroups.dG11 = UserLocalStore.shared.OptionalDomesticDataDG11
////
////        // Non match alert
////        DocReader.shared.rfidScenario.eDLDataGroups.dG12 = UserLocalStore.shared.Non_MatchAlertDG12
////
////        // Actice authentication info
////        DocReader.shared.rfidScenario.eDLDataGroups.dG13 = UserLocalStore.shared.ActiveAuthenticationInfoDG13
////
////        // Eac Info
////        DocReader.shared.rfidScenario.eDLDataGroups.dG14 = UserLocalStore.shared.EACInfoDG14
//    }
//    
//    
//    //           DocReader.shared.processParams.doublePageSpread = true
//    //           DocReader.shared.customization.cameraFrameActiveColor = .purple
//    //           DocReader.shared.functionality.isZoomEnabled = true
//    //
//    //           DocReader.shared.functionality.zoomFactor = 10
//    //           DocReader.shared.functionality.showCameraSwitchButton = true
//    //           DocReader.shared.functionality.showCaptureButton = true
//    //           DocReader.shared.functionality.showMetadataInfo = true
//    //           DocReader.shared.processParams
//               
//               
//               
//               
//    //           DocReader.shared.processParams.doublePageSpread = true
//    //           DocReader.shared.processParams.timeout = 10
//    ////           DocReader.shared.inputView?.motionEffects = true
//    //           DocReader.shared.processParams.manualCrop = true
//    //           DocReader.shared.processParams.integralImage
//    
//    func confirmSignUp(for username: String, with confirmationCode: String) async {
//        do {
//            let confirmSignUpResult = try await Amplify.Auth.confirmSignUp(
//                for: username,
//                confirmationCode: confirmationCode
//            )
//            print("Confirm sign up result completed: \(confirmSignUpResult.isSignUpComplete)")
//        } catch let error as AuthError {
//            print("An error occurred while confirming sign up \(error)")
//        } catch {
//            print("Unexpected error: \(error)")
//        }
//    }
//    
//    
//    func signUp(username: String, password: String, email: String) async {
//        let userAttributes = [AuthUserAttribute(.email, value: email)]
//        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
//        do {
//            let signUpResult = try await Amplify.Auth.signUp(
//                username: username,
//                password: password,
//                options: options
//            )
//            if case let .confirmUser(deliveryDetails, _, userId) = signUpResult.nextStep {
//                print("Delivery details \(String(describing: deliveryDetails)) for userId: \(String(describing: userId))")
//            } else {
//                print("SignUp Complete")
//            }
//        } catch let error as AuthError {
//            print("An error occurred while registering a user \(error)")
//        } catch {
//            print("Unexpected error: \(error)")
//        }
//    }
//    
//    
//    func signIn() async {
//        do {
//            let signInResult = try await Amplify.Auth.signIn(
//                username: "testuser",
//                password: "Apple@123"
//                )
//            if signInResult.isSignedIn {
//                print("Sign in succeeded")
//                await fetchCurrentAuthSession()
//            }
//        } catch let error as AuthError {
//            print("Sign in failed \(error)")
//        } catch {
//            print("Unexpected error: \(error)")
//        }
//    }
//    
//    
//    
////    func hhh() async {
////
////        do{
////            let auth = Amplify.Auth.getCurrentUser() {
////                // Assuming user is authenticated
////                auth.getTokens { (tokens, error) in
////                    if let error = error {
////                        print("Error getting tokens: \(error)")
////                        return
////                    }
////                    if let tokens = tokens {
////                        let accessToken = tokens.accessToken
////                        let idToken = tokens.idToken
////                        let sessionID = idToken?.tokenString // Session ID is typically within the ID token
////                        print("Session ID: \(sessionID ?? "N/A")")
////                    }
////                }
////
////            }
////
////        }
////    }
//    
//    
//    func startCamera(value: String) {
//        
////        var swiftUIView = MyView()
////
////
////        swiftUIView.sessoinIdValue = value
////
////               let hostingController = UIHostingController(rootView: swiftUIView)
//
//    
//       // navigationController?.pushViewController(hostingController, animated: true)
//        
////        FaceLivenessDetectorView(
////              sessionID: value,
////              region: "us-east-1",
////              isPresented:  Binding<true>,
////              onCompletion: { result in
////                switch result {
////                case .success: break
////                  // ...
////                case .failure(let error): break
////                  // ...
////                default: break
////                  // ...
////                }
////              }
////            )
//        
//    }
//    
//    func dddasas () async{
//        
//
//        do {
//            let session = try await Amplify.Auth.fetchAuthSession()
//
//            // Get user sub or identity id
//            if let identityProvider = session as? AuthCognitoIdentityProvider {
//                
//                let usersub = try identityProvider.getUserSub().get()
//                let identityId = try identityProvider.getIdentityId().get()
//                print("User sub - \(usersub) and identity id \(identityId)")
//                startCamera(value: usersub)
//            }
//
//
//            
//            
//            // Get AWS credentials
//            if let awsCredentialsProvider = session as? AuthAWSCredentialsProvider {
//                let credentials = try awsCredentialsProvider.getAWSCredentials().get()
//                // Do something with the credentials
//                print(credentials.accessKeyId)
//                print(credentials.secretAccessKey)
//                
//            }
//
//            // Get cognito user pool token
//            if let cognitoTokenProvider = session as? AuthCognitoTokensProvider {
//                let tokens = try cognitoTokenProvider.getCognitoTokens().get()
//                // Do something with the JWT tokens
//                print(tokens.idToken)
//            }
//        } catch let error as AuthError {
//            print("Fetch auth session failed with error - \(error)")
//        } catch {
//        }
//    }
//    
//    
//    func fetchCurrentAuthSession() async {
//        do {
//            
////            let sss = try await Amplify.Auth.getCurrentUser()
//            
//            
//            let session = try await Amplify.Auth.fetchAuthSession()
//            print("Is user signed in - \(session.isSignedIn)")
//            
//            print(session)
//            
//            if(session.isSignedIn == true) {
//                startCamera(value: "ee")
//            }
//            else {
//                await signIn()
//            }
//            
//            
//            
//            
//            
//           // await dddasas ()
//            
//           // startCamera(value: auttt.userId)
//            
//            
////            auttt.getTokens { (tokens, error) in
////                if let error = error {
////                    print("Error getting tokens: \(error)")
////                    return
////                }
////                if let tokens = tokens {
////                    let accessToken = tokens.accessToken
////                    let idToken = tokens.idToken
////                    let sessionID = idToken?.tokenString // Session ID is typically within the ID token
////                    print("Session ID: \(sessionID ?? "N/A")")
////                }
////            }
//            
//            
//            
//            
//        } catch let error as AuthError {
//            print("Fetch session failed with error \(error)")
//        } catch {
//            print("Unexpected error: \(error)")
//        }
//    }
//    
//    func testCode() {
//        for scenario in DocReader.shared.availableScenarios {
//            print(scenario)
//        }
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//    }
//    //MARK: Register Nib File
//    
//    func loadInitData(){
//        optionsTV.register(UITableViewCell.self, forCellReuseIdentifier: "HomeCell")
//        optionsTV.estimatedRowHeight = UITableView.automaticDimension
//    }
//    
//
//    
//    //MARK: Button Navigation
//    
////    @IBAction func actionGoToSetting(_ sender: Any) {
////        let  vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
////        self.navigationController?.pushViewController(vc, animated: true)
////    }
//    //MARK: Button Open Gallery
//    
////    @IBAction func actionOpenGallery(_ sender: Any) {
////        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
////                   imagePicker.sourceType = .photoLibrary
////                   present(imagePicker, animated: true, completion: nil)
////               } else {
////                   print("Can't open gallery")
////               }
////
////    }
//    //MARK: Image Picker Delegate Method
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let selectedImage = info[.originalImage] as? UIImage {
//            // Handle the selected image
//            
//            
//            UserLocalStore.shared.clickedIndex = 0
//            
//               
//
//            
//            let config = DocReader.RecognizeConfig(image: selectedImage)
//            config.scenario = RGL_SCENARIO_FULL_PROCESS
//            
//            DocReader.shared.recognize(config: config) { (action, result, error) in
//                if action == .complete || action == .processTimeout  {
//                        print(result?.rawResult as Any)
//                        
//                        if result?.chipPage != 0 && UserLocalStore.shared.RFIDChipProcessing == true {
//                            self.startRFIDReading(result)
//                        } else {
//                            if ApplicationSetting.shared.isDataEncryptionEnabled {
//                                self.statusLabel.text = "Decrypting data..."
//                                self.activityIndicator.startAnimating()
//                                self.popUpView.isHidden = false
//                                self.processEncryptedResults(result!) { decryptedResult in
//                                    DispatchQueue.main.async {
//                                        self.popUpView.isHidden = true
//                                        
//                                        guard let results = decryptedResult else {
//                                            print("Can't decrypt result")
//                                            return
//                                        }
//                                        
//                                       
//                                        
//                                        self.presentResults(results)
//                                    }
//                                }
//                            } else {
//                                self.presentResults(result!)
//                            }
//                        }
//                        
//                      
//                                       
//                     
//                        
//                    }
//                }
//                
//            
//            
//            
//        }
//        dismiss(animated: true, completion: nil)
//    }
//
//    // Delegate method to handle when the user cancels the image picker
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
//
//    
//    //MARK: Button Open Camera
//    
////    @IBAction func actionOpenCamera(_ sender: Any) {
////        if UIImagePickerController.isSourceTypeAvailable(.camera) {
////                  imagePicker.sourceType = .camera
////                  present(imagePicker, animated: true, completion: nil)
////              } else {
////                 print("Please add Camera ")
////              }
////
////    }
//    
//    
//    
//    
//    //MARK: UITableView Delegate and Datasource Method
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//           return HomeDataManager.shared.getHomeData.count
//       }
//       
//       // create a cell for each table view row
//       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//           
//           var cell: HomeCell! = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as? HomeCell
//                  if cell == nil {
//                      tableView.register(UINib(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
//                      cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as? HomeCell
//                  }
//           cell.title.text = HomeDataManager.shared.getHomeData[indexPath.row]["title"]
//           cell.desc.text = HomeDataManager.shared.getHomeData[indexPath.row]["desc"]
//           cell.img.image = UIImage(named: HomeDataManager.shared.getHomeData[indexPath.row]["image"]!)
//           let clearView = UIView()
//           clearView.backgroundColor = UIColor.clear
//           cell.selectedBackgroundView = clearView
//
//                  return cell
//       }
//       
//    
//    func fullProcessScanning(type : Int) {
//        let config = DocReader.ScannerConfig()
//        if(type == 0) {
//           config.scenario = RGL_SCENARIO_FULL_AUTH   // RGL_SCENARIO_FULL_AUTH //RGL_SCENARIO_FULL_PROCESS
//        }
//       else if(type == 1) {
//            config.scenario = RGL_SCENARIO_CREDIT_CARD
//        }
//       else if(type == 2) {
//            config.scenario = RGL_SCENARIO_MRZ
//        }
//        else if(type == 3) {
//             config.scenario = RGL_SCENARIO_BARCODE
//         }
//      
//        
//       
//
//
//        DocReader.shared.showScanner(presenter: self, config: config) { [self] (action, result, error) in
//            if action == .complete || action == .processTimeout {
//                 print(result?.rawResult as Any)
//                
//                
//
//                 
//                    if result?.chipPage != 0 && UserLocalStore.shared.RFIDChipProcessing == true {
//                        self.startRFIDReading(result)
//                    } else {
//                        if ApplicationSetting.shared.isDataEncryptionEnabled {
//                            statusLabel.text = "Decrypting data..."
//                            activityIndicator.startAnimating()
//                            popUpView.isHidden = false
//                            processEncryptedResults(result!) { decryptedResult in
//                                DispatchQueue.main.async {
//                                    self.popUpView.isHidden = true
//                                    
//                                    guard let results = decryptedResult else {
//                                        print("Can't decrypt result")
//                                        return
//                                    }
//                                    
//                                   
//                                    
//                                    self.presentResults(results)
//                                }
//                            }
//                        } else {
//                            presentResults(result!)
//                        }
//                    }
//                    
//            
//                
//              
//                
//                
//                
//            
//              
//                               
//             
//                
//            }
//            else  if action == .cancel  {
//               
//            }
//        }
//        
////  showCameraViewController()
//    }
//    
//    
//       // method to run when table view cell is tapped
//       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//           
//         
//           
//           
//         //  DocReader.shared.processParams.multipageProcessing = true
////           DocReader.shared.processParams.doublePageSpread = true
////           DocReader.shared.customization.cameraFrameActiveColor = .purple
////           DocReader.shared.functionality.isZoomEnabled = true
////
////           DocReader.shared.functionality.zoomFactor = 10
////           DocReader.shared.functionality.showCameraSwitchButton = true
////           DocReader.shared.functionality.showCaptureButton = true
////           DocReader.shared.functionality.showMetadataInfo = true
////           DocReader.shared.processParams
//           
//           
//           
//           
////           DocReader.shared.processParams.doublePageSpread = true
////           DocReader.shared.processParams.timeout = 10
//////           DocReader.shared.inputView?.motionEffects = true
////           DocReader.shared.processParams.manualCrop = true
////           DocReader.shared.processParams.integralImage
//           
//           UserLocalStore.shared.clickedIndex = indexPath.row
//           
//           
//           if(indexPath.row == 0) {
//               DocReader.shared.processParams.multipageProcessing = UserLocalStore.shared.MultipageProcessing == true ? 1 : 0
//
//           }
//           else {
//               DocReader.shared.processParams.multipageProcessing = 0
//
//           }
//           
//           
//          // DocReader.shared.functionality.manualMultipageMode = true
//           
//           
//            
//
//               DocReader.shared.startNewSession()
//           
//          
//           DocReader.shared.processParams.debugSaveLogs = true
//           DocReader.shared.processParams.debugSaveCroppedImages = true
//           DocReader.shared.processParams.debugSaveRFIDSession = true
//           
////           
//           DocReader.shared.processParams.respectImageQuality = true
//           DocReader.shared.processParams.imageQA.dpiThreshold = 150
//           DocReader.shared.processParams.imageQA.angleThreshold = 5
//           DocReader.shared.processParams.imageQA.focusCheck = true
//           DocReader.shared.processParams.imageQA.colornessCheck = true
//           DocReader.shared.processParams.imageQA.documentPositionIndent = 5
//           DocReader.shared.processParams.imageQA.expectedPass = [.imageResolution, .imageGlares]
////
//           DocReader.shared.processParams.imageQA.colornessCheck = true
//           
//           DocReader.shared.processParams.authenticityParams = AuthenticityParams.default()
//
//           DocReader.shared.processParams.authenticityParams?.livenessParams = LivenessParams.default()
//
//            DocReader.shared.processParams.authenticityParams?.livenessParams?.checkHolo = true
////
////           
////          
////
//           DocReader.shared.processParams.authenticityParams?.livenessParams?.checkED = true
//           DocReader.shared.processParams.authenticityParams?.livenessParams?.checkOVI = true
//           DocReader.shared.processParams.authenticityParams?.livenessParams?.checkMLI = true
//           DocReader.shared.processParams.authenticityParams = AuthenticityParams.default()
//
//           DocReader.shared.processParams.authenticityParams?.checkImagePatterns = true
//           
//           DocReader.shared.processParams.authenticityParams = AuthenticityParams.default()
//
//           DocReader.shared.processParams.authenticityParams?.checkPhotoEmbedding = true
//           
//           DocReader.shared.processParams.authenticityParams?.livenessParams = LivenessParams.default()
////           
////           
////
////
//
//           
//          // topLayerView.isHidden = false
//          // Loader.show()
//           if indexPath.row == 0 {
//              
//               fullProcessScanning(type: 0)
//
//           }
//           
//           
//          else if indexPath.row == 1 {
//              
//              fullProcessScanning(type: 1)
//              
////               let config = DocReader.ScannerConfig()
////               config.scenario = RGL_SCENARIO_CREDIT_CARD
////
////               DocReader.shared.showScanner(presenter: self, config: config) { [self] (action, result, error) in
////                   if action == .complete || action == .processTimeout {
////                       print(result?.rawResult as Any)
////
////
////                       if result?.chipPage != 0 && UserLocalStore.shared.RFIDChipProcessing == true {
////                           self.startRFIDReading(result)
////                       } else {
////                           if ApplicationSetting.shared.isDataEncryptionEnabled {
////                               statusLabel.text = "Decrypting data..."
////                               activityIndicator.startAnimating()
////                               popUpView.isHidden = false
////                               processEncryptedResults(result!) { decryptedResult in
////                                   DispatchQueue.main.async {
////                                       self.popUpView.isHidden = true
////
////                                       guard let results = decryptedResult else {
////                                           print("Can't decrypt result")
////                                           return
////                                       }
////
////
////
////                                       self.presentResults(results)
////                                   }
////                               }
////                           } else {
////                               presentResults(result!)
////                           }
////                       }
////
////
////
////
////                   }
////               }
////
//        //showCameraViewController()
//
//           }
//           
//           
//           else if indexPath.row == 2 {
//              // showCameraViewControllerForMrz()
//               fullProcessScanning(type: 2)
////                let config = DocReader.ScannerConfig()
////                config.scenario = RGL_SCENARIO_MRZ
////
////                DocReader.shared.showScanner(presenter: self, config: config) { [self] (action, result, error) in
////                    if action == .complete || action == .processTimeout {
////                        print(result?.rawResult as Any)
////
////
////                        if ApplicationSetting.shared.isDataEncryptionEnabled {
////                            statusLabel.text = "Decrypting data..."
////                            activityIndicator.startAnimating()
////                            popUpView.isHidden = false
////                            processEncryptedResults(result!) { decryptedResult in
////                                DispatchQueue.main.async {
////                                    self.popUpView.isHidden = true
////
////                                    guard let results = decryptedResult else {
////                                        print("Can't decrypt result")
////                                        return
////                                    }
////
////
////
////                                    self.presentResults(results)
////                                }
////                            }
////                        } else {
////                            presentResults(result!)
////                        }
////
////                    }
////                }
////
//         //showCameraViewController()
//
//            }
//           
//           else if indexPath.row == 3 {
//               
//               fullProcessScanning(type: 3)
//               
////                let config = DocReader.ScannerConfig()
////                config.scenario = RGL_SCENARIO_BARCODE
////
////                DocReader.shared.showScanner(presenter: self, config: config) { [self] (action, result, error) in
////                    if action == .complete || action == .processTimeout {
////                        print(result?.rawResult as Any)
////
////                        if result?.chipPage != 0 && UserLocalStore.shared.RFIDChipProcessing == true {
////                            self.startRFIDReading(result)
////                        } else {
////                            if ApplicationSetting.shared.isDataEncryptionEnabled {
////                                statusLabel.text = "Decrypting data..."
////                                activityIndicator.startAnimating()
////                                popUpView.isHidden = false
////                                processEncryptedResults(result!) { decryptedResult in
////                                    DispatchQueue.main.async {
////                                        self.popUpView.isHidden = true
////
////                                        guard let results = decryptedResult else {
////                                            print("Can't decrypt result")
////                                            return
////                                        }
////
////
////
////                                        self.presentResults(results)
////                                    }
////                                }
////                            } else {
////                                presentResults(result!)
////                            }
////                        }
////
////
////
////
////                    }
////                }
//                
//         //showCameraViewController()
//
//            }
//           
//           else if indexPath.row == 4 {
//                let config = DocReader.ScannerConfig()
//                config.scenario = RGL_SCENARIO_OCR
//
//                DocReader.shared.showScanner(presenter: self, config: config) { [self] (action, result, error) in
//                    if action == .complete || action == .processTimeout {
//                        print(result?.rawResult as Any)
//                      
//                                       
//                        if ApplicationSetting.shared.isDataEncryptionEnabled {
//                            statusLabel.text = "Decrypting data..."
//                            activityIndicator.startAnimating()
//                            popUpView.isHidden = false
//                            processEncryptedResults(result!) { decryptedResult in
//                                DispatchQueue.main.async {
//                                    self.popUpView.isHidden = true
//                                    
//                                    guard let results = decryptedResult else {
//                                        print("Can't decrypt result")
//                                        return
//                                    }
//                                    
//                                   
//                                    
//                                    self.presentResults(results)
//                                }
//                            }
//                        } else {
//                            presentResults(result!)
//                        }
//                        
//                    }
//                }
//                
//         //showCameraViewController()
//
//            }
//           
//           else{
//               print("You tapped cell number \(indexPath.row).")
//               let vc = self.storyboard?.instantiateViewController(withIdentifier: "StartProcessViewController") as! StartProcessViewController
//               self.navigationController?.pushViewController(vc, animated: true)
//           }
//
//       }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//       return UITableView.automaticDimension
//    }
//    
//    
//    
//    // MARK: - Private methods
//
//    lazy var onlineProcessing: CustomizationItem = {
//        let item = CustomizationItem("Online Processing") { [weak self] in
//            guard let self = self else { return }
//            let container = UINavigationController(rootViewController: OnlineProcessingViewController())
//            container.modalPresentationStyle = .fullScreen
//            self.present(container, animated: true, completion: nil)
//        }
//        return item
//    }()
//
//    private func initSectionsWithoutLicence() {
//        let childModeSection = CustomizationSection("Custom", [onlineProcessing])
//        sectionsData.append(childModeSection)
//    }
//    
//    private func initSections() {
//        // 1. Default
//        let defaultScanner = CustomizationItem("Default (showScanner)") {
//            DocReader.shared.functionality = ApplicationSetting.shared.functionality
//        }
//        
//        defaultScanner.resetFunctionality = false
//        let stillImage = CustomizationItem("Gallery (recognizeImages)")
//        stillImage.actionType = .gallery
//        let recognizeImageInput = CustomizationItem("Recognize images with light type") { [weak self] in
//            guard let self = self else { return }
//            self.recognizeImagesWithImageInput()
//        }
//        
//        recognizeImageInput.actionType = .custom
//        let defaultSection = CustomizationSection("Default", [defaultScanner, stillImage, recognizeImageInput])
//        sectionsData.append(defaultSection)
//        
//        // 2. Custom modes
//        let childModeScanner = CustomizationItem("Child mode") { [weak self] in
//            guard let self = self else { return }
//            self.showAsChildViewController()
//        }
//        childModeScanner.actionType = .custom
//        let manualMultipageMode = CustomizationItem("Manual multipage mode") { [weak self] in
//            guard let self = self else { return }
//            // Set default copy of functionality
//            DocReader.shared.functionality = ApplicationSetting.shared.functionality
//            // Manual multipage mode
//            DocReader.shared.functionality.manualMultipageMode = true
//            DocReader.shared.startNewSession()
//            self.showScannerForManualMultipage()
//        }
//        manualMultipageMode.resetFunctionality = false
//        manualMultipageMode.actionType = .custom
//        let customModedSection = CustomizationSection("Custom", [childModeScanner, manualMultipageMode, onlineProcessing])
//        sectionsData.append(customModedSection)
//        
//        // 3. Custom camera frame
//        let customBorderWidth = CustomizationItem("Custom border width") { () -> (Void) in
//            DocReader.shared.customization.cameraFrameBorderWidth = 10
//        }
//        let customBorderColor = CustomizationItem("Custom border color") { () -> (Void) in
//            DocReader.shared.customization.cameraFrameDefaultColor = .red
//            DocReader.shared.customization.cameraFrameActiveColor = .purple
//        }
//        let customShape = CustomizationItem("Custom shape") { () -> (Void) in
//            DocReader.shared.customization.cameraFrameShapeType = .corners
//            DocReader.shared.customization.cameraFrameLineLength = 40
//            DocReader.shared.customization.cameraFrameCornerRadius = 10
//            DocReader.shared.customization.cameraFrameLineCap = .round
//        }
//        let customOffset = CustomizationItem("Custom offset") { () -> (Void) in
//            DocReader.shared.customization.cameraFrameOffsetWidth = 50
//        }
//        let customAspectRatio = CustomizationItem("Custom aspect ratio") { () -> (Void) in
//            DocReader.shared.customization.cameraFramePortraitAspectRatio = 1.0
//            DocReader.shared.customization.cameraFrameLandscapeAspectRatio = 1.0
//        }
//        let customFramePosition = CustomizationItem("Custom position") { () -> (Void) in
//            DocReader.shared.customization.cameraFrameVerticalPositionMultiplier = 0.5
//        }
//        
//        let customCameraFrameItems = [customBorderWidth, customBorderColor, customShape, customOffset, customAspectRatio, customFramePosition]
//        let customCameraFrameSection = CustomizationSection("Custom camera frame", customCameraFrameItems)
//        sectionsData.append(customCameraFrameSection)
//        
//        // 4. Custom toolbar
//        let customTorchButton = CustomizationItem("Custom torch button") { () -> (Void) in
//            DocReader.shared.functionality.showTorchButton = true
//            DocReader.shared.customization.torchButtonOnImage = UIImage(named: "light-on")
//            DocReader.shared.customization.torchButtonOffImage = UIImage(named: "light-off")
//        }
//        let customCameraSwitch = CustomizationItem("Custom camera switch button") { () -> (Void) in
//            DocReader.shared.functionality.showCameraSwitchButton = true
//            DocReader.shared.customization.cameraSwitchButtonImage = UIImage(named: "camera")
//        }
//        let customCaptureButton = CustomizationItem("Custom capture button") { () -> (Void) in
//            DocReader.shared.functionality.showCaptureButton = true
//            DocReader.shared.functionality.showCaptureButtonDelayFromStart = 0
//            DocReader.shared.functionality.showCaptureButtonDelayFromDetect = 0
//            DocReader.shared.customization.captureButtonImage = UIImage(named: "palette")
//        }
//        let customChangeFrameButton = CustomizationItem("Custom change frame button") { () -> (Void) in
//            DocReader.shared.functionality.showChangeFrameButton = true
//            DocReader.shared.customization.changeFrameButtonExpandImage = UIImage(named: "expand")
//            DocReader.shared.customization.changeFrameButtonCollapseImage = UIImage(named: "collapse")
//        }
//        let customCloseButton = CustomizationItem("Custom close button") { () -> (Void) in
//            DocReader.shared.functionality.showCloseButton = true
//            DocReader.shared.customization.closeButtonImage = UIImage(named: "close")
//        }
//        let customSizeOfToolbar = CustomizationItem("Custom size of the toolbar") { () -> (Void) in
//            DocReader.shared.customization.toolbarSize = 120
//            DocReader.shared.customization.torchButtonOnImage = UIImage(named: "light-on")
//            DocReader.shared.customization.torchButtonOffImage = UIImage(named: "light-off")
//            DocReader.shared.customization.closeButtonImage = UIImage(named: "big_close")
//            //DocReader.shared.customization.
//        }
//        
//        let customToolbarItems = [customTorchButton, customCameraSwitch, customCaptureButton, customChangeFrameButton, customCloseButton, customSizeOfToolbar]
//        let customToolbarSection = CustomizationSection("Custom toolbar", customToolbarItems)
//        sectionsData.append(customToolbarSection)
//        
//        // 5. Custom status messages
//        let customText = CustomizationItem("Custom text") { () -> (Void) in
//            DocReader.shared.customization.showStatusMessages = true
//            DocReader.shared.customization.status = "Custom status"
//        }
//        
//        let customTextFont = CustomizationItem("Custom text font") { () -> (Void) in
//            DocReader.shared.customization.showStatusMessages = true
//            DocReader.shared.customization.statusTextFont = UIFont.systemFont(ofSize: 24, weight: .semibold)
//        }
//        
//        let customTextColor = CustomizationItem("Custom text color") { () -> (Void) in
//            DocReader.shared.customization.showStatusMessages = true
//            DocReader.shared.customization.statusTextColor = .blue
//        }
//        let customStatusPosition = CustomizationItem("Custom position") { () -> (Void) in
//            DocReader.shared.customization.showStatusMessages = true
//            DocReader.shared.customization.statusPositionMultiplier = 0.5
//        }
//        
//        let customStatusItems = [customText, customTextFont, customTextColor, customStatusPosition]
//        let customStatusSection = CustomizationSection("Custom status messages", customStatusItems)
//        sectionsData.append(customStatusSection)
//        
//        // 6. Custom result status messages
//        let customResultStatusText = CustomizationItem("Custom text") { () -> (Void) in
//            DocReader.shared.customization.showResultStatusMessages = true
//            DocReader.shared.customization.resultStatus = "Custom result status"
//        }
//        let customResultStatusFont = CustomizationItem("Custom text font") { () -> (Void) in
//            DocReader.shared.customization.showResultStatusMessages = true
//            DocReader.shared.customization.resultStatusTextFont = UIFont.systemFont(ofSize: 24, weight: .semibold)
//        }
//        let customResultStatusColor = CustomizationItem("Custom text color") { () -> (Void) in
//            DocReader.shared.customization.showResultStatusMessages = true
//            DocReader.shared.customization.resultStatusTextColor = .blue
//        }
//        let customResultStatusBackColor = CustomizationItem("Custom background color") { () -> (Void) in
//            DocReader.shared.customization.showResultStatusMessages = true
//            DocReader.shared.customization.resultStatusBackgroundColor = .blue
//        }
//        let customResultStatusPosition = CustomizationItem("Custom position") { () -> (Void) in
//            DocReader.shared.customization.showResultStatusMessages = true
//            DocReader.shared.customization.resultStatusPositionMultiplier = 0.5
//        }
//        
//        let customResultStatusItems = [customResultStatusText, customResultStatusFont, customResultStatusColor, customResultStatusBackColor, customResultStatusPosition]
//        let customResultStatusSection = CustomizationSection("Custom result status messages", customResultStatusItems)
//        sectionsData.append(customResultStatusSection)
//        
//        // 7. Free custom status
//        let freeCustomTextAndPostion = CustomizationItem("Free text + position") { () -> (Void) in
//            let fontAttributes =  [NSAttributedString.Key.foregroundColor: UIColor.red, NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 18)]
//            DocReader.shared.customization.customLabelStatus = NSAttributedString(string: "Hello, world!", attributes: fontAttributes)
//            DocReader.shared.customization.customStatusPositionMultiplier = 0.5
//        }
//        
//        let customUILayerModeStatic = CustomizationItem("Custom Status & Images & Buttons") { [weak self] in
//            guard let self = self else { return }
//            self.setupCustomUIFromFile()
//        }
//        let customUILayerButtons = CustomizationItem("Custom Buttons") { [weak self] in
//            guard let self = self else { return }
//            self.setupCustomUIButtonsFromFile()
//        }
//        
//        let customUILayerModeAnimated = CustomizationItem("Custom Status Animated") { [weak self] in
//            guard let self = self else { return }
//            self.isCustomUILayerEnabled = true
//            self.animationTimer.fire()
//        }
//        
//        let freeCustomStatusItems = [freeCustomTextAndPostion, customUILayerModeStatic, customUILayerButtons, customUILayerModeAnimated]
//        let freeCustomStatusSection = CustomizationSection("Free custom status", freeCustomStatusItems)
//        sectionsData.append(freeCustomStatusSection)
//        
//        // 8. Custom animations
//        let customAnimationHelpImage = CustomizationItem("Help animation image") { () -> (Void) in
//            DocReader.shared.customization.showHelpAnimation = true
//            DocReader.shared.customization.helpAnimationImage = UIImage(named: "credit-card")
//        }
//        let customAnimationNextPageImage = CustomizationItem("Custom the next page animation") { () -> (Void) in
//            DocReader.shared.customization.showNextPageAnimation = true
//            DocReader.shared.customization.multipageAnimationFrontImage = UIImage(named: "1")
//            DocReader.shared.customization.multipageAnimationBackImage = UIImage(named: "2")
//        }
//        
//        let customAnimationItems = [customAnimationHelpImage, customAnimationNextPageImage]
//        let customAnimationSection = CustomizationSection("Custom animations", customAnimationItems)
//        sectionsData.append(customAnimationSection)
//        
//        // 9. Custon tint color
//        let customTintColor = CustomizationItem("Activity indicator") { () -> (Void) in
//            DocReader.shared.customization.activityIndicatorColor = .red
//        }
//        let custonNextPageButton = CustomizationItem("Next page button") { () -> (Void) in
//            DocReader.shared.functionality.showSkipNextPageButton = true
//            DocReader.shared.customization.multipageButtonBackgroundColor = .red
//        }
//        let customAllVisualElements = CustomizationItem("All visual elements") { () -> (Void) in
//            DocReader.shared.customization.tintColor = .blue
//        }
//        
//        let customTintColorItems = [customTintColor, custonNextPageButton, customAllVisualElements]
//        let customTintColorSection = CustomizationSection("Custom tint color", customTintColorItems)
//        sectionsData.append(customTintColorSection)
//        
//        // 10. Custom background
//        let noBackgroundMask = CustomizationItem("No background mask") { () -> (Void) in
//            DocReader.shared.customization.showBackgroundMask = false
//        }
//        let customBackgroundAlpha = CustomizationItem("Custom alpha") { () -> (Void) in
//            DocReader.shared.customization.backgroundMaskAlpha = 0.8
//        }
//        let customBackgroundImage = CustomizationItem("Custom background image") { () -> (Void) in
//            DocReader.shared.customization.borderBackgroundImage = UIImage(named: "viewfinder")
//        }
//        
//        let customBackgroundItems = [noBackgroundMask, customBackgroundAlpha, customBackgroundImage]
//        let customBackgroundSection = CustomizationSection("Custom background", customBackgroundItems)
//        sectionsData.append(customBackgroundSection)
//    }
//    
//    private func enableUserInterfaceOnSuccess() {
//       popUpView.isHidden = true
//       optionsTV.isHidden = false
//        bottomView.isUserInteractionEnabled = true
//        if let scenario = DocReader.shared.availableScenarios.first {
//            selectedScenario = scenario.identifier
//        }
//    }
//    
//    private func showScannerForManualMultipage() {
//        let config = DocReader.ScannerConfig()
//        config.scenario = selectedScenario
//        
//        DocReader.shared.showScanner(presenter: self, config:config) { [weak self] (action, result, error) in
//            guard let self = self else { return }
//            switch action {
//            case .cancel:
//                print("Cancelled by user")
//                DocReader.shared.functionality.manualMultipageMode = false
//            case .complete, .processTimeout:
//                guard let results = result else {
//                    return
//                }
//                if results.morePagesAvailable != 0 {
//                    // Scan next page in manual mode
//                    DocReader.shared.startNewPage()
//                    self.showScannerForManualMultipage()
//                } else if !results.isResultsEmpty() {
//                    self.showResultScreen(results)
//                    DocReader.shared.functionality.manualMultipageMode = false
//                }
//            case .error:
//                print("Error")
//                guard let error = error else { return }
//                print("Error string: \(error)")
//            case .process:
//                guard let result = result else { return }
//                print("Scaning not finished. Result: \(result)")
//            default:
//                break
//            }
//        }
//    }
//    
//    private func recognizeImagesWithImageInput() {
//        let whiteImage = UIImage(named: "white.bmp")
//        let uvImage = UIImage(named: "uv.bmp")
//        let irImage = UIImage(named: "ir.bmp")
//        
//        let whiteInput = DocReader.ImageInput(image: whiteImage!, light: .white, pageIndex: 0)
//        let uvInput = DocReader.ImageInput(image: uvImage!, light: .UV, pageIndex: 0)
//        let irInput = DocReader.ImageInput(image: irImage!, light: .infrared, pageIndex: 0)
//        let imageInputs = [whiteInput, irInput, uvInput]
//        
//        let config = DocReader.RecognizeConfig(imageInputs: imageInputs)
//        config.scenario = selectedScenario
//        DocReader.shared.recognize(config:config) { action, results, error in
//            switch action {
//            case .cancel:
//                self.stopCustomUIChanges()
//                print("Cancelled by user")
//            case .complete, .processTimeout:
//                self.stopCustomUIChanges()
//                guard let opticalResults = results else {
//                    return
//                }
//                self.showResultScreen(opticalResults)
//            case .error:
//                self.stopCustomUIChanges()
//                print("Error")
//                guard let error = error else { return }
//                print("Error string: \(error)")
//            case .process:
//                guard let result = results else { return }
//                print("Scaning not finished. Result: \(result)")
//            case .morePagesAvailable:
//                print("This status couldn't be here, it uses for -recognizeImage function")
//            default:
//                break
//            }
//        }
//    }
//    
//    private func showAsChildViewController() {
//        let mainStoryboard = UIStoryboard(name: kMainStoryboardId, bundle: nil)
//
//    }
//    
//    private func startRFIDReading(_ opticalResults: DocumentReaderResults? = nil) {
//        if ApplicationSetting.shared.useCustomRfidController {
//            let mainStoryboard = UIStoryboard(name: kMainStoryboardId, bundle: nil)
//            guard let rfidController = self.storyboard?.instantiateViewController(withIdentifier: "DocumentReaderVC") as? DocumentReaderVC else {
//                return
//            }
//            rfidController.modalPresentationStyle = .fullScreen
//            rfidController.opticalResults = opticalResults
//            rfidController.completionHandler = { (results) in
//                self.showResultScreen(results)
//            }
//            present(rfidController, animated: true, completion: nil)
//        } else {
//            DocReader.shared.processParams.logs = true
//            DocReader.shared.startRFIDReader(fromPresenter: self, completion: { [weak self] (action, results, error) in
//                guard let self = self else { return }
//                switch action {
//                case .complete:
//                    guard let results = results else {
//                        return
//                    }
//                    self.showResultScreen(results)
//                case .cancel:
//                    guard let results = opticalResults else {
//                        return
//                    }
//                    self.showResultScreen(results)
//                case .error:
//                    print("Error")
//                default:
//                    break
//                }
//            })
//        }
//    }
//    
//    private func showResultScreen(_ results: DocumentReaderResults) {
//        if ApplicationSetting.shared.isDataEncryptionEnabled {
//            statusLabel.text = "Decrypting data..."
//            activityIndicator.startAnimating()
//            popUpView.isHidden = false
//            processEncryptedResults(results) { decryptedResult in
//                DispatchQueue.main.async {
//                    self.popUpView.isHidden = true
//                    
//                    guard let results = decryptedResult else {
//                        print("Can't decrypt result")
//                        return
//                    }
//                    self.presentResults(results)
//                }
//            }
//        } else {
//            presentResults(results)
//        }
//    }
//    
//    func convertToDictionary(text: String) -> [String: Any]? {
//        if let data = text.data(using: .utf8) {
//            do {
//                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//        return nil
//    }
//    var audioPlayer: AVAudioPlayer?
//   
//    
//    private func presentResults(_ results: DocumentReaderResults) {
//        UserLocalStore.shared.documentMisMatch = false
//     
//        var docStatusCode = 0
//        var isDigitalScreen = false
//        var isColorness = false
//        
//        UserLocalStore.shared.haveError = ""
//        
//        if !isConnectedToNetwork(){
//            self.view.makeToast("Internet connection appears to be offline.")
//            return
//        }
//        
//        var countriesArray = [String]()
//        var numberArray = [String]()
//        var issueArray = [String]()
//        var namesArray = [String]()
//        
//        for i in 0 ..< (results.authenticityResults?.checks?.count ?? 0) {
//                if(results.authenticityResults?.checks![i].type.rawValue == 2097152 &&
//                   results.authenticityResults?.checks![i].status.rawValue == 0) {
//                    isDigitalScreen = true
//                }
//            
//            
//        }
//        
//        for i in 0 ..< (results.imageQualityGroup?[0].imageQualityList.count ?? 0) {
//                if(results.imageQualityGroup![0].imageQualityList[i].type == "3" &&
//                   results.imageQualityGroup![0].imageQualityList[i].result.rawValue != 1) {
//                    isColorness = true
//                }
//            
//            
//        }
//        
//       // po results.authenticityResults?.checks![1].type.rawValue
//        
//        for i in 0 ..< results.textResult.fields.count {
//            
//            if(results.textResult.fields[i].fieldName.lowercased() == "document status") {
//                docStatusCode = results.textResult.fields[i].fieldType.rawValue
//            
//            }
//            
//            print(results.textResult.fields[i].fieldName)
//            print(results.textResult.fields[i].fieldType)
//            print(results.textResult.fields[i].value)
//            
//        let fieldName = results.textResult.fields[i].fieldName
//           
//            if(countriesArray.count == 0) {
//                if(fieldName.lowercased().contains("country")) {
//                    if(results.textResult.fields[i].values.count >= 2) {
//                        for k in 0 ..< results.textResult.fields[i].values.count {
//                            countriesArray.append(results.textResult.fields[i].values[k].value)
//                        }
//                    }
//                }
//            }
//           
//           // || fieldName.lowercased().contains("personal number")
//            
//            if(numberArray.count == 0) {
//                if(fieldName.lowercased().contains("document number") ) {
//                    if(results.textResult.fields[i].values.count >= 2) {
//                        for k in 0 ..< results.textResult.fields[i].values.count {
//                            numberArray.append(results.textResult.fields[i].values[k].value)
//                        }
//                    }
//                }
//            }
//            
//          
//            if(issueArray.count == 0) {
//                if(fieldName.lowercased().contains("issue")) {
//                    if(results.textResult.fields[i].values.count >= 2) {
//                        for k in 0 ..< results.textResult.fields[i].values.count {
//                            issueArray.append(results.textResult.fields[i].values[k].value)
//                        }
//                    }
//                }
//            }
//            
//            
//            if(namesArray.count == 0) {
//                if(fieldName.lowercased().contains("surname and given names")) {
//                    if(results.textResult.fields[i].values.count >= 2) {
//                        for k in 0 ..< results.textResult.fields[i].values.count {
//                            namesArray.append(results.textResult.fields[i].values[k].value)
//                        }
//                    }
//                }
//            }
//        
//        
//        
//    }
//        
//       // && results.documentType?.count ?? 0 < 2
//        
//        
//        if ((results.documentType?[0].dDescription == "Identity Card" || results.documentType?[0].dDescription == "Driving License") ) {
//            if(results.documentType?.count ?? 0 < 2) {
//                UserLocalStore.shared.haveError = "yes"
//                self.view.makeToast("Document missmatched", duration: 4)
//            }
//        }
//        
//        if(docStatusCode == 682) {
//         
//          UserLocalStore.shared.haveError = "yes"
//          self.view.makeToast("Specimen Copy", duration: 4)
//          
//      }
//          if(isDigitalScreen == true) {
//            UserLocalStore.shared.haveError = "yes"
//            self.view.makeToast("Digital Screen Document", duration: 4)
//            
//        }
//          if(isColorness == true) {
//            UserLocalStore.shared.haveError = "yes"
//            self.view.makeToast("Image is colorness", duration: 4)
//
//        }
//         if(numberArray.count != 0) {
//            let allItemsEqual = numberArray.allSatisfy { $0 == numberArray.first }
//            if(allItemsEqual == false) {
//                self.view.makeToast("Document missmatched", duration: 4)
//                UserLocalStore.shared.haveError = "yes"
//            }
//          
//        }
//             
//          if(countriesArray.count != 0) {
//            let allItemsEqual = countriesArray.allSatisfy { $0 == countriesArray.first }
//            if(allItemsEqual == false) {
//                self.view.makeToast("Document missmatched", duration: 4)
//                UserLocalStore.shared.haveError = "yes"
//            }
//            
//            
//        }
//        
//                
//        if(issueArray.count != 0) {
//                    let allItemsEqual = issueArray.allSatisfy { $0 == issueArray.first }
//                    if(allItemsEqual == false) {
//                        self.view.makeToast("Document missmatched", duration: 4)
//                        UserLocalStore.shared.haveError = "yes"
//                    }
//                  
//                }
//                
//        if(namesArray.count != 0) {
//                    let allItemsEqual = namesArray.allSatisfy { $0 == namesArray.first }
//                    if(allItemsEqual == false) {
//                        self.view.makeToast("Document missmatched", duration: 4)
//                        UserLocalStore.shared.haveError = "yes"
//                    }
//                   
//                }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
//            self.handleDataForNavigation(results)
//        }
//     
//          
//        
//        
//        
//        
//        
//        
//        
//        
//        
//        
//        
//        
////
////        if ((results.documentType?[0].dDescription == "Identity Card" || results.documentType?[0].dDescription == "Driving License") ) {
////            if(results.documentType?.count ?? 0 < 2) {
////                Alert.shared.displayMyAlertMessage(title: "Alert", message: "Document missmatched", actionTitle: "Ok") {
////                    print("doesn't match document")
////                    UserLocalStore.shared.documentMisMatch = true
////                    UserLocalStore.shared.haveError = "yes"
////                    self.handleDataForNavigation(results)
////                }
////            }
////            else {
////
////                  if(docStatusCode == 682) {
////
////                        Alert.shared.displayMyAlertMessage(title: "Alert", message: "Specimen Copy", actionTitle: "Ok") {
////                            print("doesn't match document")
////                            UserLocalStore.shared.haveError = "yes"
////                            self.handleDataForNavigation(results)
////                        }
////                      //  return
////
////                }
////
////                else  if(isDigitalScreen == true) {
////
////                        Alert.shared.displayMyAlertMessage(title: "Alert", message: "Digital Screen Document", actionTitle: "Ok") {
////                            print("doesn't match document")
////                            UserLocalStore.shared.haveError = "yes"
////                            self.handleDataForNavigation(results)
////                        }
////                      //  return
////
////                }
////
////                else  if(isColorness == true) {
////
////                        Alert.shared.displayMyAlertMessage(title: "Alert", message: "Image is colorness", actionTitle: "Ok") {
////                            print("doesn't match document")
////                            UserLocalStore.shared.haveError = "yes"
////                            self.handleDataForNavigation(results)
////                        }
////                      //  return
////
////                }
////
////        //      else  if(countriesArray.count != 0) {
////        //            let allItemsEqual = countriesArray.allSatisfy { $0 == countriesArray.first }
////        //            if(allItemsEqual == false) {
////        //                Alert.shared.displayMyAlertMessage(title: "Alert", message: "Document missmatched", actionTitle: "Ok") {
////        //                    print("doesn't match document")
////        //                    UserLocalStore.shared.haveError = "yes"
////        //                    self.handleDataForNavigation(results)
////        //                }
////        //               // return
////        //            }
////        //          else {
////        //              handleDataForNavigation(results)
////        //          }
////        //        }
////
////                else if(numberArray.count != 0) {
////                    let allItemsEqual = numberArray.allSatisfy { $0 == numberArray.first }
////                    if(allItemsEqual == false) {
////                        Alert.shared.displayMyAlertMessage(title: "Alert", message: "Document missmatched", actionTitle: "Ok") {
////                            print("doesn't match document")
////                            UserLocalStore.shared.haveError = "yes"
////                            self.handleDataForNavigation(results)
////                        }
////                      //  return
////                    }
////                    else {
////                        handleDataForNavigation(results)
////                    }
////                }
////
////        //        else  if(issueArray.count != 0) {
////        //            let allItemsEqual = issueArray.allSatisfy { $0 == issueArray.first }
////        //            if(allItemsEqual == false) {
////        //                Alert.shared.displayMyAlertMessage(title: "Alert", message: "Document missmatched", actionTitle: "Ok") {
////        //                    print("doesn't match document")
////        //                    UserLocalStore.shared.haveError = "yes"
////        //                    self.handleDataForNavigation(results)
////        //                }
////        //                //return
////        //            }
////        //            else {
////        //                handleDataForNavigation(results)
////        //            }
////        //        }
////        //        else  if(namesArray.count != 0) {
////        //            let allItemsEqual = namesArray.allSatisfy { $0 == namesArray.first }
////        //            if(allItemsEqual == false) {
////        //                Alert.shared.displayMyAlertMessage(title: "Alert", message: "Document missmatched", actionTitle: "Ok") {
////        //                    print("doesn't match document")
////        //                    UserLocalStore.shared.haveError = "yes"
////        //                    self.handleDataForNavigation(results)
////        //                }
////        //               // return
////        //            }
////        //            else {
////        //                handleDataForNavigation(results)
////        //            }
////        //        }
////
////
////                else {
////                    handleDataForNavigation(results)
////                }
////
////            }
////
////
////
////        }
////        else {
////            Alert.shared.displayMyAlertMessage(title: "Alert", message: "Something went wrong", actionTitle: "Ok") {
////                print("doesn't match document")
////
////            }
////        }
// 
//    
//    }
//    
//    func handleDataForNavigation(_ results: DocumentReaderResults)  {
//        
//        if (UserLocalStore.shared.Vibration == true) {
//                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
//            }
//            if (UserLocalStore.shared.SoundEnabled == true) {
//                let soundFileName = UserLocalStore.shared.SelectedSound
//                       
//                       // Load the sound file
//                       if let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: "mp3") {
//                           do {
//                               audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
//                               audioPlayer?.play()
//                           } catch {
//                               print("Error loading sound file: \(error.localizedDescription)")
//                           }
//                       }
//            }
//            
//  
//        if( UserLocalStore.shared.clickedIndex == 0) {
//            if(UserLocalStore.shared.Liveness == true) {
//                guard let resultsViewController = self.storyboard?.instantiateViewController(withIdentifier: "StartProcessViewController") as? StartProcessViewController else {
//                        return
//                    }
//                resultsViewController.results = results
//                resultsViewController.modalPresentationStyle = .fullScreen
//                self.present(resultsViewController, animated: true, completion: nil)
//            }
//            else {
//                guard let resultsViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserInfoVC") as? UserInfoVC else {
//                        return
//                    }
//                resultsViewController.results = results
//                resultsViewController.getUserSessionId = ""
//                resultsViewController.faceLiveness = false
//                self.present(resultsViewController, animated: true, completion: nil)
//            }
//            
//         
//        }
//        else {
//            
//
//            guard let resultsViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserInfoVC") as? UserInfoVC else {
//                    return
//                }
//            resultsViewController.results = results
//            resultsViewController.getUserSessionId = ""
//            resultsViewController.faceLiveness = false
//            self.present(resultsViewController, animated: true, completion: nil)
//        }
//        
//       
//    }
//    
//    
//    private func showSettingsScreen() {
////        let mainStoryboard = UIStoryboard(name: kMainStoryboardId, bundle: nil)
//
//    }
//    
//    private func showHelpPopup() {
//        let actionSheet = UIAlertController(title: nil, message: "Information",
//                                            preferredStyle: .actionSheet)
//        
//        let actionDocs = UIAlertAction(title: "Documents", style: .default) { _ in
//            self.openSafariWith("https://docs.regulaforensics.com/home/faq/machine-readable-travel-documents")
//        }
//        actionSheet.addAction(actionDocs)
//        let actionCore = UIAlertAction(title: "Core", style: .default) { _ in
//            self.openSafariWith("https://docs.regulaforensics.com/develop/doc-reader-sdk/mobile/ios/optimization/core")
//        }
//        actionSheet.addAction(actionCore)
//        let actionScenarios = UIAlertAction(title: "Scenarios", style: .default) { _ in
//            self.openSafariWith("https://docs.regulaforensics.com/develop/doc-reader-sdk/mobile/ios/document-processing/scenario")
//        }
//        actionSheet.addAction(actionScenarios)
//        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
//        
////        actionSheet.popoverPresentationController?.barButtonItem = self.helpBarButton
//        present(actionSheet, animated: true, completion: nil)
//    }
//    
//    private func openSafariWith(_ link: String) {
//        guard let url = URL(string: link) else { return }
//        let controller = SFSafariViewController(url: url)
//        self.present(controller, animated: true, completion: nil)
//    }
//    
//    private func showCameraViewController() {
//        let config = DocReader.ScannerConfig()
//        config.scenario = selectedScenario
//        
//        DocReader.shared.showScanner(presenter: self, config:config) { [weak self] (action, result, error) in
//            guard let self = self else { return }
//            
//            switch action {
//            case .cancel:
//                self.stopCustomUIChanges()
//                print("Cancelled by user")
//            case .complete, .processTimeout:
//                self.stopCustomUIChanges()
//                guard let opticalResults = result else {
//                    return
//                }
//                if opticalResults.chipPage != 0 && ApplicationSetting.shared.isRfidEnabled {
//                    self.startRFIDReading(opticalResults)
//                } else {
//                    self.showResultScreen(opticalResults)
//                }
//            case .error:
//                self.stopCustomUIChanges()
//                print("Error")
//                guard let error = error else { return }
//                print("Error string: \(error)")
//            case .process:
//                guard let result = result else { return }
//                print("Scaning not finished. Result: \(result)")
//                print(result.rawResult)
//            case .morePagesAvailable:
//                print("This status couldn't be here, it uses for -recognizeImage function")
//            default:
//                break
//            }
//        }
//    }
//
//    
//    private func showCameraViewControllerForMrz() {
//        let config = DocReader.ScannerConfig()
//        config.scenario = selectedScenario
//        
//        DocReader.shared.showScanner(presenter: self, config:config) { [weak self] (action, result, error) in
//            guard let self = self else { return }
//            
//            switch action {
//            case .cancel:
//                self.stopCustomUIChanges()
//                print("Cancelled by user")
//            case .complete, .processTimeout:
//                self.stopCustomUIChanges()
//                guard let opticalResults = result else {
//                    return
//                }
//                if opticalResults.chipPage != 0 && UserLocalStore.shared.RFIDChipProcessing == true {
//                    self.startRFIDReading(opticalResults)
//                } else {
//                    self.showResultScreen(opticalResults)
//                }
//            case .error:
//                self.stopCustomUIChanges()
//                print("Error")
//                guard let error = error else { return }
//                print("Error string: \(error)")
//            case .process:
//                guard let result = result else { return }
//                print("Scaning not finished. Result: \(result)")
//                print(result.rawResult)
//            case .morePagesAvailable:
//                print("This status couldn't be here, it uses for -recognizeImage function")
//            default:
//                break
//            }
//        }
//    }
//  
//    // MARK: - Encrypted processing
//    private func processEncryptedResults(_ encrypted: DocumentReaderResults, completion: ((DocumentReaderResults?) -> (Void))?) {
//        let json = encrypted.rawResult
//        
//        let data = Data(json.utf8)
//
//        do {
//            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                guard let containers = json["ContainerList"] as? [String: Any] else {
//                    completion?(nil)
//                    return
//                }
//                guard let list = containers["List"] as? [[String: Any]] else {
//                    completion?(nil)
//                    return
//                }
//                
//                let processParam:[String: Any] = [
//                    "scenario": RGL_SCENARIO_FULL_PROCESS,
//                    "alreadyCropped": true
//                ]
//                let params:[String: Any] = [
//                    "List": list,
//                    "processParam": processParam
//                ]
//                
//                guard let jsonData = try? JSONSerialization.data(withJSONObject: params, options: []) else {
//                    completion?(nil)
//                    return
//                }
//                sendDecryptionRequest(jsonData) { result in
//                    completion?(result)
//                }
//            }
//        } catch let error as NSError {
//            print("Failed to load: \(error.localizedDescription)")
//        }
//    }
//    
//    private func sendDecryptionRequest(_ jsonData: Data, _ completion: ((DocumentReaderResults?) -> (Void))? ) {
//        guard let url = URL(string: "https://api.regulaforensics.com/api/process") else { return }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.httpBody = jsonData
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
//            guard let jsonData = data else {
//                completion?(nil)
//                return
//            }
//            
//            let decryptedResult = String(data: jsonData, encoding: .utf8)
//                .flatMap { DocumentReaderResults.initWithRawString($0) }
//            completion?(decryptedResult)
//        })
//
//        task.resume()
//    }
//    
//    // MARK: - RFID additions
//    
//    private func getRfidCertificates(bundleName: String) -> [PKDCertificate] {
//        var certificates: [PKDCertificate] = []
//        let masterListURL = Bundle.main.bundleURL.appendingPathComponent(bundleName)
//        do {
//            let contents = try FileManager.default.contentsOfDirectory(at: masterListURL, includingPropertiesForKeys: [URLResourceKey.nameKey, URLResourceKey.isDirectoryKey], options: .skipsHiddenFiles)
//            
//            for content in contents {
//                if let cert = try? Data(contentsOf: content)  {
//                    certificates.append(PKDCertificate.init(binaryData: cert, resourceType: PKDCertificate.findResourceType(typeName: content.pathExtension), privateKey: nil))
//                }
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
//        
//        return certificates
//    }
//    
//    func getRfidTACertificates() -> [PKDCertificate] {
//        var paCertificates: [PKDCertificate] = []
//        let masterListURL = Bundle.main.bundleURL.appendingPathComponent("CertificatesTA.bundle")
//        do {
//            let contents = try FileManager.default.contentsOfDirectory(at: masterListURL, includingPropertiesForKeys: [URLResourceKey.nameKey, URLResourceKey.isDirectoryKey], options: .skipsHiddenFiles)
//            
//            var filesCertMap: [String: [URL]] = [:]
//            
//            for content in contents {
//                let fileName = content.deletingPathExtension().lastPathComponent
//                if filesCertMap[fileName] == nil {
//                    filesCertMap[fileName] = []
//                }
//                filesCertMap[fileName]?.append(content.absoluteURL)
//            }
//            
//            for (_, certificates) in filesCertMap {
//                var binaryData: Data?
//                var privateKey: Data?
//                for cert in certificates {
//                    if let data = try? Data(contentsOf: cert) {
//                        if cert.pathExtension.elementsEqual("cvCert") {
//                            binaryData = data
//                        } else {
//                            privateKey = data
//                        }
//                    }
//                }
//                if let data = binaryData {
//                    paCertificates.append(PKDCertificate.init(binaryData: data, resourceType: .certificate_TA, privateKey: privateKey))
//                }
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
//        
//        return paCertificates
//    }
//    
//    private func setupCustomUIFromFile() {
//        if let path = Bundle.main.path(forResource: "layer", ofType: "json") {
//            do {
//                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
//                let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
//                DocReader.shared.customization.actionDelegate = self
//                DocReader.shared.customization.customUILayerJSON = jsonDict
//            } catch {
//                
//            }
//        }
//    }
//    
//    private func setupCustomUIButtonsFromFile() {
//        if let path = Bundle.main.path(forResource: "buttons", ofType: "json") {
//            do {
//                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
//                let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
//                
//                DocReader.shared.functionality.showTorchButton = false
//                DocReader.shared.functionality.showCloseButton = false
//                
//                DocReader.shared.customization.actionDelegate = self
//                DocReader.shared.customization.customUILayerJSON = jsonDict
//            } catch {
//                
//            }
//        }
//    }
//        
//    @objc func fireTimer() {
//     
//        guard isCustomUILayerEnabled else {
//            return
//        }
//        
//        guard let jsonData = customLayerJsonString.data(using: .utf8) else {
//            return
//        }
//        
//        guard var model = try? JSONDecoder().decode(CustomUILayerModel.self, from: jsonData) else {
//            return
//        }
//        
//        guard var object = model.objects.first else {
//            return
//        }
//        
//        let date = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm:ss"
//        object.label.text = "Custom label that showing current time: \(dateFormatter.string(from: date))"
//        
//        let ct = CACurrentMediaTime()
//        object.label.position.v = 1.0 + sin(ct) * 0.5 // Move vertically from 0.5 to 1.5
//        
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//        
//        model.objects = [object]
//
//        do {
//            let data = try encoder.encode(model)
//            if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                DocReader.shared.customization.customUILayerJSON = jsonDict
//            }
//        } catch {
//            
//        }
//    }
//    
//    private func stopCustomUIChanges() {
//        isCustomUILayerEnabled = false
//        DocReader.shared.customization.customUILayerJSON = nil
//    }
//}
//
//
//
//// MARK: - DocReader.CustomizationActionDelegate
//extension ViewController: DocReader.CustomizationActionDelegate {
//    func onCustomButtonTapped(withTag tag: Int) {
//        print("Button with \(tag) tag pressed")
//    }
//}
//
//
//
//// MARK: - RGLDocReaderRFIDDelegate
//
//extension ViewController: RGLDocReaderRFIDDelegate {
//    func onRequestPACertificates(withSerial serialNumber: Data!, issuer: PAResourcesIssuer!, callback: (([PKDCertificate]?) -> Void)!) {
//        let certificates = self.getRfidCertificates(bundleName: "Certificates.bundle")
//        callback(certificates)
//    }
//    
//    func onRequestTACertificates(withKey keyCAR: String!, callback: (([PKDCertificate]?) -> Void)!) {
//        let certificates = self.getRfidTACertificates()
//        callback(certificates)
//    }
//    
//    func onRequestTASignature(with challenge: TAChallenge!, callback: ((Data?) -> Void)!) {
//        callback(nil)
//    }
//}
//
//extension PKDCertificate {
//    static func findResourceType(typeName: String) -> PKDResourceType {
//        switch typeName.lowercased() {
//        case "pa":
//            return PKDResourceType.certificate_PA
//        case "ta":
//            return PKDResourceType.certificate_TA
//        case "ldif":
//            return PKDResourceType.LDIF
//        case "crl":
//            return PKDResourceType.CRL
//        case "ml":
//            return PKDResourceType.ML
//        case "defl":
//            return PKDResourceType.defL
//        case "devl":
//            return PKDResourceType.devL
//        case "bl":
//            return PKDResourceType.BL
//        default:
//            return PKDResourceType.certificate_PA
//        }
//    }
//}
//
//    
//
//
//
//
