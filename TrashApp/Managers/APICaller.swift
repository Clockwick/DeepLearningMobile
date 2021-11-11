//
//  APICaller.swift
//  TrashApp
//
//  Created by Paratthakorn Sribunyong on 25/8/2564 BE.
//

import UIKit
import Alamofire

struct Endpoints
{
    static let uploadImageMultiPartForm = "https://5b08-2403-6200-88a0-590-8d45-ebb1-a77b-6550.ngrok.io/predict"
}

struct ImageManager
{
    
    enum ImageUploadError: Error {
        case imageUploadError
    }
    func uploadImage(data: Data, completionHandler: @escaping(_ result: Result<ImageResponse, ImageUploadError>) -> Void)
    {
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(Data(data), withName: "filename", fileName: "multipart.png", mimeType: "image/png")
        }, to: Endpoints.uploadImageMultiPartForm)
            .responseDecodable(of: ImageResponse.self) { response in
                guard let responseValue = response.value else {
                    completionHandler(.failure(.imageUploadError))
                    return
                }
                completionHandler(.success(responseValue))
            }
    }
    
}

