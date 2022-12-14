//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Berat Yavuz on 16.09.2022.
//

import Foundation
import Combine
class HomeViewModel:ObservableObject {
    @Published var statistics:[StatisticModel] = []
    @Published var searchText: String = ""
    @Published var allCoins : [CoinModel] = []
    @Published var portfolioCoin : [CoinModel] = []
    @Published var isLoading : Bool = false
    @Published var sortOption : SortOption = .holdings
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
        case rank,rankReversed,holdings,holdingsReversed,price,priceReversed
    }
    init(){
        addSubscriber()
    }
    func addSubscriber() {
        $searchText
            .combineLatest(coinDataService.$allCoins,$sortOption)
        // delay for search process
            .debounce(for:.seconds(0.4), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        //update portfolioCoins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] (returnedCoins) in
                guard let self = self else {return}
                
                self.portfolioCoin = self.sortPortfolioCoinsÄ°fNeeded(coins: returnedCoins)
                
            }
            .store(in: &cancellables)
        
        //update marketData
        marketDataService.$marketData
            .combineLatest($portfolioCoin)
            .map(mapGlobalMarketData)
            .sink { [weak self ] (returnedStats)  in
                self?.statistics = returnedStats
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    func reloadData(){
        self.isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success)
        
    }
    private func filterAndSortCoins(text:String,coins:[CoinModel],sort:SortOption)->[CoinModel]{
        var updatedCoins = filterCoins(text: text, coins: coins)
        sortCoins(coins: &updatedCoins, sort: sort)
        return updatedCoins
    }
    private func sortCoins(coins:inout [CoinModel],sort:SortOption)  {
        switch sort{
        case .holdings,.rank:
             coins.sort(by: {$0.rank < $1.rank})
            
        case .holdingsReversed,.rankReversed:
             coins.sort(by: {$0.rank > $1.rank})
            
        case .price:
             coins.sort(by: {$0.currentPrice > $1.currentPrice})
        case .priceReversed:
             coins.sort(by: {$0.currentPrice < $1.currentPrice})
        }
    }
    private func sortPortfolioCoinsÄ°fNeeded(coins:[CoinModel]) -> [CoinModel]{
        switch sortOption {
       
        case .holdings:
            return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
        case .holdingsReversed:
            return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
        default:
            return coins

    }
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
    
    private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel],PortfolioEntities: [PortfolioEntity]) -> [CoinModel] {
        allCoins
            .compactMap { (coin) -> CoinModel? in
                guard let entity = PortfolioEntities.first(where: { $0.coinID == coin.id}) else {return nil}
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?,portfolioCoins:[CoinModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        
        guard let data = marketDataModel else {
            return stats
        }
        let portfolioValue =
        portfolioCoins
            .map({$0.currentHoldingsValue})
            .reduce(0, +)
        let previousValue =
        portfolioCoins
            .map { (coin) -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentChange = coin.priceChangePercentage24H ?? 0 / 160
                let previousValue = currentValue / (1 + percentChange)
                return previousValue
            }
            .reduce(0, +)
        
        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24th Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = StatisticModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        return stats
    }
    
}


