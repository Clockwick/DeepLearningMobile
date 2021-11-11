//
//  CameraViewController.swift
//  TrashApp
//
//  Created by Paratthakorn Sribunyong on 25/8/2564 BE.
//

import UIKit

class CameraViewController: UIViewController {

    
    private var targetImageView = UIImageView()
    var picker = UIImagePickerController()
    private var manager: ImageManager = ImageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        openCamera()
    }
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            present(picker, animated: true, completion: nil)
        } else {
            let alertController: UIAlertController = {
                let controller = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { [weak self](_) in
                    self?.navigationController?.popViewController(animated: true)
                }
                controller.addAction(action)
                return controller
            }()
            present(alertController, animated: true)
        }
    }
    
    func pendingAlert() -> Void {
            //create an alert controller
            let pending = UIAlertController(title: "Loading", message: nil, preferredStyle: .alert)

            //create an activity indicator
            let indicator = UIActivityIndicatorView(frame: pending.view.bounds)
            indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            //add the activity indicator as a subview of the alert controller's view
            pending.view.addSubview(indicator)
            indicator.isUserInteractionEnabled = false // required otherwise if there buttons in the UIAlertController you will not be able to press them
            indicator.startAnimating()

            self.present(pending, animated: true)

            
    }

        

}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[UIImagePickerController.InfoKey.originalImage] != nil, let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            targetImageView.image = originalImage
            DispatchQueue.main.async {
                let pending = UIAlertController(title: "", message: nil, preferredStyle: .alert)
                let indicator = UIActivityIndicatorView(frame: pending.view.bounds)
                indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                
                pending.view.addSubview(indicator)
                indicator.isUserInteractionEnabled = false
                indicator.startAnimating()
                
                self.present(pending, animated: true) {
                    self.manager.uploadImage(data: (self.targetImageView.image?.pngData())!, completionHandler: { (response) in
                        self.dismiss(animated: true, completion: nil)
                        switch response {
                        case .success(let imageResponse):
                            if imageResponse.success == 1 {
                                DispatchQueue.main.async {
                                    let alert = UIAlertController(title: "This is \(imageResponse.value).", message: "Accuracy = \(imageResponse.accuracy)%", preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                    alert.addAction(okAction)
                                    self.present(alert, animated: true)
                                }
                            }
                            break;
                            
                        case .failure(_):
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Error", message: "Please upload again later", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alert.addAction(okAction)
                                self.present(alert, animated: true)
                            }
                            break;
                        }
                        self.navigationController?.popToRootViewController(animated: true)
                        
                    })
                }
            }
        }
        
        
        dismiss(animated: true, completion: nil)
    }
}
