//
//  CoinDetailDataService.swift
//  CryptoApp
//
//  Created by Berat Yavuz on 26.11.2022.
//

import Foundation
import Combine
class CoinDetailDataService {
 
    @Published var coinDetails : CoinDetailModel?
    
    var coinDetailSubscripton: AnyCancellable?
    let coin:CoinModel
    
    init(coin:CoinModel) {
        self.coin = coin
        getCoinDetails()    }
    
     func getCoinDetails() {
         guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false")
        else{return}
        
        coinDetailSubscripton = NetworkingManager.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleComplation , receiveValue: {  [weak self] (returnedCoinDetail) in
                self?.coinDetails = returnedCoinDetail
                self?.coinDetailSubscripton?.cancel()
            })
    }

}
