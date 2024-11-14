//
//  TesteRFID.swift
//  ipass_plus
//
//  Created by MOBILE on 26/03/24.
//

import UIKit
import DocumentReader

class TesteRFID: UIViewController {
    

    @IBOutlet weak var TableView: UITableView!
    var results: DocumentReaderResults!
    
    var arrayData:[UIImage] = []
    var typeName:[String] = []
    var sourceName:[String] = []
    var NameArray:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "TesteRFIDTableViewCell", bundle: nil)
        self.TableView.register(nib, forCellReuseIdentifier: "TesteRFIDTableViewCell")
        setImages()
    }
    
    func setImages(){
        for m in 0 ..< (results.graphicResult.fields.count) {
            
            let ddd = results.graphicResult.fields[m].value
            
            arrayData.append(ddd)
            
            NameArray.append(results.graphicResult.fields[m].fieldName)
            
            sourceName.append( results.graphicResult.fields[m].sourceType.stringValue )
            
            typeName.append( String(results.graphicResult.fields[m].fieldType.rawValue))
           
            
          
        }
        
        TableView.reloadData()
    }
    
}

extension TesteRFID: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TesteRFIDTableViewCell", for: indexPath) as! TesteRFIDTableViewCell
        cell.img.backgroundColor = .red
        
        

        
        cell.img.image = arrayData[indexPath.row]
        
        cell.lbl1.text = NameArray[indexPath.row]
        cell.lbl2.text = sourceName[indexPath.row]
        cell.lbl3.text = typeName[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
