//
//  LocalSettings.swift
//  DHBW-Service
//
//  Created by Patrick Müller on 21.12.20.
//

import Foundation
import Combine

private var cancellables = [String:AnyCancellable]()

extension Published {
    init(wrappedValue defaultValue: Value, key: String) {
        let value = UserDefaults.standard.object(forKey: key) as? Value ?? defaultValue
        self.init(initialValue: value)
        cancellables[key] = projectedValue.sink { val in
            UserDefaults.standard.set(val, forKey: key)
        }
    }
}

class LocalSettings: ObservableObject {
    @Published(wrappedValue: true, key: "IsFirstOpening") var isFirstOpening: Bool // To determine if the user is logged in
}
