//
//  Extensions.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/22/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import Foundation

extension Data{
    func createList<T: Codable>(type: T.Type) -> [T]{
        return try! JSONDecoder().decode([T].self, from: self)
    }
    
    func create<T: Codable>(type: T.Type) -> T{
        return try! JSONDecoder().decode(T.self, from: self)
    }
}
