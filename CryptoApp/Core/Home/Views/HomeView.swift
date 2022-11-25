//
//  HomeView.swift
//  CryptoApp
//
//  Created by Berat Yavuz on 8.09.2022.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm : HomeViewModel
    @State private var showPortfolio: Bool = false //
    @State private var showPortfolioView: Bool = false
    
    var body: some View {
        ZStack {
            //Backgorund Layer
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView, content: {
                    PortfolioView()
                        .environmentObject(vm)
                }
                )
            // content layer
            VStack {
         homeHeader
                HomeStatsView(showPortfolio: $showPortfolio)
                SearchBarView(searchText:$vm.searchText )
               columnTitles
                if !showPortfolio {
                    allCoinList
                        .transition(.move(edge: .leading))
                }
                if showPortfolio {
                    portfolioCoinList
                        .transition(.move(edge: .trailing))
                }
                Spacer(minLength: 0)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .preferredColorScheme(.light )
                .navigationBarHidden(true)
        }
        .environmentObject(dev.homeVm)
      
    }
}


extension HomeView {
    private var homeHeader : some View {
        
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none)
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                            
                    }
                }
      
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180:0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
        
    }
    
    private var allCoinList : some View {
        
        List{
            ForEach(vm.allCoins) { coin in
                CoinRowModel(coin: coin, showHoldingColumn: false)
            }
        }
        .listStyle(PlainListStyle())
    }

    private var portfolioCoinList : some View {
        
        List{
            ForEach(vm.portfolioCoin) { coin in
                CoinRowModel(coin: coin, showHoldingColumn: true)
            }
        }
        .listStyle(PlainListStyle())
    }
    private var columnTitles : some View {
        
        HStack {
            HStack(spacing:4){
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation {
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed: .rank
                }
            }
        
            Spacer()
            if showPortfolio {
                HStack(spacing:4){
                    Text("Holding")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortOption == .holdings || vm.sortOption == .holdingsReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))

                }
                .onTapGesture {
                    withAnimation {
                        vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed: .holdings
                    }
                }
            }
            HStack(spacing:4){
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))

            }
            .onTapGesture {
                withAnimation {
                    vm.sortOption = vm.sortOption == .price ? .priceReversed: .price
                }
            }
            .frame(width:UIScreen.main.bounds.width/3.5,alignment: .trailing)
            Button( action:{
                withAnimation(.linear(duration: 2.0)) {
                    vm.reloadData()
                }
                
            },label: {
                Image(systemName: "goforward")
            })
            .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0),anchor: .center)

        }
        
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
   
}
