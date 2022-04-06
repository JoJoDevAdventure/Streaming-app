//
//  Extensions.swift
//  Netflix Clone
//
//  Created by Youssef Bhl on 06/04/2022.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
