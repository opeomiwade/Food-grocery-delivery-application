//
//  classifierViewController.swift
//  grocery delivery app(final year project)
//
//  Created by Ope Omiwade on 10/04/2023.
//

import UIKit
import CoreML
import CoreVideo
import AVFoundation

class classifierViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVCaptureVideoDataOutputSampleBufferDelegate{
    
    
    let captureSession = AVCaptureSession()
    let videoOutput = AVCaptureVideoDataOutput()
    let previewLayer = AVCaptureVideoPreviewLayer()
    var newRestArray = [[String : String]]()
    var className = ""
    
    
    
    //MARK: IBOUTLETS AND IBACTIONS
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var classifyButtonOutlet: UIButton!
    var index = 0
    
    
    @IBAction func classifyButton(_ sender: Any) {
        
        //Instance of foodclassifier wrapper class
        newRestArray = []
        let config = MLModelConfiguration()
        
        do{
            guard let buffer = Image.image?.getCVPixelBuffer() else { return }
            let model = try foodclassifier(configuration: config)
            let input = foodclassifierInput(image: buffer)
            let output = try model.prediction(input: input)
            let output2 = try model.prediction(image: buffer)
            
            className = output2.classLabel.replacingOccurrences(of: "_", with: " ")
            label.text = className
            filterArray(className)
            tableView.reloadData()
            
        }
        
        catch{
            print(error.localizedDescription)
        }
        
        classifyButtonOutlet.isEnabled = false
    }
    
    //MARK: VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //gesturerecognizer
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        Image.addGestureRecognizer(tap)
    }
    
    
    //MARK: IMAGETAPPED METHOD
    @objc func imageTapped(){
        let imagePickerController = UIImagePickerController()
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let chooseLibrary = UIAlertAction(title: "Choose from Library", style: .default) { action in
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true)
        }
        actionSheet.addAction(chooseLibrary)
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { action in
            imagePickerController.sourceType = .camera
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true)
        }
        
        actionSheet.addAction(takePhoto)
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
        
    }
    
    
    //MARK: TABLEVIEW METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newRestArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! classifierTableViewCell
        cell.accessoryType = .disclosureIndicator
        cell.nameLabel.text = newRestArray[indexPath.row]["name"]
        cell.priceLabel.text = newRestArray[indexPath.row]["price"]
        cell.descriptionLabel.text = newRestArray[indexPath.row]["description"]
        cell.foodImagee.setImage(url: URL(string: newRestArray[indexPath.row]["ImageUrl"] ?? " ")!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "classifiertoaddtocart", sender: nil)
    }
    
    //MARK: PREPARE FOR SEGUE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "classifiertoaddtocart"{
            let ViewController = segue.destination as? addToCartViewController
            ViewController?.itemDictionary = newRestArray[index]
        }
    }
    
    
    //MARK: IMAGE PICKER METHOD
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            Image.image = image
        }
        picker.dismiss(animated: true, completion: nil)
        
        classifyButtonOutlet.isEnabled = true
    }
    
    //MARK: MY METHOD
    
    func filterArray(_ foodName: String){
        for dict in restArray{
            if dict.isEmpty == false{
                print(dict["name"]!)
                if ((dict["name"]!.lowercased().contains(foodName.lowercased()))){
                    newRestArray.append(dict)
                }
            }
            
        }
        print(newRestArray)
        print(newRestArray.count)
    }
    
    
   
    
    
}

//MARK: UIImage EXTENSIONS
extension UIImage{
    
    func getCVPixelBuffer() -> CVPixelBuffer? {
        guard let image = cgImage else {
            return nil
        }
        let imageWidth = Int(image.width)
        let imageHeight = Int(image.height)
        let attributes : [NSObject:AnyObject] = [
            kCVPixelBufferCGImageCompatibilityKey : true as AnyObject,
            kCVPixelBufferCGBitmapContextCompatibilityKey : true as AnyObject
        ]
        var pxbuffer: CVPixelBuffer? = nil
        CVPixelBufferCreate(
            kCFAllocatorDefault,
            imageWidth,
            imageHeight,
            kCVPixelFormatType_32ARGB,
            attributes as CFDictionary?,
            &pxbuffer
        )
        if let _pxbuffer = pxbuffer {
            let flags = CVPixelBufferLockFlags(rawValue: 0)
            CVPixelBufferLockBaseAddress(_pxbuffer, flags)
            let pxdata = CVPixelBufferGetBaseAddress(_pxbuffer)
            
            let rgbColorSpace = CGColorSpaceCreateDeviceRGB();
            let context = CGContext(
                data: pxdata,
                width: imageWidth,
                height: imageHeight,
                bitsPerComponent: 8,
                bytesPerRow: CVPixelBufferGetBytesPerRow(_pxbuffer),
                space: rgbColorSpace,
                bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
            )
            
            if let _context = context {
                _context.draw(
                    image,
                    in: CGRect.init(
                        x: 0,
                        y: 0,
                        width: imageWidth,
                        height: imageHeight
                    )
                )
            }
            else {
                CVPixelBufferUnlockBaseAddress(_pxbuffer, flags);
                return nil
            }
            
            CVPixelBufferUnlockBaseAddress(_pxbuffer, flags);
            return _pxbuffer;
        }
        
        return nil
    }
}
