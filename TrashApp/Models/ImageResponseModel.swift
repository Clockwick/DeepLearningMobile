//
//  ImageResponseModel.swift
//  TrashApp
//
//  Created by Paratthakorn Sribunyong on 25/8/2564 BE.
//

import Foundation

struct ImageResponse : Decodable
{
    let success: Int
    let accuracy: Float
    let value: String
}
