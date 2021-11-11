//
//  ViewController.swift
//  TrashApp
//
//  Created by Paratthakorn Sribunyong on 25/8/2564 BE.
//

import UIKit



class ViewController: UIViewController {
    
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var chooseButton: UIButton!
    
    private var targetImageView = UIImageView()
    private var manager: ImageManager = ImageManager()
    
    var picker = UIImagePickerController();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cameraButton.addTarget(self, action: #selector(didTapCamera), for: .touchUpInside)
        chooseButton.addTarget(self, action: #selector(didTapChoose), for: .touchUpInside)
        picker.delegate = self
        
    }
    
    
    @objc private func didTapCamera() {
        let cameraVC = CameraViewController()
        navigationController?.pushViewController(cameraVC, animated: true)
    }
    
    @objc private func didTapChoose() {
        openGallery()
    }
    
    func openGallery(){
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func pendingAlert() -> UIAlertController {
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
        
        return pending
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[UIImagePickerController.InfoKey.originalImage] != nil, let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            targetImageView.image = originalImage
            //            print("Png data : \((self.targetImageView.image?.pngData())!)")
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
                        
                    })
                }
            }
            
        }
        
        
        dismiss(animated: true, completion: nil)
    }
}
