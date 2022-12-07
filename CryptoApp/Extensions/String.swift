//
//  String.swift
//  CryptoApp
//
//  Created by Berat Yavuz on 7.12.2022.
//

import Foundation

extension String {
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
