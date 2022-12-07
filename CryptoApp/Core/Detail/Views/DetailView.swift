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
    @StateObject private var vm:CoinDetailViewModel
    @State var showFullDescription: Bool = false
    private let columns:[GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
        
    ]
    private let spacing:CGFloat = 30
    init(coin:CoinModel){
        _vm = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
        print("init for\(coin.name)")
    }
    var body: some View {
        
        ScrollView {
            VStack {
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                VStack() {
                    overviewTitle
                    Divider()
                descriptionSection
                    overviewGrid
                    
                    additionalTitle
                    Divider()
                    additionalGrid
                    websiteSection
                 
                }
                .padding()
            }
         
        }
        .navigationTitle(vm.coin.name)
        .toolbar {
            ToolbarItem(placement:.navigationBarTrailing) {
                navigationBarTrailingItem
            }
           
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coin)
        }
        
    }
}

extension DetailView {
    
    private var navigationBarTrailingItem: some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
        }

    }
    
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.accentColor)
            .frame(maxWidth:.infinity,alignment:.leading)
    }
    private var descriptionSection:some View {
        ZStack {
            if let coinDescription = vm.coinDescription,
               !coinDescription.isEmpty {
                VStack(alignment:.leading, spacing:20) {
                    Text(coinDescription)
                        .lineLimit(  showFullDescription ? nil : 3)
                    Button {
                        withAnimation(.easeInOut){
                            showFullDescription.toggle()
                        }
                    } label: {
                        Text(showFullDescription ? "Less..":"Read More..")
                            .bold()
                            .accentColor(.blue)
                    }
                    .frame(maxWidth: .infinity,alignment: .leading)
                }
            }
        }
    }
    private var additionalTitle:some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.accentColor)
            .frame(maxWidth:.infinity,alignment:.leading)
    }
    private var overviewGrid: some View {
        LazyVGrid(columns:columns,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: [],
                  content: {
            ForEach(vm.overviewStatistics) {stat in
                StatisticView(stat: stat)
            }
        })
    }
    private var additionalGrid: some View {
        
        LazyVGrid(columns:columns,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: [],
                  content: {
            ForEach(vm.additionalStatistics) { stat in
                StatisticView(stat:stat )
            }
        })
    }
    private var websiteSection:some View {
        VStack(alignment:.leading,spacing: 20) {
            if let webUrl = vm.websiteURL,
               let url = URL(string: webUrl){
                Link("Website",destination: url)
            }
            
            if let redditUrl = vm.redditURL,
               let url = URL(string: redditUrl) {
                Link("Reddit",destination:url)
            }
        }
        .accentColor(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
    
}
