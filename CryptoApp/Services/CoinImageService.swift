//
//  CoinImageService.swift
//  CryptoApp
//
//  Created by Berat Yavuz on 18.09.2022.
//

import Foundation
import UIKit
import Combine

class CoinImageService {
    @Published var image : UIImage? = nil
    private var imageSubscripton: AnyCancellable?
    private let coin : CoinModel
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String
    
    init(coin:CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
        
    }
    
    private func getCoinImage() {
        
        if let savedImage = fileManager.getImage(imageName: coin.id, folderName: folderName) {
            image = savedImage
            print("Retrieved image from file manager")
        }
        else {
            downloadCoinImage()
        }
        
    }
    
    private func downloadCoinImage() {
        guard let url = URL(string: coin.image) else{return}
        
        imageSubscripton = NetworkingManager.download(url: url)
            .tryMap({ (data)  -> UIImage? in
                return UIImage(data: data)
            })
        
            .sink(receiveCompletion: NetworkingManager.handleComplation , receiveValue: {  [weak self] (returnedImage) in
                guard let self = self, let downloadedImage = returnedImage else {return}
                self.image = downloadedImage
                self.imageSubscripton?.cancel()
                self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
            })
    }
    
    
}
