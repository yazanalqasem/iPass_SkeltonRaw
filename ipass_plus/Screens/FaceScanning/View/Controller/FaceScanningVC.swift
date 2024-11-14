//
//  FaceScanningVC.swift
//  ipass_plus
//
//  Created by Mobile on 15/02/24.
//

import UIKit
import Vision
import AVFoundation
import DocumentReader


class FaceScanningVC: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, AVCapturePhotoCaptureDelegate{
    var results: DocumentReaderResults!
    @IBOutlet weak var holderView: UIView!
    
    
    @IBOutlet weak var btncaptureImg: UIButton!
    
    
    let session = AVCaptureSession()
     var faceDetectionRequest: VNDetectFaceRectanglesRequest!
    
    
    var captureSession: AVCaptureSession!
       var cameraOutput: AVCapturePhotoOutput!
       
       override func viewDidLoad() {
           super.viewDidLoad()

           btncaptureImg.layer.cornerRadius = 10
           holderView.layer.cornerRadius = 110
           holderView.layer.masksToBounds = true
           
           captureSession = AVCaptureSession()
           guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front) else {
               print("Unable to access back camera!")
               return
           }
           
           do {
               let input = try AVCaptureDeviceInput(device: backCamera)
               cameraOutput = AVCapturePhotoOutput()
               
               if captureSession.canAddInput(input) && captureSession.canAddOutput(cameraOutput) {
                   captureSession.addInput(input)
                   captureSession.addOutput(cameraOutput)
                   
                   let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                   previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill

                   previewLayer.frame = holderView.layer.bounds
                   holderView.layer.addSublayer(previewLayer)
                   
                 
                   DispatchQueue.global().async {
                       self.captureSession.startRunning()
                          }
                  
               }
           } catch {
               print("Error setting up capture session: \(error.localizedDescription)")
           }
       }
     
    @IBAction func click(_ sender: Any) {
        
        let photoSettings = AVCapturePhotoSettings()
              cameraOutput.capturePhoto(with: photoSettings, delegate: self)
        
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
           guard error == nil else {
               print("Error capturing photo: \(error!.localizedDescription)")
               return
           }
           
           guard let imageData = photo.fileDataRepresentation() else {
               print("Unable to get photo data")
               return
           }
           
           if let image = UIImage(data: imageData) {
               let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserInfoVC") as! UserInfoVC
               vc.CapturedImage = image
               vc.results = results
               vc.modalPresentationStyle = .fullScreen
               self.present(vc, animated: true)
           }
       }
     
     func convertCIImageToUIImage(ciImage: CIImage) -> UIImage? {
         let context = CIContext(options: nil)
         if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
             return UIImage(cgImage: cgImage)
         }
         return nil
     }
 }
