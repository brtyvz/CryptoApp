//
//  DetailView.swift
//  CryptoApp
//
//  Created by Berat Yavuz on 26.11.2022.
//

import SwiftUI

struct DetailLoadingView:View {
    @Binding var coin:CoinModel?
    
    var body: some View {
       
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
       
    }
}


struct DetailView: View {
    @StateObject var vm:CoinDetailViewModel
    init(coin:CoinModel){
        _vm = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
        print("init for\(coin.name)")
    }
    var body: some View {
  Text("name")
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(coin: dev.coin)
    }
}
