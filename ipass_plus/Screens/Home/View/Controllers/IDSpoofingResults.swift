//
//  IDSpoofingResults.swift
//  ipass_plus
//
//  Created by MOBILE on 24/09/24.
//

import UIKit
import DocumentReader
import CoreML
import Vision
import Alamofire

class IDSpoofingResults: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var authImage: UIImageView!
    var completeResults: DocumentReaderResults!
    
    @IBOutlet weak var authView: UIView!
    @IBOutlet weak var backImage: UIImageView!
    var documentFrontImage: UIImage!
    var documentBackImage: UIImage!
    
    var imagePatternArray = [Int]()
    var livenessArray = [Int]()
    var barcodeFormatArray = [Int]()
    var portraitComparisonArray = [Int]()
    var photoEmbedingArray = [Int]()
    var ipiArray = [Int]()
    var colornessArray = [Int]()
    
    var reasonsData = [String: Int]()
    
    var descriptionData = [String: String]()
    
    var cellTitles = [String]()
    
    var tempDataCellTitles = [String]()
    
    
    @IBOutlet weak var spoffingListTableView: UITableView!
    var collectionView: UICollectionView!
       let events = Event.getMockData() // This will return 100 events


    @IBOutlet weak var frontImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        cellTitles = ["Liveness", "Image Pattern", "Barcode Format", "Portrait Comparison", "Photo Embeding", "ipi", "colorness"]
        spoffingListTableView.register(UINib(nibName: "SpoofingTableViewCell", bundle: nil), forCellReuseIdentifier: "SpoofingTableViewCell")
        startDataSorting()
        
       // setupCollectionView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let showAlertButton = UIButton(type: .system)
              showAlertButton.frame = CGRect(x: 50, y: 200, width: 200, height: 50)
              showAlertButton.setTitle("Upload Content", for: .normal)
              showAlertButton.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
              
              self.view.addSubview(showAlertButton)
    }
    
    func convertDictionaryToJSONString(_ dictionary: [String: Any]) -> String? {
        do {
            // Convert the dictionary to Data using JSONSerialization
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            
            // Convert the JSON data to a string
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        } catch {
            print("Error converting dictionary to JSON string: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    func uploadSpoof() {
        
        if let jsonString = convertDictionaryToJSONString(completeResults.authenticityResults?.jsonDictionary() as! [String : Any]) {
            print(jsonString)
            
        }
        
       // if let jsonString = convertDictionaryToJSONString(completeResults.authenticityResults?.jsonDictionary() as! [String : Any]) {
//            Loader.show()
//            guard let apiURL = URL(string: "https://api.statzoapp.com/test") else { return }
//            var parameters: [String: String] = [:]
//            parameters["description"] = completeResults.rawResult
//            parameters["platform"] = "iOS"
//            AF.request(apiURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders(["Content-Type": "application/json"]))
//                .responseJSON { response in
//                    print("()()()()()()(())))(()()(")
//                    let status = response.response?.statusCode
//                    print(response.result)
//                    Loader.hide()
//                }
       // }
   
    }
    
    @objc func showAlert() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LivenessReasonsVC") as! LivenessReasonsVC
        vc.resultImages = completeResults
        self.navigationController?.pushViewController(vc, animated: true)
        
     //   print(completeResults.authenticityResults?.jsonDictionary() as Any)
      
       //
       
       // uploadSpoof()
        
        
//        if let authenticityResultsDict = completeResults.authenticityResults?.jsonDictionary() {
//            do {
//                // Convert the dictionary to JSON data
//                let jsonData = try JSONSerialization.data(withJSONObject: authenticityResultsDict, options: .prettyPrinted)
//                
//                // Convert the JSON data to a String
//                if let jsonString = String(data: jsonData, encoding: .utf8) {
//                    print("JSON String: \(jsonString)")
//                    // You can use `jsonString` as your string result
//                    
//                    
//                    var statusString = ""
//                    
//                    if let status = completeResults.authenticityResults?.status.rawValue {
//                        statusString = String(status)
//                        print("Status as String: \(statusString)")
//                        // You can now use `statusString` as a string version of the raw value
//                    } else {
//                        print("Status is nil")
//                    }
//                    
//                    
//                    
//                    
//                    
//                    // Create the alert controller
//                    let alertController = UIAlertController(title: "Overall status : " + statusString, message: jsonString, preferredStyle: .alert)
//
//                    // Add the "Copy" action
//                    let copyAction = UIAlertAction(title: "Copy", style: .default) { _ in
//                        self.copyToClipboard(text: jsonString)
//                    }
//
//                    // Add the "Close" action
//                    let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
//
//                    // Add actions to the alert controller
//                    alertController.addAction(copyAction)
//                    alertController.addAction(closeAction)
//
//                    // Present the alert
//                    self.present(alertController, animated: true, completion: nil)
//                    
//                    
//                }
//            } catch {
//                print("Error converting dictionary to JSON: \(error.localizedDescription)")
//            }
//        } else {
//            print("authenticityResults is nil or jsonDictionary() returned nil")
//        }
//        
//        
        
         

           
       }

       // Function to copy text to the clipboard
       func copyToClipboard(text: String) {
           UIPasteboard.general.string = text
           // Optional: Show a confirmation message after copying
           let copyConfirmation = UIAlertController(title: nil, message: "Data copied to clipboard!", preferredStyle: .alert)
           self.present(copyConfirmation, animated: true) {
               DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                   copyConfirmation.dismiss(animated: true, completion: nil)
               }
           }
       }
    
 
    @IBAction func dismissClick(_ sender: Any) {
        _ = navigationController?.popViewController(animated: false)

    }
    
    func startDataSorting() {
        
        livenessArray.removeAll()
        
        if(completeResults == nil) {
            return
        }
        
        
        
        
        
        for qualityIndex in 0..<(completeResults.imageQualityGroup?.count ?? 0) {
            for j in 0..<(completeResults.imageQualityGroup?[qualityIndex].imageQualityList.count ?? 0) {
                if(completeResults.imageQualityGroup?[qualityIndex].imageQualityList[j].type == "3") {
                    if let status = completeResults.imageQualityGroup?[qualityIndex].imageQualityList[j].result.rawValue {
                        colornessArray.append(status)
                    }
                   
                }
            }
        }
        
        for indexValue in 0..<(completeResults.authenticityResults?.checks?.count ?? 0) {
            print(completeResults.authenticityResults?.checks?[indexValue].type.rawValue as Any)
            print(completeResults.authenticityResults?.checks?[indexValue].status.rawValue as Any)
            
            // IMAGE_PATTERN
            if(completeResults.authenticityResults?.checks?[indexValue].type.rawValue == 4) {
                if let status = completeResults.authenticityResults?.checks?[indexValue].status.rawValue {
                    
                    imagePatternArray.append(status)
                }
            }
            
            // Liveness
            if(completeResults.authenticityResults?.checks?[indexValue].type.rawValue == 2097152) {
                if let status = completeResults.authenticityResults?.checks?[indexValue].status.rawValue {
                    if let indValue = completeResults.authenticityResults?.checks?[indexValue].pageIndex {
                        
                        tempDataCellTitles.append("Index: \(indValue) Result: \(status)")
                        
                        if(indValue == 1) {
                            if(livenessArray.count == 0) {
                                livenessArray.append(status)
                            }
                        }
                    }
                   
                }
                
            }
            
            
            // BARCODE_FORMAT_CHECK
            if(completeResults.authenticityResults?.checks?[indexValue].type.rawValue == 65536) {
                if let status = completeResults.authenticityResults?.checks?[indexValue].status.rawValue {
                    barcodeFormatArray.append(status)
                }
            }
            
            // PORTRAIT_COMPARISON
            if(completeResults.authenticityResults?.checks?[indexValue].type.rawValue == 32768) {
                if let status = completeResults.authenticityResults?.checks?[indexValue].status.rawValue {
                    portraitComparisonArray.append(status)
                }
              
            }
            
            // PHOTO_EMBED_TYPE
            if(completeResults.authenticityResults?.checks?[indexValue].type.rawValue == 512) {
                if let status = completeResults.authenticityResults?.checks?[indexValue].status.rawValue {
                    photoEmbedingArray.append(status)
                }
            }
            
            // IPI
            if(completeResults.authenticityResults?.checks?[indexValue].type.rawValue == 128) {
                if let status = completeResults.authenticityResults?.checks?[indexValue].status.rawValue {
                    ipiArray.append(status)
                }
            }
            
            
           
        }
        
        
        
        for index in 0..<completeResults.graphicResult.fields.count {
            
            if((completeResults.graphicResult.fields[index].fieldName == "Document image") && (completeResults.graphicResult.fields[index].pageIndex == 0)) {
                documentFrontImage = completeResults.graphicResult.fields[index].value
            }
            
            else if((completeResults.graphicResult.fields[index].fieldName == "Document image") && (completeResults.graphicResult.fields[index].pageIndex == 1)) {
                documentBackImage = completeResults.graphicResult.fields[index].value
            }
           
        }

        
        reasonsData["Liveness"] =  getCalculatedResults(livenessArray)
        reasonsData["ImagePattern"] = getCalculatedResults(imagePatternArray)
        reasonsData["BarcodeFormat"] = getCalculatedResults(barcodeFormatArray)
        reasonsData["PortraitComparison"] = getCalculatedResults(portraitComparisonArray)
        reasonsData["PhotoEmbeding"] = getCalculatedResults(photoEmbedingArray)
        reasonsData["ipi"] = getCalculatedResults(ipiArray)
        reasonsData["colorness"] = getCalculatedResults(colornessArray)
        
        
        descriptionData["Liveness"] =  "The Liveness authenticity check ensures the identity document is physically presented"
        descriptionData["ImagePattern"] = "As protection against counterfeiting, most documents have unique patterns (elements of documents), which can appear or change their shape in different types of light"
        descriptionData["BarcodeFormat"] = "Ensure a barcode is inherent to a specific document, has proper technical and physical parameters, is correctly located in the document, and contains the correct data structure."
        descriptionData["PortraitComparison"] = "The Portrait comparison authenticity check ensures that the same individual is present across various photos associated with a document. This involves comparing portraits from multiple sources such as the visual zone of the document (photo and ghost photo)"
        descriptionData["PhotoEmbeding"] = "The Photo embedding authenticity check involves verifying if the holder's image in a document matches the specified method of embedding (sticked or printed)"
        descriptionData["ipi"] = "The IPI authenticity check is used to visualize the invisible personal information (IPI) that was applied on the holder's photo during the personalization of the document."
        descriptionData["colorness"] = "Colorness check that if the scanned document is colorless or not."
        
        print(reasonsData)
        
        bindSpotlightData()
    }
    
    
    func getCalculatedResults(_ dataResult: [Int]) -> Int {
        if(dataResult.isEmpty || dataResult.contains(2)) {
            return 2
        }
        if(dataResult.contains(0)) {
            return 0
        }
        return 1
    }
    
    func bindSpotlightData() {
        authView.layer.borderWidth = 1
        authView.layer.borderColor = UIColor(red:185/255, green:185/255, blue:185/255, alpha: 1).cgColor
        frontImage.image = documentFrontImage
        backImage.image = documentBackImage
        
        frontImage.layer.cornerRadius = 8
        frontImage.clipsToBounds = true
        
        backImage.layer.cornerRadius = 8
        backImage.clipsToBounds = true
        
        
        
        if(completeResults.authenticityResults?.status.rawValue == 2) {
            authImage.image = UIImage(named: "spMinus")
        }
        
        else if(completeResults.authenticityResults?.status.rawValue == 0) {
            authImage.image = UIImage(named: "spCross")
        }
        
        else if(completeResults.authenticityResults?.status.rawValue == 1) {
            authImage.image = UIImage(named: "spTick")
        }
        else {
            authImage.image = UIImage(named: "spMinus")
        }
       
        
        spoffingListTableView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return cellTitles.count
        return tempDataCellTitles.count
       }

       
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "SpoofingTableViewCell", for: indexPath) as! SpoofingTableViewCell
       
       cell.headingLbl.text = tempDataCellTitles[indexPath.row]
       
//       cell.headingLbl.text = cellTitles[indexPath.row]
//       
//       if(reasonsData[cellTitles[indexPath.row].replacingOccurrences(of: " ", with: "")] == 2) {
//           cell.statusImage.image = UIImage(named: "spMinus")
//       }
//       
//       else if(reasonsData[cellTitles[indexPath.row].replacingOccurrences(of: " ", with: "")] == 0) {
//           cell.statusImage.image = UIImage(named: "spCross")
//       }
//       
//       else  {
//           cell.statusImage.image = UIImage(named: "spTick")
//       }
//     
//       cell.infoButton.tag = indexPath.row
//       cell.infoButton!.addTarget(self, action:#selector(self.descClick), for: .touchUpInside)

     

           return cell
       }


    
    @objc func descClick(sender:UIButton) {
        print("Button \(sender.tag) clicked")
//        descriptionData
        
        self.alert(message: descriptionData[cellTitles[sender.tag].replacingOccurrences(of: " ", with: "")]!)
    }
    

}

extension UIViewController {
  func alert(message: String, title: String = "") {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(OKAction)
    self.present(alertController, animated: true, completion: nil)
  }
}
