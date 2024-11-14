//
//  UserInfoVC.swift
//  ipass_plus
//
//  Created by Mobile on 01/02/24.
//

import UIKit
import DocumentReader
import Alamofire
import NVActivityIndicatorView
import NaturalLanguage
import PKHUD
import SwiftUI
import AWSRekognition
import AWSCore
import Foundation
import Toast_Swift


class UserInfoVC: UIViewController {
    
    @IBOutlet weak var dismissBtn: UIButton!
    //MARK: IBOutlets
    @IBOutlet weak var sendMessage: UIButton!
    @IBOutlet weak var scanRfid: UIButton!
    @IBOutlet weak var startLivenessScanning: UIButton! //noUser
    @IBOutlet weak var userInfoCollectionVw: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userAge: UILabel!
    @IBOutlet weak var imgWarning: UIImageView!
    @IBOutlet weak var imgTimer: UIImageView!
    @IBOutlet weak var imgFaceMatching: UIImageView!
    @IBOutlet weak var imgFaceLiveness: UIImageView!
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var bottomDataView: UIView!
    
    
    //MARK: Properties
    var  userImage = UIImage()
    var rfidUserImage = UIImage()
    var handleUserLivenessIcon = "0"
    var handleUserFacematchingIcon = "0"
    var faceMatching = 0.0
    var rfidMatchingValue = 0.0
    var faceLiveness = false
    var numOfPagesFullProcessing:[String] = ["0","1","2", "3"]
    var numOfPagesforAll:[String] = ["0","1","2"]
    var topDataArray = [NSDictionary]()
    var imageView = UIImage()
    var results: DocumentReaderResults!
    var scanningIndex:Int?
    var allData: [Any] = []
    var dataDict = NSMutableDictionary()
    var userNameString = ""
    var getUserSessionId = ""
    var dobString = ""
    var addressString = ""
    var ageString = ""
    var documentNumberString = ""
    var documentName = ""
    var documentisMrz = false
    var stateCode = ""
    var gender = ""
    var imagesArray = [UIImage]()
    var CapturedImage = UIImage()
    var activityIndicator = UIActivityIndicatorView()
    var firstImg = UIImage(named:"img3")
    var secondImage = UIImage(named:"img3")
    var newsectionsData = [NewSection]()
    var metaDataValues = [String]()
    var rfidDataValues = [String]()
    var rFIDChipData:[String] = []
    var titleArr:String = ""
    var valuseArr:String = ""
    var userLiveImageString = ""
    var liveImageConfidenceValue = 0.0
    var isRematching = false
    var haveRfidImage = false
    var currentLanguage = "en"
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let preferredLanguageCode = Locale.preferredLanguages.first {
             currentLanguage = Locale(identifier: preferredLanguageCode).languageCode ?? "en"
            print("Device's preferred language code: \(currentLanguage)")
          
        } else {
            print("Unable to determine the device's preferred language code.")
        }
        userInfoCollectionVw.semanticContentAttribute = .forceLeftToRight
        userInfoCollectionVw.setContentOffset(.zero, animated: false)
        dismissBtn.setTitle("dismiss".localizeString(string: HomeDataManager.shared.languageCodeString), for: .normal)  
        
        profileImg.layer.cornerRadius = 5
        scanningIndex = UserLocalStore.shared.clickedIndex
        processData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           // Lock orientation to portrait
           UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
           UINavigationController.attemptRotationToDeviceOrientation()
       }
    
    @IBAction func dismissClick(_ sender: Any) {
        self.dismiss(animated: true) 
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return .portrait // or .landscape, .landscapeLeft, .landscapeRight, etc.
        }
        
        override var shouldAutorotate: Bool {
            return true
        }
    
    //MARK: View Life Cycle
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        

        
        if(isRematching == false) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newRootViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            UIApplication.shared.keyWindow?.rootViewController = newRootViewController
            UIApplication.shared.keyWindow?.makeKeyAndVisible()
        }
        
        
    }
    
    //MARK: Function for Liveness and Facematching
    func manageAWSIcons(){
        
        if(scanningIndex == 0) {
            if(UserLocalStore.shared.Liveness == true) {
                if self.liveImageConfidenceValue >= 80 {
                    handleUserLivenessIcon = "1"
                }
                else{
                    handleUserLivenessIcon = "2"
                }
            }
            else {
                handleUserLivenessIcon = "0"
            }
           if(UserLocalStore.shared.FaceMatching == true) {
                if(haveRfidImage == true) {
                    if self.faceMatching >= 80  && self.rfidMatchingValue >= 80{
                        handleUserFacematchingIcon = "1"
                    }
                    else{
                        handleUserFacematchingIcon = "2"
                    }
                }
                else {
                    if self.faceMatching >= 80 {
                        handleUserFacematchingIcon = "1"
                    }
                    else{
                        handleUserFacematchingIcon = "2"
                    }
                }
                
               
            }
            else {
                handleUserFacematchingIcon = "0"
            }
        }
        else {
            handleUserLivenessIcon = "0"
            handleUserFacematchingIcon = "0"
        }
        
        
        
    }
    
    func bindDataFUnction() {
        
        manageAWSIcons()
        
        if(handleUserLivenessIcon == "1") {
            imgFaceLiveness.isHidden = false
            self.imgFaceLiveness.image = UIImage(named: "imgiveness")
        }
        else if(handleUserLivenessIcon == "2") {
            imgFaceLiveness.isHidden = false
            self.imgFaceLiveness.image = UIImage(named: "cross")
        }
        
        else  {
            imgFaceLiveness.isHidden = true
        }
        
        
        if(handleUserFacematchingIcon == "1") {
            imgFaceMatching.isHidden = false
            self.imgFaceMatching.image = UIImage(named: "imgMatch")
        }
        else if(handleUserFacematchingIcon == "2") {
            imgFaceMatching.isHidden = false
            self.imgFaceMatching.image = UIImage(named: "crs")
        }
        
        else  {
            imgFaceMatching.isHidden = true
        }
        
        
        topStackView.isHidden = false
        bottomDataView.isHidden = false
        pageController.isHidden = false
        userInfoCollectionVw.delegate = self
        userInfoCollectionVw.dataSource = self
        pageController.currentPage = 0
        if scanningIndex == 0 {
            if UserLocalStore.shared.Liveness == true || UserLocalStore.shared.FaceMatching == true {
                pageController.numberOfPages = numOfPagesFullProcessing.count
            }else{
                pageController.numberOfPages = numOfPagesforAll.count
            }
            
        }else{
            pageController.numberOfPages = numOfPagesforAll.count
        }
        
        
        //MARK: Register NibFile
        
        let verificationNib = UINib(nibName: "UserVerificationCell", bundle: nil)
        self.userInfoCollectionVw.register(verificationNib, forCellWithReuseIdentifier: "UserVerificationCell")
        
        let profilePicNib = UINib(nibName: "UserProfileCollectionCell", bundle: nil)
        self.userInfoCollectionVw.register(profilePicNib, forCellWithReuseIdentifier: "UserProfileCollectionCell") //UserDetailCollectionCell
        
        let userDetailNib = UINib(nibName: "UserDetailCollectionCell", bundle: nil)
        self.userInfoCollectionVw.register(userDetailNib, forCellWithReuseIdentifier: "UserDetailCollectionCell") //UserCardCollectionCell
        
        let userCardNib = UINib(nibName: "UserCardCollectionCell", bundle: nil)
        self.userInfoCollectionVw.register(userCardNib, forCellWithReuseIdentifier: "UserCardCollectionCell")
        //UserDocumentImgsCollectionCell
        let documetNib = UINib(nibName: "UserDocumentImgsCollectionCell", bundle: nil)
        self.userInfoCollectionVw.register(documetNib, forCellWithReuseIdentifier: "UserDocumentImgsCollectionCell")
        
        getTapGestureofImages()
    }
    
    
    
    func getLiveImage() {
        DispatchQueue.main.async {
            Loader.show()
        }
        
        
        
        guard let apiURL = URL(string: "https://plusapi.ipass-mena.com/api/v1/ipass/session/result?sessionId="+getUserSessionId) else { return }
        
        
        
        
        AF.request(apiURL, method: .get,encoding: JSONEncoding.default, headers: HTTPHeaders(["Content-Type": "application/json"]))
            .responseJSON { response in
                
                let status = response.response?.statusCode
                
                
                if(status == 200) {
                    
                    print("{{{}{}{}}{{}{}{}{}}{}{")
                    print(response.value as Any)
                    
                    var livenessData = NSDictionary()
                    livenessData = response.value as! NSDictionary
                    
                    print((livenessData["response"] as! NSDictionary)  ["Status"] ?? "")
                    
                    var statusStr = ""
                    statusStr = (livenessData["response"] as! NSDictionary)  ["Status"] as! String
                    
                    
                    print("7887878778787888778++++++++++")
                    print(statusStr)
                    
                    if(statusStr == "SUCCEEDED") || statusStr == "Success" || statusStr == "Warning" {
                        
                        var temp = NSDictionary()
                        
                        
                        temp = (livenessData["response"] as! NSDictionary)  ["ReferenceImage"] as? NSDictionary ?? NSDictionary()
                        
                        print("Data-=-=-=-=-=",temp)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            
                            self.liveImageConfidenceValue = (livenessData["response"] as! NSDictionary)  ["Confidence"] as? Double ?? 0.0
                            
                            self.userLiveImageString = temp["Bytes"] as? String ?? ""
                            self.faceMatchingApi(liveImage: temp["Bytes"] as? String ?? "")
                        }
                        
                        
                    }
                    else {
                        // SHOW ERRRO
                        Loader.hide()
                        self.bindDataFUnction()
                    }
                    
                    
                    
                    
                    
                }
                else {
                    Loader.hide()
                    self.bindDataFUnction()
                }
                
            }
    }
    
    
    
    
    func getTapGestureofImages(){
        
        let firstGesture = UITapGestureRecognizer(target: self, action: #selector(ScrollFirstIndex))
        imgWarning.isUserInteractionEnabled = true
        imgWarning.addGestureRecognizer(firstGesture)
        
        let secondGesture = UITapGestureRecognizer(target: self, action: #selector(ScrollSecondIndex))
        imgTimer.isUserInteractionEnabled = true
        imgTimer.addGestureRecognizer(secondGesture)
        
        let thirdGesture = UITapGestureRecognizer(target: self, action: #selector(ScrollThirdIndex))
        imgFaceMatching.isUserInteractionEnabled = true
        imgFaceMatching.addGestureRecognizer(thirdGesture)
        
        let fourthGesture = UITapGestureRecognizer(target: self, action: #selector(ScrollFourthIndex))
        imgFaceLiveness.isUserInteractionEnabled = true
        imgFaceLiveness.addGestureRecognizer(fourthGesture)
    }
    
    
    
    func detectLanguage<T: StringProtocol>(for text: T) -> String? {
        let tagger = NSLinguisticTagger.init(tagSchemes: [.language], options: 0)
        tagger.string = String(text)
        
        guard let languageCode = tagger.tag(at: 0, scheme: .language, tokenRange: nil, sentenceRange: nil) else { return nil }
        print(Locale.current.localizedString(forIdentifier: languageCode.rawValue)!)
        return Locale.current.localizedString(forIdentifier: languageCode.rawValue)
    }
    
    func processData() {
        
        if(getUserSessionId == "") {
            startLivenessScanning.isHidden = true
        }
        
        if(results.chipPage == 0) {
            scanRfid.isHidden = true
            
        }
        else {
            scanRfid.isHidden = false
        }
        
        if(results.documentType?.count != 0 && results.documentType != nil) {
            documentName = results.documentType?[0].name ?? "-"
            documentisMrz = results.documentType?[0].dMRZ ?? false
        }
        
        let pngImage = results.getGraphicFieldImageByType(fieldType: .gf_Portrait)?.pngData()
        userImage = UIImage(data: pngImage ?? Data()) ?? UIImage()
        
        
        for m in 0 ..< results.graphicResult.fields.count {
            
            let image : UIImage = UIImage(cgImage: results.graphicResult.fields[m].value.cgImage!)
            imagesArray.append(image)
            
            if(results.graphicResult.fields[m].sourceType.stringValue.lowercased().contains("rfidimage")) {
                haveRfidImage = true
                rfidUserImage = results.graphicResult.fields[m].value
                print("rfidUserImage-=-=-=",rfidUserImage)
            }
            
            
//            let ddd = results.graphicResult.fields[m].value
//            
//            arrayData.append(ddd)
//            
//            NameArray.append(results.graphicResult.fields[m].fieldName)
//            
//            sourceName.append( results.graphicResult.fields[m].sourceType.stringValue )
//            
//            typeName.append( String(results.graphicResult.fields[m].fieldType.rawValue))
            
        }
        
        for i in 0 ..< results.textResult.fields.count {
            
            
           
            
            dataDict[results.textResult.fields[i].fieldName] = results.textResult.fields[i].value
            
            let fieldName = results.textResult.fields[i].fieldName
            let value = results.textResult.fields[i].value
            
            var titlesArray = [String]()
            var detailsArray = [String]()
            var mainStatus = 0
            var ComparisionStatus = 0
            
            
            
            mainStatus = results.textResult.fields[i].status.rawValue
            ComparisionStatus = results.textResult.fields[i].validityStatus.rawValue
            
            for k in 0 ..< results.textResult.fields[i].values.count {
                
                titlesArray.append(results.textResult.fields[i].values[k].sourceType.stringValue)
                detailsArray.append(results.textResult.fields[i].values[k].value)
            }
            
            print("23232323232323")
            
            print(detailsArray.count)
            
            let newSection = NewSection(title: fieldName, detail: value, subtitle: titlesArray, subDetail: detailsArray, topStatus: mainStatus, internalStatus: ComparisionStatus)
            newsectionsData.append(newSection)
            
        }

        print(dataDict)
        var allKeys = NSArray()
        allKeys = dataDict.allKeys as NSArray
        
        var haveDateOfExpiry = false
        
      
       
        
        
        
        if( currentLanguage.lowercased() == "en") {
            for j in 0 ..< allKeys.count {
                var tempStr = String()
                tempStr = allKeys[j] as! String
                
                let dd = NSMutableDictionary()
                
                
                if(tempStr.lowercased() == "bank card number") {
                    dd["Bank card number"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                

                if(tempStr.lowercased() == "other") {
                    dd["Other"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr.lowercased() == "category") {
                    dd["Category"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr.lowercased() == "bank card validity") {
                    dd["Bank card validity"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                
                
                if(tempStr.lowercased() == "nationality") {
                    dd["Nationality"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr.lowercased() == "personal number") {
                    dd["Personal number"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr.lowercased() == "date of issue") {
                    dd["Date of issue"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr.lowercased() == "date of expiry") {
                    dd["Date of expiry"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                
                
                
                if(tempStr.lowercased() == "date of expiry") {
                    haveDateOfExpiry = true
                    dd["Date of expiry"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                    let expiryDateString = dd["Date of expiry"] as? String ?? ""
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy/MM/dd" // Ensure this matches your date format
                    if let expiryDate = dateFormatter.date(from: expiryDateString) {
                        let now = Date()
                        DispatchQueue.main.async {
                            if expiryDate < now {
                                // Expired
                                self.imgTimer.isHidden = false
                            }
                            else {
                                self.imgTimer.isHidden = true
                                
                            }
                        }
                    }
                }
                
                
                if(tempStr.lowercased().contains("surname and given names")) {
                    userNameString = dataDict[tempStr] as! String
                }
                
                if(tempStr.lowercased() == "date of birth") {
                    dobString = dataDict[tempStr] as! String
                    
                    dd["Date of Birth"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                    
                }
                
                if(tempStr.lowercased().contains("address")) {
                    addressString = dataDict[tempStr] as! String
                    dd["Address"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                
                
                if(tempStr.lowercased().contains("sex")) {
                    gender = dataDict[tempStr] as! String
                }
                
                if(tempStr.lowercased().contains("age")) {
                    ageString = dataDict[tempStr] as! String
                }
                if(tempStr.lowercased() == "document number") {
                    documentNumberString = dataDict[tempStr] as! String
                    dd["Document Number"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr.lowercased().contains("state code")) {
                    stateCode = dataDict[tempStr] as! String
                }
            }
        }
        else if( currentLanguage.lowercased() == "ar") {
            for j in 0 ..< allKeys.count {
                var tempStr = String()
                tempStr = allKeys[j] as! String
                
                let dd = NSMutableDictionary()
                
                
                if(tempStr == "رقم البطاقة البنكية") {
                    dd["رقم البطاقة البنكية"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                

                if(tempStr == "آخر") {
                    dd["آخر"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "الفئة") {
                    dd["الفئة"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "صلاحية البطاقة البنكية") {
                    dd["صلاحية البطاقة البنكية"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                
                
                if(tempStr == "الجنسية") {
                    dd["الجنسية"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "الرقم الشخصي") {
                    dd["الرقم الشخصي"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "تاريخ الإصدار") {
                    dd["تاريخ الإصدار"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "تاريخ الانتهاء") {
                    dd["تاريخ الانتهاء"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                
                
                
                if(tempStr == "تاريخ الانتهاء") {
                    haveDateOfExpiry = true
                    dd["تاريخ الانتهاء"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                    let expiryDateString = dd["تاريخ الانتهاء"] as? String ?? ""
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy/MM/dd" // Ensure this matches your date format
                    if let expiryDate = dateFormatter.date(from: expiryDateString) {
                        let now = Date()
                        DispatchQueue.main.async {
                            if expiryDate < now {
                                // Expired
                                self.imgTimer.isHidden = false
                            }
                            else {
                                self.imgTimer.isHidden = true
                                
                            }
                        }
                    }
                }
                
                
                if(tempStr.contains("اسم العائلة والأسماء الأولى")) {
                    userNameString = dataDict[tempStr] as! String
                }
                
                if(tempStr == "تاريخ الميلاد") {
                    dobString = dataDict[tempStr] as! String
                    
                    dd["تاريخ الميلاد"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                    
                }
                
                if(tempStr.contains("عنوان")) {
                    addressString = dataDict[tempStr] as! String
                    dd["عنوان"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                
                
                if(tempStr.contains("الجنس")) {
                    gender = dataDict[tempStr] as! String
                }
                
                if(tempStr.contains("عمر")) {
                    ageString = dataDict[tempStr] as! String
                }
                if(tempStr == "رقم الوثيقة") {
                    documentNumberString = dataDict[tempStr] as! String
                    dd["رقم الوثيقة"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr.contains("رمز الدولة المصدرة")) {
                    stateCode = dataDict[tempStr] as! String
                }
            }
        }
        else if( currentLanguage.lowercased() == "fr") {
            for j in 0 ..< allKeys.count {
                var tempStr = String()
                tempStr = allKeys[j] as! String
                
                let dd = NSMutableDictionary()
                
                
                if(tempStr == "Numéro de carte bancaire") {
                    dd["Numéro de carte bancaire"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                

                if(tempStr == "Autre") {
                    dd["Autre"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "Catégorie") {
                    dd["Catégorie"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "Validité de la carte bancaire") {
                    dd["Validité de la carte bancaire"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                
                
                if(tempStr == "Nationalité") {
                    dd["Nationalité"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "Numéro personnel") {
                    dd["Numéro personnel"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "Date de délivrance") {
                    dd["Date de délivrance"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "Date d'expiration") {
                    dd["Date d'expiration"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                
                
                
                if(tempStr == "Date d'expiration") {
                    haveDateOfExpiry = true
                    dd["Date d'expiration"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                    let expiryDateString = dd["Date d'expiration"] as? String ?? ""
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy/MM/dd" // Ensure this matches your date format
                    if let expiryDate = dateFormatter.date(from: expiryDateString) {
                        let now = Date()
                        DispatchQueue.main.async {
                            if expiryDate < now {
                                // Expired
                                self.imgTimer.isHidden = false
                            }
                            else {
                                self.imgTimer.isHidden = true
                                
                            }
                        }
                    }
                }
                
                
                if(tempStr.contains("Nom de famille et prénoms")) {
                    userNameString = dataDict[tempStr] as! String
                }
                
                if(tempStr == "Date de naissance") {
                    dobString = dataDict[tempStr] as! String
                    
                    dd["Date de naissance"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                    
                }
                
                if(tempStr.contains("Adresse")) {
                    addressString = dataDict[tempStr] as! String
                    dd["Adresse"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                
                
                if(tempStr.contains("Sexe")) {
                    gender = dataDict[tempStr] as! String
                }
                
                if(tempStr.contains("Âge")) {
                    ageString = dataDict[tempStr] as! String
                }
                if(tempStr == "Numéro de document") {
                    documentNumberString = dataDict[tempStr] as! String
                    dd["Code de l'état délivrant"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr.contains("state code")) {
                    stateCode = dataDict[tempStr] as! String
                }
            }
        }
        else if( currentLanguage.lowercased() == "es") {
            for j in 0 ..< allKeys.count {
                var tempStr = String()
                tempStr = allKeys[j] as! String
                
                let dd = NSMutableDictionary()
                
                
                if(tempStr == "Número de tarjeta bancaria") {
                    dd["Número de tarjeta bancaria"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                

                if(tempStr == "Otro") {
                    dd["Otro"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "Categoría") {
                    dd["Categoría"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "Validez de la tarjeta bancaria") {
                    dd["Validez de la tarjeta bancaria"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                
                
                if(tempStr == "Nacionalidad") {
                    dd["Nacionalidad"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "Número personal") {
                    dd["Número personal"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "Fecha de emisión") {
                    dd["Fecha de emisión"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "Fecha de vencimiento") {
                    dd["Fecha de vencimiento"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                
                
                
                if(tempStr == "Fecha de vencimiento") {
                    haveDateOfExpiry = true
                    dd["Fecha de vencimiento"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                    let expiryDateString = dd["Fecha de vencimiento"] as? String ?? ""
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy/MM/dd" // Ensure this matches your date format
                    if let expiryDate = dateFormatter.date(from: expiryDateString) {
                        let now = Date()
                        DispatchQueue.main.async {
                            if expiryDate < now {
                                // Expired
                                self.imgTimer.isHidden = false
                            }
                            else {
                                self.imgTimer.isHidden = true
                                
                            }
                        }
                    }
                }
                
                
                if(tempStr.contains("Apellido y nombres")) {
                    userNameString = dataDict[tempStr] as! String
                }
                
                if(tempStr == "Fecha de nacimiento") {
                    dobString = dataDict[tempStr] as! String
                    
                    dd["Fecha de nacimiento"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                    
                }
                
                if(tempStr.contains("Dirección")) {
                    addressString = dataDict[tempStr] as! String
                    dd["Dirección"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                
                
                if(tempStr.contains("Sexo")) {
                    gender = dataDict[tempStr] as! String
                }
                
                if(tempStr.contains("Edad")) {
                    ageString = dataDict[tempStr] as! String
                }
                if(tempStr == "Número de documento") {
                    documentNumberString = dataDict[tempStr] as! String
                    dd["Número de documento"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr.contains("Código de estado emisor")) {
                    stateCode = dataDict[tempStr] as! String
                }
            }
        }
        else if( currentLanguage.lowercased() == "tr") {
            for j in 0 ..< allKeys.count {
                var tempStr = String()
                tempStr = allKeys[j] as! String
                
                let dd = NSMutableDictionary()
                
                
                if(tempStr == "Banka kartı numarası") {
                    dd["Banka kartı numarası"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                

                if(tempStr == "Diğer") {
                    dd["Diğer"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "Kategori") {
                    dd["Kategori"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "Banka kartı geçerlilik süresi") {
                    dd["Banka kartı geçerlilik süresi"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                
                
                if(tempStr == "Uyruk") {
                    dd["Uyruk"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "Kişisel numara") {
                    dd["Kişisel numara"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "Veriliş tarihi") {
                    dd["Veriliş tarihi"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "Sona erme tarihi") {
                    dd["Sona erme tarihi"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                
                
                
                if(tempStr == "Sona erme tarihi") {
                    haveDateOfExpiry = true
                    dd["Sona erme tarihi"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                    let expiryDateString = dd["Sona erme tarihi"] as? String ?? ""
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy/MM/dd" // Ensure this matches your date format
                    if let expiryDate = dateFormatter.date(from: expiryDateString) {
                        let now = Date()
                        DispatchQueue.main.async {
                            if expiryDate < now {
                                // Expired
                                self.imgTimer.isHidden = false
                            }
                            else {
                                self.imgTimer.isHidden = true
                                
                            }
                        }
                    }
                }
                
                
                if(tempStr.contains("Soyadı ve verilen adlar")) {
                    userNameString = dataDict[tempStr] as! String
                }
                
                if(tempStr == "Doğum tarihi") {
                    dobString = dataDict[tempStr] as! String
                    
                    dd["Doğum tarihi"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                    
                }
                
                if(tempStr.contains("Adres")) {
                    addressString = dataDict[tempStr] as! String
                    dd["Adres"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                
                
                if(tempStr.contains("Cinsiyet")) {
                    gender = dataDict[tempStr] as! String
                }
                
                if(tempStr.contains("Yaş")) {
                    ageString = dataDict[tempStr] as! String
                }
                if(tempStr == "Belge numarası") {
                    documentNumberString = dataDict[tempStr] as! String
                    dd["Belge numarası"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr.contains("Veren devlet kodu")) {
                    stateCode = dataDict[tempStr] as! String
                }
            }
        }
        else if( currentLanguage.lowercased() == "ur") {
            for j in 0 ..< allKeys.count {
                var tempStr = String()
                tempStr = allKeys[j] as! String
                
                let dd = NSMutableDictionary()
                
                
                if(tempStr == "بینک کارڈ نمبر") {
                    dd["بینک کارڈ نمبر"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                

                if(tempStr == "دیگر") {
                    dd["دیگر"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "زمرہ") {
                    dd["زمرہ"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "بینک کارڈ کی مدت") {
                    dd["بینک کارڈ کی مدت"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                
                
                if(tempStr == "قومیت") {
                    dd["قومیت"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "ذاتی نمبر") {
                    dd["ذاتی نمبر"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "جاری کرنے کی تاریخ") {
                    dd["جاری کرنے کی تاریخ"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr  == "ختم ہونے کی تاریخ") {
                    dd["ختم ہونے کی تاریخ"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                
                
                
                if(tempStr  == "ختم ہونے کی تاریخ") {
                    haveDateOfExpiry = true
                    dd["ختم ہونے کی تاریخ"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                    let expiryDateString = dd["ختم ہونے کی تاریخ"] as? String ?? ""
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy/MM/dd" // Ensure this matches your date format
                    if let expiryDate = dateFormatter.date(from: expiryDateString) {
                        let now = Date()
                        DispatchQueue.main.async {
                            if expiryDate < now {
                                // Expired
                                self.imgTimer.isHidden = false
                            }
                            else {
                                self.imgTimer.isHidden = true
                                
                            }
                        }
                    }
                }
                
                
                if(tempStr.contains("خاندانی نام اور دیے گئے نام")) {
                    userNameString = dataDict[tempStr] as! String
                }
                
                if(tempStr == "پیدائش کی تاریخ") {
                    dobString = dataDict[tempStr] as! String
                    
                    dd["پیدائش کی تاریخ"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                    
                }
                
                if(tempStr.contains("پتہ")) {
                    addressString = dataDict[tempStr] as! String
                    dd["پتہ"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                
                
                if(tempStr.contains("جنس")) {
                    gender = dataDict[tempStr] as! String
                }
                
                if(tempStr.contains("عمر")) {
                    ageString = dataDict[tempStr] as! String
                }
                if(tempStr == "مستندات کی تعداد") {
                    documentNumberString = dataDict[tempStr] as! String
                    dd["مستندات کی تعداد"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr.contains("اجراء کرنے والے ریاست کا کوڈ")) {
                    stateCode = dataDict[tempStr] as! String
                }
            }
        }
        else if( currentLanguage.lowercased() == "de") {
            for j in 0 ..< allKeys.count {
                var tempStr = String()
                tempStr = allKeys[j] as! String
                
                let dd = NSMutableDictionary()
                
                
                if(tempStr == "Bankkartennummer") {
                    dd["Bankkartennummer"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                

                if(tempStr == "Andere") {
                    dd["Andere"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "Kategorie") {
                    dd["Kategorie"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "Gültigkeit der Bankkarte") {
                    dd["Gültigkeit der Bankkarte"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                
                
                if(tempStr == "Nationalität") {
                    dd["Nationalität"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "Persönliche Nummer") {
                    dd["Persönliche Nummer"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "Ausgabedatum") {
                    dd["Ausgabedatum"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "Ablaufdatum") {
                    dd["Ablaufdatum"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                
                
                
                if(tempStr == "Ablaufdatum") {
                    haveDateOfExpiry = true
                    dd["Ablaufdatum"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                    let expiryDateString = dd["Ablaufdatum"] as? String ?? ""
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy/MM/dd" // Ensure this matches your date format
                    if let expiryDate = dateFormatter.date(from: expiryDateString) {
                        let now = Date()
                        DispatchQueue.main.async {
                            if expiryDate < now {
                                // Expired
                                self.imgTimer.isHidden = false
                            }
                            else {
                                self.imgTimer.isHidden = true
                                
                            }
                        }
                    }
                }
                
                
                if(tempStr.contains("Nachname und Vornamen")) {
                    userNameString = dataDict[tempStr] as! String
                }
                
                if(tempStr == "Geburtsdatum") {
                    dobString = dataDict[tempStr] as! String
                    
                    dd["Geburtsdatum"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                    
                }
                
                if(tempStr.contains("Adresse")) {
                    addressString = dataDict[tempStr] as! String
                    dd["Adresse"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                
                
                if(tempStr.contains("Geschlecht")) {
                    gender = dataDict[tempStr] as! String
                }
                
                if(tempStr.contains("Alter")) {
                    ageString = dataDict[tempStr] as! String
                }
                if(tempStr == "Dokumentennummer") {
                    documentNumberString = dataDict[tempStr] as! String
                    dd["Dokumentennummer"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr.contains("Ausstellender Staatencode")) {
                    stateCode = dataDict[tempStr] as! String
                }
            }
        }
        else if( currentLanguage.lowercased() == "ku") {
            for j in 0 ..< allKeys.count {
                var tempStr = String()
                tempStr = allKeys[j] as! String
                
                let dd = NSMutableDictionary()
                
                
                if(tempStr == "Nûmra ya Kartê Bankê") {
                    dd["Nûmra ya Kartê Bankê"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                

                if(tempStr == "Yekê din") {
                    dd["Yekê din"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "Kategorî") {
                    dd["Kategorî"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "Dirêjiya Gelavê Kartê Bankê") {
                    dd["Dirêjiya Gelavê Kartê Bankê"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                
                
                if(tempStr == "Netewe") {
                    dd["Netewe"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "Nûmra ya personal") {
                    dd["Nûmra ya personal"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "Roja çêkirinê") {
                    dd["Roja çêkirinê"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "Roja berdanê") {
                    dd["Roja berdanê"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                
                
                
                if(tempStr == "Roja berdanê") {
                    haveDateOfExpiry = true
                    dd["Roja berdanê"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                    let expiryDateString = dd["Roja berdanê"] as? String ?? ""
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy/MM/dd" // Ensure this matches your date format
                    if let expiryDate = dateFormatter.date(from: expiryDateString) {
                        let now = Date()
                        DispatchQueue.main.async {
                            if expiryDate < now {
                                // Expired
                                self.imgTimer.isHidden = false
                            }
                            else {
                                self.imgTimer.isHidden = true
                                
                            }
                        }
                    }
                }
                
                
                if(tempStr.contains("Navê û navên dadê")) {
                    userNameString = dataDict[tempStr] as! String
                }
                
                if(tempStr == "Roja dayîna") {
                    dobString = dataDict[tempStr] as! String
                    
                    dd["Roja dayîna"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                    
                }
                
                if(tempStr.contains("Cihata")) {
                    addressString = dataDict[tempStr] as! String
                    dd["Cihata"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                
                
                if(tempStr.contains("Jin")) {
                    gender = dataDict[tempStr] as! String
                }
                
                if(tempStr.contains("Salbûn")) {
                    ageString = dataDict[tempStr] as! String
                }
                if(tempStr == "Nûmra belgeyê") {
                    documentNumberString = dataDict[tempStr] as! String
                    dd["Nûmra belgeyê"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr.contains("Kodê dewleta weşandina")) {
                    stateCode = dataDict[tempStr] as! String
                }
            }
        }
        else if( currentLanguage.lowercased() == "ckb") {
            for j in 0 ..< allKeys.count {
                var tempStr = String()
                tempStr = allKeys[j] as! String
                
                let dd = NSMutableDictionary()
                
                
                if(tempStr == "ژمارەی کارتی بانک") {
                    dd["ژمارەی کارتی بانک"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                

                if(tempStr == "ئیشتی") {
                    dd["ئیشتی"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "پۆل") {
                    dd["پۆل"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "درێژەی کارتی بانک") {
                    dd["درێژەی کارتی بانک"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                
                
                if(tempStr == "ناساندنی نیشتیمانی") {
                    dd["ناساندنی نیشتیمانی"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "ژمارەی تایبەتی") {
                    dd["ژمارەی تایبەتی"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "بەرواری دابەشکردن") {
                    dd["بەرواری دابەشکردن"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr == "بەرواری بەسەرچوون") {
                    dd["بەرواری بەسەرچوون"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                
                
                
                if(tempStr == "بەرواری بەسەرچوون") {
                    haveDateOfExpiry = true
                    dd["بەرواری بەسەرچوون"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                    let expiryDateString = dd["بەرواری بەسەرچوون"] as? String ?? ""
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy/MM/dd" // Ensure this matches your date format
                    if let expiryDate = dateFormatter.date(from: expiryDateString) {
                        let now = Date()
                        DispatchQueue.main.async {
                            if expiryDate < now {
                                // Expired
                                self.imgTimer.isHidden = false
                            }
                            else {
                                self.imgTimer.isHidden = true
                                
                            }
                        }
                    }
                }
                
                
                if(tempStr.contains("ناو و ناوەکان")) {
                    userNameString = dataDict[tempStr] as! String
                }
                
                if(tempStr == "بەرواری لەدایکبوون") {
                    dobString = dataDict[tempStr] as! String
                    
                    dd["بەرواری لەدایکبوون"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                    
                }
                
                if(tempStr.contains("ناونیشان")) {
                    addressString = dataDict[tempStr] as! String
                    dd["ناونیشان"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                
                
                if(tempStr.contains("جنس")) {
                    gender = dataDict[tempStr] as! String
                }
                
                if(tempStr.contains("تەمەن")) {
                    ageString = dataDict[tempStr] as! String
                }
                if(tempStr == "ژمارەی بەڵگە") {
                    documentNumberString = dataDict[tempStr] as! String
                    dd["ژمارەی بەڵگە"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr.contains("کۆدی وڵاتی بەرەوەبردنەوە")) {
                    stateCode = dataDict[tempStr] as! String
                }
            }
        }
        else {
            for j in 0 ..< allKeys.count {
                var tempStr = String()
                tempStr = allKeys[j] as! String
                
                let dd = NSMutableDictionary()
                
                
                if(tempStr.lowercased() == "bank card number") {
                    dd["Bank card number"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                

                if(tempStr.lowercased() == "other") {
                    dd["Other"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr.lowercased() == "category") {
                    dd["Category"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr.lowercased() == "bank card validity") {
                    dd["Bank card validity"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                
                
                if(tempStr.lowercased() == "nationality") {
                    dd["Nationality"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr.lowercased() == "personal number") {
                    dd["Personal number"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr.lowercased() == "date of issue") {
                    dd["Date of issue"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr.lowercased() == "date of expiry") {
                    dd["Date of expiry"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                
                
                
                if(tempStr.lowercased() == "date of expiry") {
                    haveDateOfExpiry = true
                    dd["Date of expiry"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                    let expiryDateString = dd["Date of expiry"] as? String ?? ""
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy/MM/dd" // Ensure this matches your date format
                    if let expiryDate = dateFormatter.date(from: expiryDateString) {
                        let now = Date()
                        DispatchQueue.main.async {
                            if expiryDate < now {
                                // Expired
                                self.imgTimer.isHidden = false
                            }
                            else {
                                self.imgTimer.isHidden = true
                                
                            }
                        }
                    }
                }
                
                
                if(tempStr.lowercased().contains("surname and given names")) {
                    userNameString = dataDict[tempStr] as! String
                }
                
                if(tempStr.lowercased() == "date of birth") {
                    dobString = dataDict[tempStr] as! String
                    
                    dd["Date of Birth"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                    
                }
                
                if(tempStr.lowercased().contains("address")) {
                    addressString = dataDict[tempStr] as! String
                    dd["Address"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                
                
                if(tempStr.lowercased().contains("sex")) {
                    gender = dataDict[tempStr] as! String
                }
                
                if(tempStr.lowercased().contains("age")) {
                    ageString = dataDict[tempStr] as! String
                }
                if(tempStr.lowercased() == "document number") {
                    documentNumberString = dataDict[tempStr] as! String
                    dd["Document Number"] = dataDict[tempStr] as! String
                    topDataArray.append(dd)
                }
                
                if(tempStr.lowercased().contains("state code")) {
                    stateCode = dataDict[tempStr] as! String
                }
            }
        }
        
        
      
        
        
        
        if(haveDateOfExpiry == false) {
            self.imgTimer.isHidden = true
        }
        
        if(UserLocalStore.shared.haveError != "" || results.textResult.comparisonStatus.rawValue == 0 ) {
            self.imgWarning.image = UIImage(named: "exclamation-mark")
        }
        else {
            self.imgWarning.image = UIImage(named: "status_ok")
        }
        
        
        
      //  imgWarning.isHidden = true
        
        Task {
            await passingData()
        }
        
        
        
        
        
    }
    
    func isEnglishNumber(_ string: String) -> Bool {
        let englishNumberRange = NSRange(location: 0, length: string.utf16.count)
        let englishNumberRegex = try! NSRegularExpression(pattern: "[0-9]*", options: .caseInsensitive)
        return englishNumberRegex.firstMatch(in: string, options: [], range: englishNumberRange) != nil
    }
    
    
    
    func passingData() async {
        userName.text = userNameString
        var temp = ""
        
        if(gender != "") {
            if(gender.lowercased() == "m") {
                temp = "Male"
            }
            else  if(gender.lowercased() == "f") {
                temp = "Female"
            }
            else {
                temp = gender
            }
            userAge.text = temp
            if ageString != ""{
                userAge.text = temp + ", " + "age".localizeString(string: currentLanguage) + ": " + ageString
            }
        }
        else {
            if ageString != ""{
                userAge.text = "age".localizeString(string: currentLanguage) + ": " + ageString
            }
            
        }
        
        profileImg.image = userImage
        
        print("profileImg-=-=-=-=-=",userImage)
        if profileImg.image == nil {
            profileImg.image = UIImage(named: "noUser")
        }
        
        
        
        let eclapsedTime : Int = results?.elapsedTime ?? 0
        let rfidTime : Int = results?.elapsedTimeRFID ?? 0
        
        
        metaDataValues.append(String(eclapsedTime / 1000))
        metaDataValues.append(String(rfidTime / 1000))
        
        
        rfidDataValues.append(String(results.status.detailsRFID.bac.rawValue))
        rfidDataValues.append(String(results.status.detailsRFID.pace.rawValue))
        rfidDataValues.append(String(results.status.detailsRFID.ca.rawValue))
        rfidDataValues.append(String(results.status.detailsRFID.ta.rawValue))
        rfidDataValues.append(String(results.status.detailsRFID.aa.rawValue))
        rfidDataValues.append(String(results.status.detailsRFID.pa.rawValue))
        var isRFIDValue = ""
        for rfidDataValue in rfidDataValues {
            isRFIDValue = rfidDataValue
            
        }
        if isRFIDValue == "2"{
            rFIDChipData = ["bac".localizeString(string: HomeDataManager.shared.languageCodeString),
                            "pace".localizeString(string: HomeDataManager.shared.languageCodeString),
                            "ca".localizeString(string: HomeDataManager.shared.languageCodeString),
                            "ta".localizeString(string: HomeDataManager.shared.languageCodeString),
                            "aa".localizeString(string: HomeDataManager.shared.languageCodeString),
                            "pa".localizeString(string: HomeDataManager.shared.languageCodeString)]
        }else{
            rFIDChipData = ["bac".localizeString(string: HomeDataManager.shared.languageCodeString),
                            "pace".localizeString(string: HomeDataManager.shared.languageCodeString),
                            "ca".localizeString(string: HomeDataManager.shared.languageCodeString),
                            "ta".localizeString(string: HomeDataManager.shared.languageCodeString),
                            "aa".localizeString(string: HomeDataManager.shared.languageCodeString),
                            "pa".localizeString(string: HomeDataManager.shared.languageCodeString)]
        }
        
        
        if(getUserSessionId == "") {
            Loader.hide()
            self.bindDataFUnction()
        }
        else {
            await getLiveImage()
        }
        
        
    }
    
    @objc func ScrollFirstIndex(){
        let indexPath = IndexPath(item: 1, section: 0)
        if indexPath.item < userInfoCollectionVw.numberOfItems(inSection: indexPath.section) {
            userInfoCollectionVw.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    @objc func ScrollSecondIndex(){
        let indexPath = IndexPath(item: 1, section: 0)
        if indexPath.item < userInfoCollectionVw.numberOfItems(inSection: indexPath.section) {
            userInfoCollectionVw.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    
    @objc func ScrollThirdIndex(){
        let indexPath = IndexPath(item: 2, section: 0)
        if indexPath.item < userInfoCollectionVw.numberOfItems(inSection: indexPath.section) {
            userInfoCollectionVw.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    @objc func ScrollFourthIndex(){
        let indexPath = IndexPath(item: 2, section: 0)
        if indexPath.item < userInfoCollectionVw.numberOfItems(inSection: indexPath.section) {
            userInfoCollectionVw.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    
    //MARK: Button Action for Scanning and Liveness
    
    
    @IBAction func actionFaceLiveness(_ sender: Any) {
        isRematching = true
        guard let resultsViewController = self.storyboard?.instantiateViewController(withIdentifier: "StartProcessViewController") as? StartProcessViewController else {
            return
        }
        resultsViewController.results = results
        resultsViewController.modalPresentationStyle = .fullScreen
        self.present(resultsViewController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func actionRFIDScan(_ sender: Any) {
        self.startRFIDReading(results)
    }
    
    
    
    private func startRFIDReading(_ opticalResults: DocumentReaderResults? = nil) {
        
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
            case .error:
                print("Error")
            default:
                break
            }
        })
        
    }
    
    private func showResultScreen(_ resultsData: DocumentReaderResults) {
        if ApplicationSetting.shared.isDataEncryptionEnabled {
            processEncryptedResults(resultsData) { decryptedResult in
                DispatchQueue.main.async {
                    
                    
                    guard let results11 = decryptedResult else {
                        print("Can't decrypt result")
                        return
                    }
                    
                    self.results = results11
                    self.processData()
                    
                }
            }
        } else {
            self.results = resultsData
            self.processData()
        }
    }
    
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
    
    @IBAction func actionSendMessage(_ sender: Any) {
        let path = DocReader.shared.processParams.sessionLogFolder
        print("Path: \(path ?? "nil")")
    }
    
    
    
}

//MARK: UICollectionView Delegate and Datasource Method

extension UserInfoVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if scanningIndex == 0 {
            if UserLocalStore.shared.Liveness == true || UserLocalStore.shared.FaceMatching == true{
                return numOfPagesFullProcessing.count
            }else{
                return numOfPagesforAll.count
            }
            
        }else if scanningIndex == 3 {
            return numOfPagesFullProcessing.count
        }else{
            return numOfPagesforAll.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        if scanningIndex == 0 {
            if UserLocalStore.shared.FaceMatching == true || UserLocalStore.shared.Liveness == true {
                if indexPath.row == 0 {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCardCollectionCell", for: indexPath) as! UserCardCollectionCell
                    
                    cell.lblcardType.text = documentName
                    cell.cardImg = imagesArray.reversed()
                    cell.dataArray = topDataArray
                    
                    
                    return cell
                    
                }
                
                else if indexPath.row == 1 {
                    
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserDetailCollectionCell", for: indexPath) as! UserDetailCollectionCell
                    cell.resultsDataValues = results
                    cell.newsections = newsectionsData
                    cell.isMrz = documentisMrz
                    
                    
                    return cell
                }
                else if indexPath.row == 2 {
                    
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserProfileCollectionCell", for: indexPath) as! UserProfileCollectionCell
                    
                    if handleUserFacematchingIcon == "0"{
                        cell.hideVwHyt.constant = 0
                        cell.hideView.isHidden = true
                        cell.veiwhideshowliveness.isHidden = true
                        cell.lblFaceMatching.isHidden = true
                    }else{
                        cell.hideVwHyt.constant = 200
                        cell.hideView.isHidden = false
                        cell.veiwhideshowliveness.isHidden = false
                        cell.lblFaceMatching.isHidden = false
                    }
                    
                    if handleUserLivenessIcon == "0"{
                        
                    }else{
                        cell.lblLiveness.isHidden = false
                    }
                    
                    cell.documentImg.image =  userImage
                    
                    if let decodedData = Data(base64Encoded: userLiveImageString, options: .ignoreUnknownCharacters) {
                        let image = UIImage(data: decodedData)
                        cell.capturedImg.image = image
                        let stringValue =  "\(String(format: "%.2f", Double(liveImageConfidenceValue)))"
                        
                        
                        cell.nfcImg1.image = rfidUserImage
                        cell.nfcImg2.image = image
                        
                        
                        // Move to center
                        // Face matching score:
                        
                        
                        if handleUserLivenessIcon == "1" || handleUserLivenessIcon == "2"  {
                            cell.lblLiveness.text = "liveness_score".localizeString(string: HomeDataManager.shared.languageCodeString) + " " + stringValue + "%"
                        }
                        else {
                            cell.lblLiveness.isHidden = true
                        }
                        
                        
                        cell.viewbarcodeDropdown.isHidden = true
                        
                        
                        let faveMatchingVal =  "\(String(format: "%.2f", Double(faceMatching)))"
                        
                        if handleUserFacematchingIcon == "1" || handleUserFacematchingIcon == "2"   {
                            cell.lblFaceMatching.text = "face_matching_score".localizeString(string: HomeDataManager.shared.languageCodeString) + " " + faveMatchingVal + "%"
                        }
                        else {
                            cell.lblFaceMatching.isHidden = true
                        }
                    }
                    
                    if (self.faceMatching >= 80) {
                        cell.comparisoncheckBtn.setImage(UIImage(named: "status_ok"), for: .normal)
                        cell.cameraImgCheckBtn.setImage(UIImage(named: "status_ok"), for: .normal)
                    }  
                    else {
                        cell.comparisoncheckBtn.setImage(UIImage(named: "status_not_ok"), for: .normal)
                        cell.cameraImgCheckBtn.setImage(UIImage(named: "status_not_ok"), for: .normal)
                    }
                    
                    
                    if(haveRfidImage == true) {
                        cell.lblNfcFaceMatchingScore.isHidden = false
                        cell.nfcDetailVw.isHidden = false
                        cell.nfcScoreVw.isHidden = false
                        if (self.rfidMatchingValue >= 80) {
                            cell.nfcFaceMatchingScoreBtn.setImage(UIImage(named: "status_ok"), for: .normal)
                        }
                        else {
                            cell.nfcFaceMatchingScoreBtn.setImage(UIImage(named: "status_not_ok"), for: .normal)
                        }
                        let faveMatchingVal =  "\(String(format: "%.2f", Double(rfidMatchingValue)))"
                        cell.lblNfcFaceMatchingScore.text = "Face Matching Score(RFID): " + faveMatchingVal + "%"
                    }
                    else {
                        cell.nfcDetailVwHyt.constant = 0
                        cell.lblNfcFaceMatchingScore.isHidden = true
                        cell.nfcDetailVw.isHidden = true
                        cell.nfcScoreVw.isHidden = true
                        cell.nfcScoreVwHyt.constant = 0
                    }
                    
                   
                    
                    
                    return cell
                    
                }
                else {
                    
                    
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserVerificationCell", for: indexPath) as! UserVerificationCell
                    
                    cell.faceLiveness = handleUserLivenessIcon
                    cell.faceMatching = handleUserFacematchingIcon
                    cell.resultsDataValues = results
                    cell.metaDataValues = metaDataValues
                    cell.rfidValues = rfidDataValues
                    cell.rFIDdata = rFIDChipData
                    cell.rfidProcessedOrNot = String(results.status.rfid.rawValue)
                    
                    
                    return cell
                    
                }
                
            }else{
                if indexPath.row == 0 {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCardCollectionCell", for: indexPath) as! UserCardCollectionCell
                    
                    cell.lblcardType.text = documentName
                    cell.cardImg = imagesArray.reversed()
                    cell.dataArray = topDataArray
                    
                    
                    
                    return cell
                    
                }
                
                else if indexPath.row == 1 {
                    
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserDetailCollectionCell", for: indexPath) as! UserDetailCollectionCell
                    cell.resultsDataValues = results
                    cell.newsections = newsectionsData
                    cell.isMrz = documentisMrz
                    
                    
                    return cell
                }
                else {
                    
                    
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserVerificationCell", for: indexPath) as! UserVerificationCell
                    
                    cell.faceLiveness = handleUserLivenessIcon
                    cell.faceMatching = handleUserFacematchingIcon
                    cell.resultsDataValues = results
                    cell.metaDataValues = metaDataValues
                    cell.rfidValues = rfidDataValues
                    cell.rFIDdata = rFIDChipData
                    cell.rfidProcessedOrNot = String(results.status.rfid.rawValue)
                    
                    
                    return cell
                    
                }
                
            }
            
            
        }
        else if scanningIndex == 3 {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCardCollectionCell", for: indexPath) as! UserCardCollectionCell
                
                cell.lblcardType.text = documentName
                cell.cardImg = imagesArray.reversed()
                cell.dataArray = topDataArray
                
                return cell
                
            }else if indexPath.row == 1 {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserDetailCollectionCell", for: indexPath) as! UserDetailCollectionCell
                cell.resultsDataValues = results
                cell.newsections = newsectionsData
                cell.isMrz = documentisMrz
                
                
                return cell
            }else if indexPath.row == 2 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserProfileCollectionCell", for: indexPath) as! UserProfileCollectionCell
                
                cell.viewlivenessScore.isHidden = true
                cell.hideView.isHidden = true
                cell.veiwhideshowliveness.isHidden = true
                
                cell.viewbarcodeDropdown.isHidden = false
                
                cell.bardcodeImg.image =  imagesArray[0]
                
                
                return cell
                
            } else {
                
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserVerificationCell", for: indexPath) as! UserVerificationCell
                
                cell.faceLiveness = handleUserLivenessIcon
                cell.faceMatching = handleUserFacematchingIcon
                cell.resultsDataValues = results
                cell.metaDataValues = metaDataValues
                cell.rfidValues = rfidDataValues
                cell.rFIDdata = rFIDChipData
                cell.rfidProcessedOrNot = String(results.status.rfid.rawValue)
                
                
                return cell
                
            }
        }else {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCardCollectionCell", for: indexPath) as! UserCardCollectionCell
                
                cell.lblcardType.text = documentName
                cell.cardImg = imagesArray.reversed()
                cell.dataArray = topDataArray
                
                
                return cell
                
            }else if indexPath.row == 1 {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserDetailCollectionCell", for: indexPath) as! UserDetailCollectionCell
                cell.resultsDataValues = results
                cell.newsections = newsectionsData
                cell.isMrz = documentisMrz
                
                
                return cell
            }else {
                
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserVerificationCell", for: indexPath) as! UserVerificationCell
                
                cell.faceLiveness = handleUserLivenessIcon
                cell.faceMatching = handleUserFacematchingIcon
                cell.resultsDataValues = results
                cell.metaDataValues = metaDataValues
                cell.rfidValues = rfidDataValues
                cell.rFIDdata = rFIDChipData
                cell.rfidProcessedOrNot = String(results.status.rfid.rawValue)
                
                
                return cell
                
            }
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
            let index = scrollView.contentOffset.x / witdh
            let roundedIndex = round(index)
            self.pageController?.currentPage = Int(roundedIndex)
        }
        
    }
    
    
    func faceMatchingApi(liveImage : String) {
        guard let apiURL = URL(string: "https://plusapi.ipass-mena.com/api/v1/aws/face/maching") else { return }
        
        var parameters: [String: Any] = [:]
        
        if let imageData1 = userImage.pngData() {
            let base64String1 = imageData1.base64EncodedString()
            parameters["sourceImageBase64"] = base64String1
        } else {
            print("Error converting first image to Data")
        }
        parameters["targetImageBase64"] = liveImage
        
        
        
        
        AF.request(apiURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders(["Content-Type": "application/json"]))
            .responseJSON { response in
                
                let status = response.response?.statusCode
                print(response.result)
                
                if(status == 201) {
                    print(response)
                    
                    print(response.result)
                    
                    if let value = response.value as? [String: AnyObject] {
                        print(value)
                        print((value["data"] as! NSDictionary) ["facePercentage"] as Any)
                        
                        let anyValue: Any = (value["data"] as! NSDictionary) ["facePercentage"] as Any
                        
                        print("facePercentage",anyValue)
                        
                        self.faceMatching = anyValue as? Double ?? 0.0
                    }
                    
                    
                    if(self.haveRfidImage == true) {
                        self.rfidMatchingApi(liveImage: liveImage)
                    }
                    else {
                        Loader.hide()
                        self.bindDataFUnction()
                    }
                  
                }
                else {
                    Loader.hide()
                    self.bindDataFUnction()
                    
                }
                
                
            }
    }
    
    
    func rfidMatchingApi(liveImage : String) {
        guard let apiURL = URL(string: "https://plusapi.ipass-mena.com/api/v1/aws/face/maching/byrfid") else { return }
        
        var parameters: [String: Any] = [:]
        
        if let imageData1 = rfidUserImage.pngData() {
            let base64String1 = imageData1.base64EncodedString()
            parameters["sourceImageBaseRfid"] = base64String1
        } else {
            print("Error converting first image to Data")
        }
        parameters["targetImageBase64"] = liveImage
        
        
        
        
        AF.request(apiURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders(["Content-Type": "application/json"]))
            .responseJSON { response in
                
                let status = response.response?.statusCode
                print(response.result)
                
                if(status == 201) {
                    print(response)
                    
                    print(response.result)
                    
                    if let value = response.value as? [String: AnyObject] {
                        print(value)
                        print((value["data"] as! NSDictionary) ["facePercentageWithRFID"] as Any)
                        
                        let anyValue: Any = (value["data"] as! NSDictionary) ["facePercentageWithRFID"] as Any
                        
                        print("facePercentageWithRFID",anyValue)
                        
                        self.rfidMatchingValue = anyValue as? Double ?? 0.0
                    }
                    
                    Loader.hide()
                    self.bindDataFUnction()
                }
                else {
                    Loader.hide()
                    self.bindDataFUnction()
                    
                }
                
                
            }
    }
    
    
}
//    MARK: - UICollection VIew Delegate Flow Layouts

extension UserInfoVC: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionwidth = collectionView.bounds.width
        let heights = collectionView.bounds.height
        return CGSize(width: collectionwidth / 1, height: heights / 1)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
                       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
        
    }
    
}

extension UIImageView {
    func loadImageFromUrl(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
extension UIApplication {
    var keyWindow: UIWindow? {
        return connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
