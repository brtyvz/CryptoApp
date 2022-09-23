//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by Berat Yavuz on 7.09.2022.
//

import SwiftUI

@main
struct CryptoApp: App {
    @StateObject private var vm = HomeViewModel()
    var body: some Scene {
       
        WindowGroup {
            NavigationView{
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
           
        }
    }
}
