//
//  LocalStoreClass.swift
//  ipass_plus
//
//  Created by MOBILE on 29/02/24.
//

import Foundation


class UserLocalStore{
    
    static let shared = UserLocalStore()
    
    
    var clickedIndex = 0
    var haveError = ""
    var documentMisMatch = false
    var haveNFCChip = false
    var allowTransaction = false
    
    // MARK: User defaults keys
    
    let defaults = UserDefaults.standard
    let RFaceMatching = "FaceMatching"
    let RLiveness = "Liveness"
    let RMultipageProcessing = "MultipageProcessing"
    let RDoublePageSpreadProcessing = "DoublePageSpreadProcessing"
    let ReRFIDChipProcessing = "RFIDChipProcessing"
    let RVibration = "Vibration"
    let RCaptureButton = "CaptureButton"
    let RCameraSwitchButton = "CameraSwitchButton"
    let RHintMessages = "HintMessages"
    let RHelp = "Help"
    let RMotionDetection = "MotionDetection"
    let RFocusingDetection = "FocusingDetection"
    let RAdiustZoomLevel = "AdiustZoomLevel"
    let RManualCrop = "ManualCrop"
    let RIntegralImage = "IntegralImage"
    let RHologramDetection = "HologramDetection"
    let RSaveEventLogs = "SaveEventLogs"
    let RSaveImages = "SaveImages"
    let RSaveCroppedImages = "SaveCroppedImages"
    let RSaveRFIDSession = "SaveRFIDSession"
    let RShowMetadata = "ShowMetadata"
    let RShowCompleteListOfScenarios = "ShowCompleteListOfScenarios"
    let RImgColor = "ImgColor"
    let RImgGlares = "ImgGlares"
    let RImgFocus = "ImgFocus"
    let RPriorityUsingDSCertificates = "PriorityUsingDSCertificates"
    let RUseExternalCSCACertificates = "UseExternalCSCACertificates"
    let RTrustPKDCertificates = "TrustPKDCertificates"
    let RPassiveAuthentication = "PassiveAuthentication"
    let RPerformAAAfterCA = "PerformAAAfterCA"
    let RStrictISOProtocol = "StrictISOProtocol"
    let RReadEPassport = "ReadEPassport"
    let RMachineReadableZone = "MachineReadableZone"
    let RBiometry_FacialData = "Biometry_FacialData"
    let RBiometry_Fingerprints = "Biometry_Fingerprints"
    let RBiometry_IrisData = "Biometry_IrisData"
    let RPortrait = "Portrait"
    let RNotDefinedDG6 = "NotDefinedDG6"
    let RSignatureUsualMarkImage = "SignatureUsualMarkImage"
    let RNotDefinedDG8 = "NotDefinedDG8"
    let RNotDefinedDG9 = "NotDefinedDG9"
    let RNotDefinedDG10 = "NotDefinedDG10"
    let RAdditionalPersonalDetail = "AdditionalPersonalDetail"
    let RAdditionalDocumentDetail = "AdditionalDocumentDetail"
    let ROptionalDetail = "OptionalDetail"
    let REACInfo = "EACInfo"
    let RActiveAuthenticationInfo = "ActiveAuthenticationInfo"
    let RPersonToNotify = "PersonToNotify"
    let RReadElD = "ReadElD"
    let RDocumentType = "DocumentType"
    let RIssuingState = "IssuingState"
    let RDateOfExpiry = "DateOfExpiry"
    let RGivenName = "GivenName"
    let RFamilyName = "FamilyName"
    let RPseudonym = "Pseudonym"
    let RAcademicTitle = "AcademicTitle"
    let RDateOfBirth = "DateOfBirth"
    let RPlaceOfBirth = "PlaceOfBirth"
    let RNationality = "Nationality"
    let RSex = "Sex"
    let ROptionalDetailsDG12 = "OptionalDetailsDG12"
    let RUndefinedDG13 = "UndefinedDG13"
    let RUndefinedDG14 = "UndefinedDG14"
    let RUndefinedDG15 = "UndefinedDG15"
    let RUndefinedDG16 = "UndefinedDG16"
    let RPlaceOfRegistrationDG17 = "PlaceOfRegistrationDG17"
    let RPlaceOfRegistrationDG18 = "PlaceOfRegistrationDG18"
    let RResidencePermit1DG19 = "ResidencePermit1DG19"
    let RResidencePermit2DG20 = "ResidencePermit2DG20"
    let ROptionalDetailsDG21 = "OptionalDetailsDG21"
    let RReadEDL = "ReadEDL"
    let RTextDataElementsDG1 = "TextDataElementsDG1"
    let RLicenseHolderInformationDG2 = "LicenseHolderInformationDG2"
    let RIssuingAuthorityDetailsDG3 = "IssuingAuthorityDetailsDG3"
    let RPortraitImageDG4 = "PortraitImageDG4"
    let RSignatureUsualMarkImageDG5 = "SignatureUsualMarkImageDG5"
    let RBiometry_FacialDataDG6 = "Biometry_FacialDataDG6"
    let RBiometry_FingerprintDG7 = "Biometry_FingerprintDG7"
    let RBiometry_IrisDataDG8 = "Biometry_IrisDataDG8"
    let RBiometry_OtherDG9 = "Biometry_OtherDG9"
    let REDL_NotDefinedDG10 = "EDL_NotDefinedDG10"
    let ROptionalDomesticDataDG11 = "OptionalDomesticDataDG11"
    let RNon_MatchAlertDG12 = "Non_MatchAlertDG12"
    let RActiveAuthenticationInfoDG13 = "ActiveAuthenticationInfoDG13"
    let REACInfoDG14 = "EACInfoDG14"
    let RSoundEnabled = "SoundEnabled"
    let RSelectedSound = "SelectedSound"
    let RTimeOut = "TimeOut"
    let RTimeOutDocumentDetection = "TimeOutDocumentDetection"
    let RTimeOutDocumentIdentification = "TimeOutDocumentIdentification"
    let RZoomLevel = "ZoomLevel"
    let RMinimumDPI = "MinimumDPI"
    let RPerspectiveAngle = "PerspectiveAngle"
    let RDocumentFilter = "DocumentFilter"
    let RCustomParameters = "CustomParameters"
    let RProcessingModes = "ProcessingModes"
    let RCameraResolution = "CameraResolution"
    let RDateFormat = "DateFormat"
    let RDPIThreshold = "DPIThreshold"
    let RAngleThreshold = "AngleThreshold"
    let RDocumentPositionIndent = "DocumentPositionIndent"
    let RAuthenticationProcedureType = "AuthenticationProcedureType"
    let RBasicSecurityMessagingProcedure = "BasicSecurityMessagingProcedure"
    let RDataAccesKey = "DataAccesKey"
    let RAuthDataAccesKey = "AuthDataAccesKey"
    let RDataAccessKeyValue = "DataAccessKeyValue"
    let RProfilerType = "ProfilerType"
    

    
    func resetAllData(){
        defaults.removeObject(forKey: RFaceMatching)
        defaults.removeObject(forKey: RLiveness)
        defaults.removeObject(forKey: RMultipageProcessing)
        defaults.removeObject(forKey: RDoublePageSpreadProcessing)
        defaults.removeObject(forKey: ReRFIDChipProcessing)
        defaults.removeObject(forKey: RVibration)
        defaults.removeObject(forKey: RCaptureButton)
        defaults.removeObject(forKey: RCameraSwitchButton)
        defaults.removeObject(forKey: RHintMessages)
        defaults.removeObject(forKey: RHelp)
        defaults.removeObject(forKey: RMotionDetection)
        defaults.removeObject(forKey: RFocusingDetection)
        defaults.removeObject(forKey: RAdiustZoomLevel)
        defaults.removeObject(forKey: RManualCrop)
        defaults.removeObject(forKey: RIntegralImage)
        defaults.removeObject(forKey: RHologramDetection)
        defaults.removeObject(forKey: RSaveEventLogs)
        defaults.removeObject(forKey: RSaveImages)
        defaults.removeObject(forKey: RSaveCroppedImages)
        defaults.removeObject(forKey: RSaveRFIDSession)
        defaults.removeObject(forKey: RShowMetadata)
        defaults.removeObject(forKey: RShowCompleteListOfScenarios)
        defaults.removeObject(forKey: RImgColor)
        defaults.removeObject(forKey: RImgGlares)
        defaults.removeObject(forKey: RImgFocus)
        defaults.removeObject(forKey: RPriorityUsingDSCertificates)
        defaults.removeObject(forKey: RUseExternalCSCACertificates)
        defaults.removeObject(forKey: RTrustPKDCertificates)
        defaults.removeObject(forKey: RPassiveAuthentication)
        defaults.removeObject(forKey: RPerformAAAfterCA)
        defaults.removeObject(forKey: RStrictISOProtocol)
        defaults.removeObject(forKey: RReadEPassport)
        defaults.removeObject(forKey: RMachineReadableZone)
        defaults.removeObject(forKey: RBiometry_FacialData)
        defaults.removeObject(forKey: RBiometry_Fingerprints)
        defaults.removeObject(forKey: RBiometry_IrisData)
        defaults.removeObject(forKey: RPortrait)
        defaults.removeObject(forKey: RNotDefinedDG6)
        defaults.removeObject(forKey: RSignatureUsualMarkImage)
        defaults.removeObject(forKey: RNotDefinedDG8)
        defaults.removeObject(forKey: RNotDefinedDG9)
        defaults.removeObject(forKey: RNotDefinedDG10)
        defaults.removeObject(forKey: RAdditionalPersonalDetail)
        defaults.removeObject(forKey: RAdditionalDocumentDetail)
        defaults.removeObject(forKey: ROptionalDetail)
        defaults.removeObject(forKey: REACInfo)
        defaults.removeObject(forKey: RActiveAuthenticationInfo)
        defaults.removeObject(forKey: RPersonToNotify)
        defaults.removeObject(forKey: RReadElD)
        defaults.removeObject(forKey: RDocumentType)
        defaults.removeObject(forKey: RIssuingState)
        defaults.removeObject(forKey: RDateOfExpiry)
        defaults.removeObject(forKey: RGivenName)
        defaults.removeObject(forKey: RFamilyName)
        defaults.removeObject(forKey: RPseudonym)
        defaults.removeObject(forKey: RAcademicTitle)
        defaults.removeObject(forKey: RDateOfBirth)
        defaults.removeObject(forKey: RPlaceOfBirth)
        defaults.removeObject(forKey: RNationality)
        defaults.removeObject(forKey: RSex)
        defaults.removeObject(forKey: ROptionalDetailsDG12)
        defaults.removeObject(forKey: RUndefinedDG13)
        defaults.removeObject(forKey: RUndefinedDG14)
        defaults.removeObject(forKey: RUndefinedDG15)
        defaults.removeObject(forKey: RUndefinedDG16)
        defaults.removeObject(forKey: RPlaceOfRegistrationDG17)
        defaults.removeObject(forKey: RPlaceOfRegistrationDG18)
        defaults.removeObject(forKey: RResidencePermit1DG19)
        defaults.removeObject(forKey: RResidencePermit2DG20)
        defaults.removeObject(forKey: ROptionalDetailsDG21)
        defaults.removeObject(forKey: RReadEDL)
        defaults.removeObject(forKey: RTextDataElementsDG1)
        defaults.removeObject(forKey: RLicenseHolderInformationDG2)
        defaults.removeObject(forKey: RIssuingAuthorityDetailsDG3)
        defaults.removeObject(forKey: RPortraitImageDG4)
        defaults.removeObject(forKey: RSignatureUsualMarkImageDG5)
        defaults.removeObject(forKey: RBiometry_FacialDataDG6)
        defaults.removeObject(forKey: RBiometry_FingerprintDG7)
        defaults.removeObject(forKey: RBiometry_IrisDataDG8)
        defaults.removeObject(forKey: RBiometry_OtherDG9)
        defaults.removeObject(forKey: REDL_NotDefinedDG10)
        defaults.removeObject(forKey: ROptionalDomesticDataDG11)
        defaults.removeObject(forKey: RNon_MatchAlertDG12)
        defaults.removeObject(forKey: RActiveAuthenticationInfoDG13)
        defaults.removeObject(forKey: REACInfoDG14)
        defaults.removeObject(forKey: RSoundEnabled)
        defaults.removeObject(forKey: RSelectedSound)
        defaults.removeObject(forKey: RTimeOut)
        defaults.removeObject(forKey: RTimeOutDocumentDetection)
        defaults.removeObject(forKey: RTimeOutDocumentIdentification)
        defaults.removeObject(forKey: RZoomLevel)
        defaults.removeObject(forKey: RMinimumDPI)
        defaults.removeObject(forKey: RPerspectiveAngle)
        defaults.removeObject(forKey: RDocumentFilter)
        defaults.removeObject(forKey: RCustomParameters)
        defaults.removeObject(forKey: RProcessingModes)
        defaults.removeObject(forKey: RCameraResolution)
        defaults.removeObject(forKey: RDateFormat)
        defaults.removeObject(forKey: RDPIThreshold)
        defaults.removeObject(forKey: RAngleThreshold)
        defaults.removeObject(forKey: RDocumentPositionIndent)
        defaults.removeObject(forKey: RAuthenticationProcedureType)
        defaults.removeObject(forKey: RBasicSecurityMessagingProcedure)
        defaults.removeObject(forKey: RDataAccesKey)
        defaults.removeObject(forKey: RAuthDataAccesKey)
        defaults.removeObject(forKey: RDataAccessKeyValue)
        defaults.removeObject(forKey: RProfilerType)
    }

    
    // MARK: Setting
    
    var FaceMatching :Bool {
        get {
            return UserDefaults.standard.value(forKey: "FaceMatching") as? Bool ?? true
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "FaceMatching")
        }
    }
    
    var TutorialViewed :Bool {
        get {
            return UserDefaults.standard.value(forKey: "tutorialViewed") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "tutorialViewed")
        }
    }
    
    
    var DataBaseDownloaded :Bool {
        get {
            return UserDefaults.standard.value(forKey: "dataBaseDownloaded") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "dataBaseDownloaded")
        }
    }
    
    var Liveness :Bool {
        get {
            return UserDefaults.standard.value(forKey: "Liveness") as? Bool ?? true
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "Liveness")
        }
    }
  
    var MultipageProcessing :Bool {
        get {
            return UserDefaults.standard.value(forKey: "MultipageProcessing") as? Bool ?? true
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "MultipageProcessing")
        }
    }
    
    var DoublePageSpreadProcessing :Bool {
        get {
            return UserDefaults.standard.value(forKey: "DoublePageSpreadProcessing") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "DoublePageSpreadProcessing")
        }
    }
    
    var RFIDChipProcessing :Bool {
        get {
            return UserDefaults.standard.value(forKey: "RFIDChipProcessing") as? Bool ?? true
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "RFIDChipProcessing")
        }
    }
    
    var Vibration :Bool {
        get {
            return UserDefaults.standard.value(forKey: "Vibration") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "Vibration")
        }
    }
    
    // MARK: Advance Setting
    
    var CaptureButton :Bool {
        get {
            return UserDefaults.standard.value(forKey: "CaptureButton") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "CaptureButton")
        }
    }
    
    var CameraSwitchButton :Bool {
        get {
            return UserDefaults.standard.value(forKey: "CameraSwitchButton") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "CameraSwitchButton")
        }
    }
    
    var HintMessages :Bool {
        get {
            return UserDefaults.standard.value(forKey: "HintMessages") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "HintMessages")
        }
    }
    
    var Help :Bool {
        get {
            return UserDefaults.standard.value(forKey: "Help") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "Help")
        }
    }
    
    var MotionDetection :Bool {
        get {
            return UserDefaults.standard.value(forKey: "MotionDetection") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "MotionDetection")
        }
    }
    
    var FocusingDetection :Bool {
        get {
            return UserDefaults.standard.value(forKey: "FocusingDetection") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "FocusingDetection")
        }
    }
    
    var AdiustZoomLevel :Bool {
        get {
            return UserDefaults.standard.value(forKey: "AdiustZoomLevel") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "AdiustZoomLevel")
        }
    }
    
    var ManualCrop :Bool {
        get {
            return UserDefaults.standard.value(forKey: "ManualCrop") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ManualCrop")
        }
    }
    
    var IntegralImage :Bool {
        get {
            return UserDefaults.standard.value(forKey: "IntegralImage") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "IntegralImage")
        }
    }
    
    var HologramDetection :Bool {
        get {
            return UserDefaults.standard.value(forKey: "HologramDetection") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "HologramDetection")
        }
    }
    
    // MARK: Debug Setting
    
    var SaveEventLogs :Bool {
        get {
            return UserDefaults.standard.value(forKey: "SaveEventLogs") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "SaveEventLogs")
        }
    }
    
    var SaveImages :Bool {
        get {
            return UserDefaults.standard.value(forKey: "SaveImages") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "SaveImages")
        }
    }
    
    var SaveCroppedImages :Bool {
        get {
            return UserDefaults.standard.value(forKey: "SaveCroppedImages") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "SaveCroppedImages")
        }
    }
   
    var SaveRFIDSession :Bool {
        get {
            return UserDefaults.standard.value(forKey: "SaveRFIDSession") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "SaveRFIDSession")
        }
    }
    
    var ShowMetadata :Bool {
        get {
            return UserDefaults.standard.value(forKey: "ShowMetadata") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ShowMetadata")
        }
    }
    
    var ShowCompleteListOfScenarios :Bool {
        get {
            return UserDefaults.standard.value(forKey: "ShowCompleteListOfScenarios") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ShowCompleteListOfScenarios")
        }
    }
    
    
    // MARK: Image Quality
    
    var ImgColor :Bool {
        get {
            return UserDefaults.standard.value(forKey: "ImgColor") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ImgColor")
        }
    }
    
    var ImgGlares :Bool {
        get {
            return UserDefaults.standard.value(forKey: "ImgGlares") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ImgGlares")
        }
    }
    
    var ImgFocus :Bool {
        get {
            return UserDefaults.standard.value(forKey: "ImgFocus") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ImgFocus")
        }
    }
    
    // MARK: RFID Authentication
    
    var PriorityUsingDSCertificates :Bool {
        get {
            return UserDefaults.standard.value(forKey: "PriorityUsingDSCertificates") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "PriorityUsingDSCertificates")
        }
    }
    
    var UseExternalCSCACertificates :Bool {
        get {
            return UserDefaults.standard.value(forKey: "UseExternalCSCACertificates") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "UseExternalCSCACertificates")
        }
    }
    
    var TrustPKDCertificates :Bool {
        get {
            return UserDefaults.standard.value(forKey: "TrustPKDCertificates") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "TrustPKDCertificates")
        }
    }
    
    var PassiveAuthentication :Bool {
        get {
            return UserDefaults.standard.value(forKey: "PassiveAuthentication") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "PassiveAuthentication")
        }
    }
    
    var PerformAAAfterCA :Bool {
        get {
            return UserDefaults.standard.value(forKey: "PerformAAAfterCA") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "PerformAAAfterCA")
        }
    }
    
    var StrictISOProtocol :Bool {
        get {
            return UserDefaults.standard.value(forKey: "StrictISOProtocol") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "StrictISOProtocol")
        }
    }
    
    
    // MARK: DataGroup E-PassPort
    
    var ReadEPassport :Bool {
        get {
            return UserDefaults.standard.value(forKey: "ReadEPassport") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ReadEPassport")
        }
    }
    
    var MachineReadableZone :Bool {
        get {
            return UserDefaults.standard.value(forKey: "MachineReadableZone") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "MachineReadableZone")
        }
    }
    
    var Biometry_FacialData :Bool {
        get {
            return UserDefaults.standard.value(forKey: "Biometry_FacialData") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "Biometry_FacialData")
        }
    }
    
    var Biometry_Fingerprints :Bool {
        get {
            return UserDefaults.standard.value(forKey: "Biometry_Fingerprints") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "Biometry_Fingerprints")
        }
    }
    
    var Biometry_IrisData :Bool {
        get {
            return UserDefaults.standard.value(forKey: "Biometry_IrisData") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "Biometry_IrisData")
        }
    }
    
    var Portrait :Bool {
        get {
            return UserDefaults.standard.value(forKey: "Portrait") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "Portrait")
        }
    }
    
    var NotDefinedDG6 :Bool {
        get {
            return UserDefaults.standard.value(forKey: "NotDefinedDG6") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "NotDefinedDG6")
        }
    }
    
    
    var SignatureUsualMarkImage :Bool {
        get {
            return UserDefaults.standard.value(forKey: "SignatureUsualMarkImage") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "SignatureUsualMarkImage")
        }
    }
    
    
    var NotDefinedDG8 :Bool {
        get {
            return UserDefaults.standard.value(forKey: "NotDefinedDG8") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "NotDefinedDG8")
        }
    }
    
    
    var NotDefinedDG9 :Bool {
        get {
            return UserDefaults.standard.value(forKey: "NotDefinedDG9") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "NotDefinedDG9")
        }
    }
    
    
    var NotDefinedDG10 :Bool {
        get {
            return UserDefaults.standard.value(forKey: "NotDefinedDG10") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "NotDefinedDG10")
        }
    }
    
    
    var AdditionalPersonalDetail :Bool {
        get {
            return UserDefaults.standard.value(forKey: "AdditionalPersonalDetail") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "AdditionalPersonalDetail")
        }
    }
    
    var AdditionalDocumentDetail :Bool {
        get {
            return UserDefaults.standard.value(forKey: "AdditionalDocumentDetail") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "AdditionalDocumentDetail")
        }
    }
    
    
    var OptionalDetail :Bool {
        get {
            return UserDefaults.standard.value(forKey: "OptionalDetail") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "OptionalDetail")
        }
    }
    
    
    var EACInfo :Bool {
        get {
            return UserDefaults.standard.value(forKey: "EACInfo") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "EACInfo")
        }
    }
    
    
    var ActiveAuthenticationInfo :Bool {
        get {
            return UserDefaults.standard.value(forKey: "ActiveAuthenticationInfo") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ActiveAuthenticationInfo")
        }
    }
    
    
    var PersonToNotify :Bool {
        get {
            return UserDefaults.standard.value(forKey: "PersonToNotify") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "PersonToNotify")
        }
    }
   
    // MARK: DataGroup E-ID
    
    var ReadElD :Bool {
        get {
            return UserDefaults.standard.value(forKey: "ReadElD") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ReadElD")
        }
    }
    
    var DocumentType :Bool {
        get {
            return UserDefaults.standard.value(forKey: "DocumentType") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "DocumentType")
        }
    }
    
    var IssuingState :Bool {
        get {
            return UserDefaults.standard.value(forKey: "IssuingState") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "IssuingState")
        }
    }
    
    var DateOfExpiry :Bool {
        get {
            return UserDefaults.standard.value(forKey: "DateOfExpiry") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "DateOfExpiry")
        }
    }
    
    var GivenName :Bool {
        get {
            return UserDefaults.standard.value(forKey: "GivenName") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "GivenName")
        }
    }
    
    var FamilyName :Bool {
        get {
            return UserDefaults.standard.value(forKey: "FamilyName") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "FamilyName")
        }
    }
    
    var Pseudonym :Bool {
        get {
            return UserDefaults.standard.value(forKey: "Pseudonym") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "Pseudonym")
        }
    }
    
    var AcademicTitle :Bool {
        get {
            return UserDefaults.standard.value(forKey: "AcademicTitle") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "AcademicTitle")
        }
    }
    
    var DateOfBirth :Bool {
        get {
            return UserDefaults.standard.value(forKey: "DateOfBirth") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "DateOfBirth")
        }
    }
    
    var PlaceOfBirth :Bool {
        get {
            return UserDefaults.standard.value(forKey: "PlaceOfBirth") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "PlaceOfBirth")
        }
    }
    
    var Nationality :Bool {
        get {
            return UserDefaults.standard.value(forKey: "Nationality") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "Nationality")
        }
    }
    
    var Sex :Bool {
        get {
            return UserDefaults.standard.value(forKey: "Sex") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "Sex")
        }
    }
    
    var OptionalDetailsDG12 :Bool {
        get {
            return UserDefaults.standard.value(forKey: "OptionalDetailsDG12") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "OptionalDetailsDG12")
        }
    }
    
    var UndefinedDG13 :Bool {
        get {
            return UserDefaults.standard.value(forKey: "UndefinedDG13") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "UndefinedDG13")
        }
    }
    
    var UndefinedDG14 :Bool {
        get {
            return UserDefaults.standard.value(forKey: "UndefinedDG14") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "UndefinedDG14")
        }
    }
    
    var UndefinedDG15 :Bool {
        get {
            return UserDefaults.standard.value(forKey: "UndefinedDG15") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "UndefinedDG15")
        }
    }
    
    var UndefinedDG16 :Bool {
        get {
            return UserDefaults.standard.value(forKey: "UndefinedDG16") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "UndefinedDG16")
        }
    }
    
    var PlaceOfRegistrationDG17 :Bool {
        get {
            return UserDefaults.standard.value(forKey: "PlaceOfRegistrationDG17") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "PlaceOfRegistrationDG17")
        }
    }
    
    var PlaceOfRegistrationDG18 :Bool {
        get {
            return UserDefaults.standard.value(forKey: "PlaceOfRegistrationDG18") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "PlaceOfRegistrationDG18")
        }
    }
    
    var ResidencePermit1DG19 :Bool {
        get {
            return UserDefaults.standard.value(forKey: "ResidencePermit1DG19") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ResidencePermit1DG19")
        }
    }
    
    var ResidencePermit2DG20 :Bool {
        get {
            return UserDefaults.standard.value(forKey: "ResidencePermit2DG20") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ResidencePermit2DG20")
        }
    }
    
    var OptionalDetailsDG21 :Bool {
        get {
            return UserDefaults.standard.value(forKey: "OptionalDetailsDG21") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "OptionalDetailsDG21")
        }
    }
    
    // MARK: DataGroup E-DL
    
    
    var ReadEDL :Bool {
        get {
            return UserDefaults.standard.value(forKey: "ReadEDL") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ReadEDL")
        }
    }
    
    var TextDataElementsDG1 :Bool {
        get {
            return UserDefaults.standard.value(forKey: "TextDataElementsDG1") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "TextDataElementsDG1")
        }
    }
    
    var LicenseHolderInformationDG2 :Bool {
        get {
            return UserDefaults.standard.value(forKey: "LicenseHolderInformationDG2") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "LicenseHolderInformationDG2")
        }
    }
    
    var IssuingAuthorityDetailsDG3 :Bool {
        get {
            return UserDefaults.standard.value(forKey: "IssuingAuthorityDetailsDG3") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "IssuingAuthorityDetailsDG3")
        }
    }
    
    var PortraitImageDG4 :Bool {
        get {
            return UserDefaults.standard.value(forKey: "PortraitImageDG4") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "PortraitImageDG4")
        }
    }
    
    var SignatureUsualMarkImageDG5 :Bool {
        get {
            return UserDefaults.standard.value(forKey: "SignatureUsualMarkImageDG5") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "SignatureUsualMarkImageDG5")
        }
    }
    
    var Biometry_FacialDataDG6 :Bool {
        get {
            return UserDefaults.standard.value(forKey: "Biometry_FacialDataDG6") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "Biometry_FacialDataDG6")
        }
    }
    
    var Biometry_FingerprintDG7 :Bool {
        get {
            return UserDefaults.standard.value(forKey: "Biometry_FingerprintDG7") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "Biometry_FingerprintDG7")
        }
    }
    
    var Biometry_IrisDataDG8 :Bool {
        get {
            return UserDefaults.standard.value(forKey: "Biometry_IrisDataDG8") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "Biometry_IrisDataDG8")
        }
    }
    
    var Biometry_OtherDG9 :Bool {
        get {
            return UserDefaults.standard.value(forKey: "Biometry_OtherDG9") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "Biometry_OtherDG9")
        }
    }
    
    var EDL_NotDefinedDG10 :Bool {
        get {
            return UserDefaults.standard.value(forKey: "EDL_NotDefinedDG10") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "EDL_NotDefinedDG10")
        }
    }
    
    var OptionalDomesticDataDG11 :Bool {
        get {
            return UserDefaults.standard.value(forKey: "OptionalDomesticDataDG11") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "OptionalDomesticDataDG11")
        }
    }
    
    var Non_MatchAlertDG12 :Bool {
        get {
            return UserDefaults.standard.value(forKey: "Non_MatchAlertDG12") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "Non_MatchAlertDG12")
        }
    }
    
    var ActiveAuthenticationInfoDG13 :Bool {
        get {
            return UserDefaults.standard.value(forKey: "ActiveAuthenticationInfoDG13") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ActiveAuthenticationInfoDG13")
        }
    }
    
    var EACInfoDG14 :Bool {
        get {
            return UserDefaults.standard.value(forKey: "EACInfoDG14") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "EACInfoDG14")
        }
    }
    
    // MARK: Sounds
    
    
    var SoundEnabled :Bool {
        get {
            return UserDefaults.standard.value(forKey: "SoundEnabled") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "SoundEnabled")
        }
    }
    
    
    var SelectedSound :String {
        get {
            return UserDefaults.standard.value(forKey: "SelectedSound") as? String ?? "beep1"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "SelectedSound")
        }
    }
    
    // MARK: Time Out
    
    var TimeOut :String {
        get {
            return UserDefaults.standard.value(forKey: "TimeOut") as? String ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "TimeOut")
        }
    }
    
    
    var TimeOutDocumentDetection :String {
        get {
            return UserDefaults.standard.value(forKey: "TimeOutDocumentDetection") as? String ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "TimeOutDocumentDetection")
        }
    }
    
    var TimeOutDocumentIdentification :String {
        get {
            return UserDefaults.standard.value(forKey: "TimeOutDocumentIdentification") as? String ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "TimeOutDocumentIdentification") //"Perspective angle"
        }
    }
    var ZoomLevel :String {
        get {
            return UserDefaults.standard.value(forKey: "ZoomLevel") as? String ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ZoomLevel")
        }
    }
    
    var MinimumDPI :String {
        get {
            return UserDefaults.standard.value(forKey: "MinimumDPI") as? String ?? "" //"Document filter"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "MinimumDPI")
        }
    }
    
    var PerspectiveAngle :String {
        get {
            return UserDefaults.standard.value(forKey: "PerspectiveAngle") as? String ?? ""//"Custom parameters"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "PerspectiveAngle")
        }
    }
    
    var DocumentFilter :String {
        get {
            return UserDefaults.standard.value(forKey: "DocumentFilter") as? String ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "DocumentFilter")
        }
    }
    
    var CustomParameters :String {
        get {
            return UserDefaults.standard.value(forKey: "CustomParameters") as? String ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "CustomParameters")
        }
    }
    
    var ProcessingModes :String {
        get {
            return UserDefaults.standard.value(forKey: "ProcessingModes") as? String ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ProcessingModes")
        }
    }
    
    var CameraResolution :String {
        get {
            return UserDefaults.standard.value(forKey: "CameraResolution") as? String ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "CameraResolution")
        }
    }
    
    var DateFormat :String {
        get {
            return UserDefaults.standard.value(forKey: "DateFormat") as? String ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "DateFormat")
        }
    }
    
    
    // MARK: Image Quality
    
    var DPIThreshold :String {
        get {
            return UserDefaults.standard.value(forKey: "DPIThreshold") as? String ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "DPIThreshold")
        }
    }
    
    var AngleThreshold :String {
        get {
            return UserDefaults.standard.value(forKey: "AngleThreshold") as? String ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "AngleThreshold")
        }
    }
    
    var DocumentPositionIndent :String {
        get {
            return UserDefaults.standard.value(forKey: "DocumentPositionIndent") as? String ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "DocumentPositionIndent")
        }
    }
    
    
    // MARK: Authentication Procedure
    
    var AuthenticationProcedureType :String {
        get {
            return UserDefaults.standard.value(forKey: "AuthenticationProcedureType") as? String ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "AuthenticationProcedureType")
        }
    }
    
    var BasicSecurityMessagingProcedure :String {
        get {
            return UserDefaults.standard.value(forKey: "BasicSecurityMessagingProcedure") as? String ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "BasicSecurityMessagingProcedure")
        }
    }
    
    var DataAccesKey :String {
        get {
            return UserDefaults.standard.value(forKey: "DataAccesKey") as? String ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "DataAccesKey")
        }
    }
    
    var AuthDataAccesKey :String {
        get {
            return UserDefaults.standard.value(forKey: "AuthDataAccesKey") as? String ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "AuthDataAccesKey")
        }
    }
    
    var DataAccessKeyValue :String {
        get {
            return UserDefaults.standard.value(forKey: "DataAccessKeyValue") as? String ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "DataAccessKeyValue")
        }
    }
    
    var ProfilerType :String {
        get {
            return UserDefaults.standard.value(forKey: "ProfilerType") as? String ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ProfilerType")
        }
    }
}
 
