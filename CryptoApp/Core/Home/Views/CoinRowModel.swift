//
//  CoinRowModel.swift
//  CryptoApp
//
//  Created by Berat Yavuz on 12.09.2022.
//

import SwiftUI

struct CoinRowModel: View {
    
    let coin : CoinModel
    let showHoldingColumn : Bool
    
    var body: some View {
        HStack(spacing:0) {
            leftColumn
            Spacer()
            if showHoldingColumn {
                centerColumn
            }
            rightColumn
        }
        .font(.subheadline)
        .background(Color.theme.background.opacity(0.001))
    }
}

struct CoinRowModel_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinRowModel(coin: dev.coin, showHoldingColumn: true)
                .previewLayout(.sizeThatFits)
            CoinRowModel(coin: dev.coin, showHoldingColumn: true)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}

extension CoinRowModel {
    
    private var leftColumn: some View {
        HStack(spacing:0){
            Text("\(coin.rank )")
                .frame(minWidth:30)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
            CoinImageView(coin: coin)
                .frame(width: 20, height: 20, alignment: .center)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding()
        }
    }
    
    private var centerColumn: some View {
        VStack(alignment: .trailing){
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
        .foregroundColor(Color.theme.accent)
    }
    
    private var rightColumn: some View {
        VStack(alignment:.trailing) {
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .bold()
                .foregroundColor(Color.theme.accent)
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .foregroundColor (
                    (coin.priceChangePercentage24H ?? 0 ) >= 0 ?
                    Color.theme.green :
                        Color.theme.red
                )
        }.frame(width:UIScreen.main.bounds.width/3.5)
    }
    
}

