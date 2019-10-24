//
//  PokemonCollection.swift
//  Pokedex
//
//  Created by Gad on 03/10/2019.
//  Copyright © 2019 Azeraf. All rights reserved.
//

import UIKit
import Alamofire

class PokemonCollection: NSObject {
    
    func loadData() -> [Pokemon] {
        var pokemons: [Pokemon] = []
        Alamofire.request("https://pokedex-mti.twitchytv.live/species")
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case let .success(value):
                    let jsonData = value as! NSArray
                    for json in jsonData {
                        let data = json as! NSDictionary
                        guard let name = data.value(forKey: "name") else { return }
                        guard let height = data.value(forKey: "height") else { return }
                        guard let id = data.value(forKey: "id") else { return }
                        guard let pokedex_number = data.value(forKey: "pokedex_number") else { return }
                        guard let pre_evolution_id = data.value(forKey: "pre_evolution_id") else { return }
                        let pre_evolution_id_data = pre_evolution_id as? NSNumber
                        guard let weight = data.value(forKey: "weight") else { return }
                        guard let description = data.value(forKey: "description") else { return }
                        guard let type1 = data.value(forKey: "type1") else { return }
                        let type1data = type1 as! NSDictionary
                        guard let type1name = type1data.value(forKey: "name") else { return }
                        guard let type2 = data.value(forKey: "type2") else { return }
                        var type2name: String?
                        if let type2data = type2 as? NSDictionary {
                            type2name = type2data.value(forKey: "name") as? String
                        } else {
                            type2name = nil
                        }
                        pokemons.append(Pokemon(id: id as! Int, name: name as! String, pokedex_number: pokedex_number as! Int, height: height as! String, weight: weight as! String, desc: description as! String, pre_evolution_id: pre_evolution_id_data as? Int, type1: type1name as! String, type2: type2name))
                    }
                case .failure(_):
                    fatalError("image search error occured")
                }
            })
        return pokemons
    }
    
    
    
    func all() -> [Pokemon]{
        var pokemons = loadData()
        pokemons.append(Pokemon(id: 1, name: "Bulbbhasaur", pokedex_number: 1, height: "0.70", weight: "6.90", desc: "A strange seed was planted..", pre_evolution_id: nil, type1: "Grass", type2: "Poison"))
        return pokemons
    }
}

extension JSONDecoder {
    func decodeResponse<T: Decodable>(from response: DataResponse<Data>) -> Result<T> {
        guard response.error == nil else {
            print(response.error!)
            return .failure(response.error!)
        }
        
        guard let responseData = response.data else {
            print("didn't get any data from API")
            return .failure(
                "Did not get data in response" as! Error)
        }
        
        do {
            let item = try decode(T.self, from: responseData)
            return .success(item)
        } catch {
            print("error trying to decode response")
            return .failure(error)
        }
    }
}
