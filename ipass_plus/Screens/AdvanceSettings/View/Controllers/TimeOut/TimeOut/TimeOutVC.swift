//
//  TimeOutVC.swift
//  ipass_plus
//
//  Created by Mobile on 06/02/24.
//

import UIKit

class TimeOutVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textfieldHyt: NSLayoutConstraint!
    @IBOutlet weak var textfieldTop: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfEnterValue: UITextField!

    var commingFrom:String = ""
    var value:String = ""
    var placeHolderValue:String = ""
    var isCustomParams:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
       print(UserLocalStore.shared.ZoomLevel)
        gettingSaveData()
        tfEnterValue.layer.cornerRadius = 15
        tfEnterValue.delegate = self
        
        setScreenHeading()
//        tfEnterValue.text = value
        tfEnterValue.attributedPlaceholder = NSAttributedString(string: placeHolderValue,attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        if isCustomParams == true {
            tfEnterValue.keyboardType = .default
            textfieldHyt.constant = 150
        }
        
        tfEnterValue.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func setScreenHeading() {
        if commingFrom == "Timeout"{
            lblTitle.text = "timeout".localizeString(string: HomeDataManager.shared.languageCodeString)
        }
        else if commingFrom == "Timeout starting from document detection"{
            lblTitle.text = "timeout_detection".localizeString(string: HomeDataManager.shared.languageCodeString)
        }
        
        else if commingFrom == "Timeout starting from document type identification"{
            lblTitle.text = "timeout_identification".localizeString(string: HomeDataManager.shared.languageCodeString)
        }
        
        else if commingFrom == "Zoom Level"{
            lblTitle.text = "zoom_level".localizeString(string: HomeDataManager.shared.languageCodeString)
        }
        else if commingFrom == "Minimum DPI"{
            lblTitle.text = "minimum_dpi".localizeString(string: HomeDataManager.shared.languageCodeString)
        }
        else if commingFrom == "Perspective angle"{
            lblTitle.text = "perspective_angle".localizeString(string: HomeDataManager.shared.languageCodeString)
        }
        else if commingFrom == "Document filter"{
            lblTitle.text = "document_filter".localizeString(string: HomeDataManager.shared.languageCodeString)
       }
        
        else if commingFrom == "Custom parameters"{
            lblTitle.text = "custom_parameters".localizeString(string: HomeDataManager.shared.languageCodeString)
        }
       
        else if commingFrom == "DPI threshold"{
            lblTitle.text = "dpi_threshold".localizeString(string: HomeDataManager.shared.languageCodeString)
        }
        else if commingFrom == "Angle threshold"{
            lblTitle.text = "angle_threshold".localizeString(string: HomeDataManager.shared.languageCodeString)
        }
        else if commingFrom == "Document position: Indent"{
            lblTitle.text = "document_position".localizeString(string: HomeDataManager.shared.languageCodeString)
        }
        else if commingFrom == "Data access key"{
            lblTitle.text = "access_key".localizeString(string: HomeDataManager.shared.languageCodeString)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tfEnterValue.becomeFirstResponder()
        gettingSaveData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        checkCommingFrom()
    }
    
    func checkCommingFrom(){
        if commingFrom == "Timeout"{
        UserLocalStore.shared.TimeOut = tfEnterValue.text ?? ""
        }
        else if commingFrom == "Timeout starting from document detection"{
        UserLocalStore.shared.TimeOutDocumentDetection = tfEnterValue.text ?? ""
        }
        
        else if commingFrom == "Timeout starting from document type identification"{
        UserLocalStore.shared.TimeOutDocumentIdentification = tfEnterValue.text ?? ""
        }
        
        else if commingFrom == "Zoom Level"{
        UserLocalStore.shared.ZoomLevel = tfEnterValue.text ?? ""
        }
        else if commingFrom == "Minimum DPI"{
        UserLocalStore.shared.MinimumDPI = tfEnterValue.text ?? ""
        }
        else if commingFrom == "Perspective angle"{
        UserLocalStore.shared.PerspectiveAngle = tfEnterValue.text ?? ""
        }
        else if commingFrom == "Document filter"{
         UserLocalStore.shared.DocumentFilter = tfEnterValue.text ?? ""
       }
        else if commingFrom == "Custom parameters"{
        UserLocalStore.shared.CustomParameters = tfEnterValue.text ?? ""
        }else if commingFrom == "DPI threshold"{
        UserLocalStore.shared.DPIThreshold = tfEnterValue.text ?? ""
        }
        else if commingFrom == "Angle threshold"{
        UserLocalStore.shared.AngleThreshold = tfEnterValue.text ?? ""
        }
        else if commingFrom == "Document position: Indent"{
        UserLocalStore.shared.DocumentPositionIndent = tfEnterValue.text ?? ""
        }
        else if commingFrom == "Data access key"{
            UserLocalStore.shared.DataAccessKeyValue = tfEnterValue.text ?? ""
        }
        
    }

    
    func gettingSaveData(){
        if commingFrom == "Timeout"{
         tfEnterValue.text = UserLocalStore.shared.TimeOut
        }else if commingFrom == "Timeout starting from document detection"{
        tfEnterValue.text =  UserLocalStore.shared.TimeOutDocumentDetection
        }else if commingFrom == "Timeout starting from document type identification"{
        tfEnterValue.text = UserLocalStore.shared.TimeOutDocumentIdentification
        }else if commingFrom == "Zoom Level"{
        tfEnterValue.text = UserLocalStore.shared.ZoomLevel
        }else if commingFrom == "Minimum DPI"{
       tfEnterValue.text =  UserLocalStore.shared.MinimumDPI
        }else if commingFrom == "Perspective angle"{
        tfEnterValue.text = UserLocalStore.shared.PerspectiveAngle
        }else if commingFrom == "Document filter"{
        tfEnterValue.keyboardType = .numbersAndPunctuation
        tfEnterValue.text =  UserLocalStore.shared.DocumentFilter
       }else if commingFrom == "Custom parameters"{
        tfEnterValue.text = UserLocalStore.shared.CustomParameters
        }else if commingFrom == "DPI threshold"{
        tfEnterValue.text = UserLocalStore.shared.DPIThreshold
        }else if commingFrom == "Angle threshold"{
        tfEnterValue.text = UserLocalStore.shared.AngleThreshold
        }else if commingFrom == "Document position: Indent"{
        tfEnterValue.text = UserLocalStore.shared.DocumentPositionIndent
        }else if commingFrom == "Data access key"{
       tfEnterValue.text =  UserLocalStore.shared.DataAccessKeyValue
            }
    }
    

    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            if commingFrom == "Zoom Level" {
                let enterData = Int(text) ?? 0
                if enterData > 10 || enterData < 1 {
                    Alert.shared.displayMyAlertMessage(title: "", message: "Minimum value is 1 and Maximum value is 10 ", actionTitle: "Ok") {
                        print("")
                    }
                }
            }else if commingFrom == "Minimum DPI" {
                let enterData = Int(text) ?? 0
                if enterData > 100 || enterData < 90 {
                    Alert.shared.displayMyAlertMessage(title: "", message: "Minimum value is 90 and Maximum value is 100 ", actionTitle: "Ok") {
                        print("")
                    }
                }
            }
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
