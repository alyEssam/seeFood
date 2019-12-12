//
//  ViewController.swift
//  seeFood
//
//  Created by Aly Essam on 12/10/19.
//  Copyright © 2019 Aly Essam. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }
    //MARK: UIImagePickerControllerDelegate main 2 Methods
    /** UIImagePickerControllerDelegate functions **/

    //This Method is being invoked after select an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert to ciImage")
            }
            detect(image: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    //This Method is being invoked if you choosed to cancel selection an image
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func detect(image: CIImage){
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading coreML model failed")
        }
        let request = VNCoreMLRequest(model: model, completionHandler: { (request, error) in
            guard let result = request.results as? [VNClassificationObservation] else {
                fatalError("Model faild to process image")
            }
            if let firsItem = result.first {
                if firsItem.identifier.contains("hotdog"){
                    self.navigationItem.title = "Hotdog!"
                }
                else {
                    self.navigationItem.title = "Not Hotdog!"
                }
            }
        })
        let handler = VNImageRequestHandler(cgImage: image as! CGImage)
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
      present(imagePicker, animated: true, completion: nil)
    }

}

