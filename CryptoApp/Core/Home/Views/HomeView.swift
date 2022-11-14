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
        Text("Coin")
            Spacer()
            if showPortfolio {
                Text("Holding")
            }
            Text("Price")
                .frame(width:UIScreen.main.bounds.width/3)
        }
        
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
   
}
