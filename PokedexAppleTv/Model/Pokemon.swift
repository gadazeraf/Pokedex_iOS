//
//  Pokemon.swift
//  Pokedex
//
//  Created by Gad on 03/10/2019.
//  Copyright © 2019 Azeraf. All rights reserved.
//

import UIKit


class Pokemon: Codable {
    private var _id: Int
    private var _name: String
    private var _pokedex_number: Int
    private var _height: String
    private var _weight: String
    private var _desc: String
    private var _pre_evolution_id: Int?
    private var _type1: String
    private var _type2: String?
    
    var id: Int {
        get { return _id }
        set { _id = id }
    }
    
    var name: String {
        get { return _name }
        set { _name = name }
    }
    
    var pokedex_number: Int {
        get { return _pokedex_number }
        set { _pokedex_number = pokedex_number }
    }
    
    var height: String {
        get { return _height }
        set { _height = height }
    }
    
    var weight: String {
        get { return _weight }
        set { _weight = weight }
    }
    
    var desc: String {
        get { return _desc }
        set { _desc = desc }
    }
    
    var pre_evolution_id: Int? {
        get { return _pre_evolution_id ?? nil }
        set { _pre_evolution_id = pre_evolution_id }
    }
    
    var type1: String {
        get { return _type1 }
        set { _type1 = type1 }
    }
    
    var type2: String? {
        get { return _type2 ?? nil }
        set { _type2 = type2 }
    }
    
    init(id: Int, name: String, pokedex_number: Int, height: String, weight: String, desc: String, pre_evolution_id: Int?, type1: String, type2: String?) {
        _id = id
        _name = name
        _pokedex_number = pokedex_number
        _height = height
        _weight = weight
        _desc = desc
        _pre_evolution_id = pre_evolution_id ?? nil
        _type1 = type1
        _type2 = type2 ?? nil
    }
}
