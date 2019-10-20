//
//  ViewController.swift
//  PokedexCoreData
//
//  Created by Gad on 04/10/2019.
//  Copyright © 2019 Azeraf. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate {

    var pokemon: [Pokemon] = []
    var pokemonNow: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let dataFetch = NSFetchRequest<Pokemon>(entityName: "Pokemon")
        
        do {
            self.pokemon = try context.fetch(dataFetch)
        } catch {
            print("could not fetch")
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemon.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ContentTableViewCell
        cell.PokName.text = pokemon[indexPath.row].species?.name
        cell.PokNumber.text = "# \(pokemon[indexPath.row].species?.pokedex_number ?? 0)"
        cell.PokImg.download(string: "http://pokedex-mti.twitchytv.live/images/\(pokemon[indexPath.row].species?.pokedex_number ?? 0).png")
        return cell
    }
    
    @IBAction func buttonAddPressed(_ sender: Any) {
        loadData()
        
    }
    
    
    func loadData(/*completionHandler: @escaping (_ result:[Pokemon]) -> Void*/ ){
        //var pokemons: [Pokemon] = []
        Alamofire.request("https://pokedex-mti.twitchytv.live/pokemon/generate")
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case let .success(value):
                    // save pokemon
                    let jsonData = value as! NSDictionary
                    print("json", jsonData)
                    let (attack1, attack1_type) = self.getAttack(attack: jsonData.value(forKey: "attack1"))
                    let (attack2, attack2_type) = self.getAttack(attack: jsonData.value(forKey: "attack2"))
                    let (attack3, attack3_type) = self.getAttack(attack: jsonData.value(forKey: "attack3"))
                    let (attack4, attack4_type) = self.getAttack(attack: jsonData.value(forKey: "attack4"))
                    
                    let (species_name, species_number, species_t1_name, species_t2_name) = self.getSpecies(species: jsonData.value(forKey: "species"))
                    
                    let level = jsonData.value(forKey: "level") as? integer_t ?? 0
                    let shiny = jsonData.value(forKey: "shiny") as? Bool ?? false
                    
                    self.savePokemon(nickname: "null", level: level, shiny: shiny, species_name: species_name, species_number: species_number, species_t1_name: species_t1_name, species_t2_name: species_t2_name, attack1: attack1, attack1_type: attack1_type, attack2: attack2, attack2_type: attack2_type, attack3: attack3, attack3_type: attack3_type, attack4: attack4, attack4_type: attack4_type)
                    
                    print("result", level, shiny, species_name, species_t2_name, attack3, attack3_type, attack1, attack1_type)
                    
                    //launch modal
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
                    
                    

                case .failure(_):
                    print("search error occured")
                }
                /*completionHandler(pokemons) */})
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
        self.pokemonNow = species_name
        return (species_name, species_number, species_t1_name, species_t2_name)
    }
    
    func savePokemon(nickname: String, level: integer_t, shiny: Bool, species_name: String, species_number: integer_t, species_t1_name: String, species_t2_name: String, attack1: String, attack1_type: String, attack2: String, attack2_type: String, attack3: String, attack3_type: String, attack4: String, attack4_type: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let pokemon : Pokemon = NSEntityDescription.insertNewObject(forEntityName: "Pokemon", into: context) as! Pokemon
        
        pokemon.nickname = nickname
        pokemon.level = level
        pokemon.shiny = shiny
        // species test
         // species save
        pokemon.species = saveSpecies(name: species_name, pokedex_number: species_number, type1_name: species_t1_name, type2_name: species_t2_name)
        // attacks tests
         //attack test
        pokemon.attack1 = saveAttack(name: attack1, type: attack1_type)
        pokemon.attack2 = saveAttack(name: attack2, type: attack2_type)
        pokemon.attack3 = saveAttack(name: attack3, type: attack3_type)
        pokemon.attack4 = saveAttack(name: attack4, type: attack4_type)
        
        
        do {
            try context.save()
        } catch let _ {
            print("Failed saving")
        }
    }
    
    // saveSpecies
    func saveSpecies(name: String, pokedex_number: integer_t, type1_name: String, type2_name: String) -> Species {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let speciesFetch = NSFetchRequest<Species>(entityName: "Species")
        speciesFetch.predicate = NSPredicate(format: "pokedex_number == %ld", pokedex_number)
        
        do {
            //wait to improve this
            let speciesFetched = try context.fetch(speciesFetch)
            if (speciesFetched.isEmpty) {
                let species : Species = NSEntityDescription.insertNewObject(forEntityName: "Species", into: context) as! Species
                species.id = UUID()
                species.name = name
                species.pokedex_number = pokedex_number
                //types
                species.type1 = savePokemonType(name: type1_name)
                species.type2 = savePokemonType(name: type2_name)
                return species
            } else {
                return speciesFetched[0]
            }
        } catch {
            let species : Species = NSEntityDescription.insertNewObject(forEntityName: "Species", into: context) as! Species
            species.id = UUID()
            species.name = name
            species.pokedex_number = pokedex_number
            //types
            species.type1 = savePokemonType(name: type1_name)
            species.type2 = savePokemonType(name: type2_name)
            return species
        }
    }
    
    
    // saveAttacks
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
            let attack : Attack = NSEntityDescription.insertNewObject(forEntityName: "Attack", into: context) as! Attack
            attack.id = UUID()
            attack.name = name
            attack.type = savePokemonType(name: type)
            return attack
        }
    }
    

    //savePokemonType
    func savePokemonType(name: String) -> PokemonType {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let pokemonTypeFetch = NSFetchRequest<PokemonType>(entityName: "PokemonType")
        pokemonTypeFetch.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            //wait to improve this
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
            let pokemonType : PokemonType = NSEntityDescription.insertNewObject(forEntityName: "PokemonType", into: context) as! PokemonType
            pokemonType.id = UUID()
            pokemonType.name = name
            return pokemonType
        }
    }
    
    @IBAction func unwindToMainPage(sender: UIStoryboardSegue) {
        self.tableView.reloadData()
    }
    
    
}

class ContentTableViewCell: UITableViewCell {
    @IBOutlet weak var PokImg: UIImageView!
    @IBOutlet weak var PokName: UILabel!
    @IBOutlet weak var PokNumber: UILabel!
}

import SDWebImage

extension UIImageView {
    func download(string: String) {
        sd_setImage(with: URL(string: string), placeholderImage: UIImage(named: "imagePlaceholder"), options: SDWebImageOptions.highPriority, completed: nil)
    }
}
