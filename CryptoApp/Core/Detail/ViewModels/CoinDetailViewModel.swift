//
//  CoinDetailViewModel.swift
//  CryptoApp
//
//  Created by Berat Yavuz on 26.11.2022.
//

import Foundation
import Combine

class CoinDetailViewModel:ObservableObject {
   private let coinDetailDataService:CoinDetailDataService
    
    private var cancellables = Set<AnyCancellable>()
    init(coin:CoinModel){
        coinDetailDataService = CoinDetailDataService(coin: coin)
        addSubscribers()
    }
    
    private func addSubscribers(){
        coinDetailDataService.$coinDetails
            .sink { (returnedCoinDetails) in
                print(returnedCoinDetails)
            }
            .store(in: &cancellables)
    }
}
