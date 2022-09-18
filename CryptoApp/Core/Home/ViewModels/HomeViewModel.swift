//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Berat Yavuz on 16.09.2022.
//

import Foundation
import Combine
class HomeViewModel:ObservableObject {
    @Published var allCoins : [CoinModel] = []
    @Published var portfolioCoin : [CoinModel] = []
    
    private let dataService = CoinDataService()
    
    private var cancellables = Set<AnyCancellable>()
    init(){
       addSubscriber()
        }
    func addSubscriber() {
        dataService.$allCoins
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
    }
    }
    

