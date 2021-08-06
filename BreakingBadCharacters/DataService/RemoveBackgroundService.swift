//
//  RemoveBackgroundService.swift
//  BreakingBadCharacters
//
//  Created by Felix Fischer on 06/08/2021.
//

import Foundation
import UIKit
import Vision

class RemoveBackgroundService {
    
    static func removeBackground(of image: UIImage, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let model = getDeepLabV3Model() else { return }
            let width: CGFloat = 513
            let height: CGFloat = 513
            let resizedImage = image.resized(to: CGSize(width: height, height: height), scale: 1)
            guard let pixelBuffer = resizedImage.pixelBuffer(width: Int(width), height: Int(height)),
                  let outputPredictionImage = try? model.prediction(image: pixelBuffer),
                  let outputImage = outputPredictionImage.semanticPredictions.image(min: 0, max: 1, axes: (0, 0, 1)),
                  let outputCIImage = CIImage(image: outputImage),
                  let maskImage = outputCIImage.removeWhitePixels(),
                  let maskBlurImage = maskImage.applyBlurEffect() else { return }
            
            guard let resizedCIImage = CIImage(image: resizedImage),
                  let compositedImage = resizedCIImage.composite(with: maskBlurImage) else { return }
            let finalImage = UIImage(ciImage: compositedImage)
                .resized(to: CGSize(width: image.size.width, height: image.size.height))
            
            DispatchQueue.main.async {
                completion(finalImage)
            }
        }
    }
    
    private static func getDeepLabV3Model() -> DeepLabV3? {
        do {
            let config = MLModelConfiguration()
            return try DeepLabV3(configuration: config)
        } catch {
            print("Error loading model: \(error)")
            return nil
        }
    }
    
}
