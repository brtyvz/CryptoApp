//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Berat Yavuz on 16.09.2022.
//

import Foundation
import Combine
class HomeViewModel:ObservableObject {
    @Published var statistics:[StatisticModel] = [
    StatisticModel(title: "Title", value: "Value", percentageChange: 1),
    StatisticModel(title: "Title", value: "Value"),
    StatisticModel(title: "Title", value: "Value", percentageChange: -1),
    StatisticModel(title: "Title", value: "Value")
    ]
    @Published var searchText: String = ""
    @Published var allCoins : [CoinModel] = []
    @Published var portfolioCoin : [CoinModel] = []
    
    private let dataService = CoinDataService()
    
    private var cancellables = Set<AnyCancellable>()
    init(){
       addSubscriber()
        }
    func addSubscriber() {
        $searchText
        .combineLatest(dataService.$allCoins)
        // delay for search process
        .debounce(for:.seconds(0.4), scheduler: DispatchQueue.main)
        .map(filterCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
    }
    
    private func filterCoins(text:String,coins:[CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins
        }
        let lowercasedText = text.lowercased()
        
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText)
        }
        
        
    }
    
    
    }
    

