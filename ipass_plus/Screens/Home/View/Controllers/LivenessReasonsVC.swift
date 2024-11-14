//
//  LivenessReasonsVC.swift
//  ipass_plus
//
//  Created by MOBILE on 17/10/24.
//

import UIKit
import DocumentReader

class LivenessReasonsVC: UIViewController {

    @IBOutlet weak var img8: UIImageView!
    @IBOutlet weak var img7: UIImageView!
    @IBOutlet weak var img6: UIImageView!
    @IBOutlet weak var img5: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img1: UIImageView!
    var resultImages: DocumentReaderResults!
    var doneOnce = false
    var index1 = [UIImageView]()
    var index2 = [UIImageView]()
    var elementsPage1 = ""
    var elementsPage2 = ""
    
    
    @IBOutlet weak var showAllElements: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        index1 = [img1, img2, img3, img4, img5, img6, img7, img8]
        index2 = [img5, img6, img7, img8]
        startSortingProcess()
        
    }
    
    @IBAction func page1Click(_ sender: Any) {
        
        img1.image = nil
        img2.image = nil
        img3.image = nil
        img4.image = nil
        img5.image = nil
        img6.image = nil
        img7.image = nil
        img8.image = nil
        for indexValue in 0..<(resultImages.graphicResult.fields.count) {
            
            
            if(resultImages.graphicResult.fields[indexValue].pageIndex == 0) {
                index1[indexValue].image = resultImages.graphicResult.fields[indexValue].value
            }
        }
        sortElements(0)
    }
    @IBAction func page2Click(_ sender: Any) {
        img1.image = nil
        img2.image = nil
        img3.image = nil
        img4.image = nil
        img5.image = nil
        img6.image = nil
        img7.image = nil
        img8.image = nil
        for indexValue in 0..<(resultImages.graphicResult.fields.count) {
            
            if(resultImages.graphicResult.fields[indexValue].pageIndex == 1) {
                index1[indexValue].image = resultImages.graphicResult.fields[indexValue].value
            }
        }
        sortElements(1)
    }
    @IBAction func page3Click(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func startSortingProcess() {
        img1.image = nil
        img2.image = nil
        img3.image = nil
        img4.image = nil
        img5.image = nil
        img6.image = nil
        img7.image = nil
        img8.image = nil
        for indexValue in 0..<(resultImages.graphicResult.fields.count) {
            if(resultImages.graphicResult.fields[indexValue].pageIndex == 0) {
                index1[indexValue].image = resultImages.graphicResult.fields[indexValue].value
            }
        }
        
        sortElements(0)
    }

    func sortElements(_ pageType : Int) {
        elementsPage1 = ""
        
        elementsPage2 = ""
        if(pageType == 0) {
            for indexValue in 0..<(resultImages.authenticityResults?.checks?.count ?? 0) {
                if(resultImages.authenticityResults?.checks?[indexValue].pageIndex == 0) {
                    for eleCount in 0..<(resultImages.authenticityResults?.checks?[indexValue].elements?.count ?? 0) {
                        elementsPage1 = elementsPage1 + "," + (resultImages.authenticityResults?.checks?[indexValue].elements?[eleCount].elementType.rawValue.description ?? "")
                    }
                    
                }
            }
            showAllElements.text = elementsPage1
        }
        else {
            for indexValue in 0..<(resultImages.authenticityResults?.checks?.count ?? 0) {
                if(resultImages.authenticityResults?.checks?[indexValue].pageIndex == 1) {
                    for eleCount in 0..<(resultImages.authenticityResults?.checks?[indexValue].elements?.count ?? 0) {
                        elementsPage2 = elementsPage2 + "," + (resultImages.authenticityResults?.checks?[indexValue].elements?[eleCount].elementType.rawValue.description ?? "")
                    }
                }
            }
            showAllElements.text = elementsPage2
        }
        
        
       
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
