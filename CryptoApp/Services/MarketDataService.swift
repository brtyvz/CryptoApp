//
//  MarketDataService.swift
//  CryptoApp
//
//  Created by Berat Yavuz on 12.11.2022.
//




import Foundation
import Combine
class MarketDataService {
 
    @Published var marketData : MarketDataModel? = nil
    
    var marketDataSubscripton: AnyCancellable?
    
    init() {
        getData()
    }
    
    private func getData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global")
        else{return}
        
        marketDataSubscripton = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleComplation , receiveValue: {  [weak self] (returnedGlobalData) in
                self?.marketData = returnedGlobalData.data
                self?.marketDataSubscripton?.cancel()
            })
    }

}
