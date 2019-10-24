//
//  LoadDataHelper.swift
//  PokedexCoreData
//
//  Created by Gad on 24/10/2019.
//  Copyright © 2019 Azeraf. All rights reserved.
//

import Alamofire
import CoreData

extension ViewController {
    
    func loadTableView() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let dataFetch = NSFetchRequest<Pokemon>(entityName: "Pokemon")
        
        do {
            self.pokemon = try context.fetch(dataFetch)
        } catch {
            fatalError("could not fetch")
        }
    }
    
    func loadData(){        Alamofire.request("https://pokedex-mti.twitchytv.live/pokemon/generate")
        .responseJSON(completionHandler: { (response) in
            switch response.result {
            case let .success(value):
                let jsonData = value as! NSDictionary
                let (attack1, attack1_type) = self.getAttack(attack: jsonData.value(forKey: "attack1"))
                let (attack2, attack2_type) = self.getAttack(attack: jsonData.value(forKey: "attack2"))
                let (attack3, attack3_type) = self.getAttack(attack: jsonData.value(forKey: "attack3"))
                let (attack4, attack4_type) = self.getAttack(attack: jsonData.value(forKey: "attack4"))
                
                let (species_name, species_number, species_t1_name, species_t2_name) = self.getSpecies(species: jsonData.value(forKey: "species"))
                
                let level = jsonData.value(forKey: "level") as? integer_t ?? 0
                let shiny = jsonData.value(forKey: "shiny") as? Bool ?? false
                
                self.savePokemon(nickname: "null", level: level, shiny: shiny, species_name: species_name, species_number: species_number, species_t1_name: species_t1_name, species_t2_name: species_t2_name, attack1: attack1, attack1_type: attack1_type, attack2: attack2, attack2_type: attack2_type, attack3: attack3, attack3_type: attack3_type, attack4: attack4, attack4_type: attack4_type)
                
                self.launchModal(species_name: species_name, species_number: species_number, species_t1_name: species_t1_name, species_t2_name: species_t2_name, level: level, shiny: shiny, attack1: attack1, attack1_type: attack1_type, attack2: attack2, attack2_type: attack2_type, attack3: attack3, attack3_type: attack3_type, attack4: attack4, attack4_type: attack4_type)
                
            case .failure(_):
                fatalError("search error occured")
            }
        })
    }
    
    func launchModal(species_name: String, species_number: integer_t, species_t1_name: String, species_t2_name: String, level: integer_t, shiny: Bool,attack1: String, attack1_type: String, attack2: String, attack2_type: String, attack3: String, attack3_type: String, attack4: String, attack4_type: String) {
        let modalVC = self.storyboard?.instantiateViewController(withIdentifier: "modalView") as! ModalViewController
        modalVC.name = species_name
        modalVC.id = species_number
        modalVC.type1 = species_t1_name
        modalVC.type2 = species_t2_name
        modalVC.lvl = level
        modalVC.shiny = shiny
        modalVC.attack1 = attack1
        modalVC.typea1 = attack1_type
        modalVC.attack2 = attack2
        modalVC.typea2 = attack2_type
        modalVC.attack3 = attack3
        modalVC.typea3 = attack3_type
        modalVC.attack4 = attack4
        modalVC.typea4 = attack4_type
        modalVC.transitioningDelegate = self
        modalVC.modalPresentationStyle = .custom
        self.navigationController?.present(modalVC, animated: true, completion:
            nil)
    }
    
    func searchLaunchModal(list: [Pokemon], indexPath: IndexPath) {
        launchModal(species_name: list[indexPath.row].species!.name!
            , species_number: list[indexPath.row].species!.pokedex_number, species_t1_name: list[indexPath.row].species!.type1!.name!, species_t2_name: list[indexPath.row].species!.type2?.name ?? "null", level: list[indexPath.row].level, shiny: list[indexPath.row].shiny, attack1: list[indexPath.row].attack1!.name!, attack1_type: list[indexPath.row].attack1!.type!.name!, attack2: list[indexPath.row].attack2?.name ?? "null", attack2_type: list[indexPath.row].attack2?.type?.name ?? "null", attack3: list[indexPath.row].attack3?.name ?? "null", attack3_type: list[indexPath.row].attack3?.type?.name ?? "null", attack4: list[indexPath.row].attack4?.name ?? "null", attack4_type: list[indexPath.row].attack4?.type?.name ?? "null")
    }
    
    func getAttack(attack: Any?) -> (String, String) {
        if let val = attack as? NSDictionary {
            if let type = val.value(forKey: "type") as? NSDictionary {
                return (val.value(forKey: "name") as? String ?? "null", type.value(forKey: "name") as? String ?? "null")
            }
        }
        return ("null", "null")
    }
    
    func getType2(type: Any?) -> String {
        if let type2data = type as? NSDictionary {
            return type2data.value(forKey: "name") as? String ?? "null"
        } else {
            return "null"
        }
    }
    
    func getSpecies(species: Any?) -> (String, integer_t, String, String) {
        var (species_name, species_number, species_t1_name, species_t2_name) = ("null", integer_t(0), "null", "null")
        if let val = species as? NSDictionary {
            species_name = val.value(forKey: "name") as? String ?? "null"
            species_number = val.value(forKey: "pokedex_number") as? integer_t ?? 0
            species_t2_name = getType2(type: val.value(forKey: "type2"))
            if let type1 = val.value(forKey: "type1") as? NSDictionary {
                species_t1_name = type1.value(forKey: "name") as? String ?? "null"
            }
        }
        return (species_name, species_number, species_t1_name, species_t2_name)
    }
    
    func savePokemon(nickname: String, level: integer_t, shiny: Bool, species_name: String, species_number: integer_t, species_t1_name: String, species_t2_name: String, attack1: String, attack1_type: String, attack2: String, attack2_type: String, attack3: String, attack3_type: String, attack4: String, attack4_type: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let pokemon : Pokemon = NSEntityDescription.insertNewObject(forEntityName: "Pokemon", into: context) as! Pokemon
        
        pokemon.nickname = nickname
        pokemon.level = level
        pokemon.shiny = shiny
        pokemon.species = saveSpecies(name: species_name, pokedex_number: species_number, type1_name: species_t1_name, type2_name: species_t2_name)
        pokemon.attack1 = saveAttack(name: attack1, type: attack1_type)
        pokemon.attack2 = saveAttack(name: attack2, type: attack2_type)
        pokemon.attack3 = saveAttack(name: attack3, type: attack3_type)
        pokemon.attack4 = saveAttack(name: attack4, type: attack4_type)
        
        
        do {
            try context.save()
        } catch {
            fatalError("Failed saving")
        }
    }
    
    func saveSpecies(name: String, pokedex_number: integer_t, type1_name: String, type2_name: String) -> Species {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let speciesFetch = NSFetchRequest<Species>(entityName: "Species")
        speciesFetch.predicate = NSPredicate(format: "pokedex_number == %ld", pokedex_number)
        
        do {
            let speciesFetched = try context.fetch(speciesFetch)
            if (speciesFetched.isEmpty) {
                let species : Species = NSEntityDescription.insertNewObject(forEntityName: "Species", into: context) as! Species
                species.id = UUID()
                species.name = name
                species.pokedex_number = pokedex_number
                species.type1 = savePokemonType(name: type1_name)
                species.type2 = savePokemonType(name: type2_name)
                return species
            } else {
                return speciesFetched[0]
            }
        } catch {
            fatalError("fetch species failed")
        }
    }
    
    func saveAttack(name: String, type: String) -> Attack {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let AttackFetch = NSFetchRequest<Attack>(entityName: "Attack")
        AttackFetch.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let AttackFetched = try context.fetch(AttackFetch)
            if (AttackFetched.isEmpty) {
                let attack : Attack = NSEntityDescription.insertNewObject(forEntityName: "Attack", into: context) as! Attack
                attack.id = UUID()
                attack.name = name
                attack.type = savePokemonType(name: type)
                return attack
            } else {
                return AttackFetched[0]
            }
        } catch {
            fatalError("Fetch Attack failed")
        }
    }
    
    func savePokemonType(name: String) -> PokemonType {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let pokemonTypeFetch = NSFetchRequest<PokemonType>(entityName: "PokemonType")
        pokemonTypeFetch.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let pokemonTypeFetched = try context.fetch(pokemonTypeFetch)
            if (pokemonTypeFetched.isEmpty) {
                let pokemonType : PokemonType = NSEntityDescription.insertNewObject(forEntityName: "PokemonType", into: context) as! PokemonType
                pokemonType.id = UUID()
                pokemonType.name = name
                return pokemonType
            } else {
                return pokemonTypeFetched[0]
            }
        } catch {
            fatalError("Fetch PokemonType failed")
        }
    }
    
}
