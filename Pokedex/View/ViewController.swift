//
//  ViewController.swift
//  Pokedex
//
//  Created by Gad on 03/10/2019.
//  Copyright © 2019 Azeraf. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var poke: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData(completionHandler: { result in
            self.poke = result
            self.tableView.reloadData()
        })
        tableView.estimatedRowHeight = 44
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poke.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ContentTableViewCell
        cell.PokName.text = poke[indexPath.row].name
        cell.PokNumber.text = "#"+String(poke[indexPath.row].pokedex_number)
        cell.PokImg.download(string: "http://pokedex-mti.twitchytv.live/images/\(poke[indexPath.row].id).png")
        return cell
    }
    
    func loadData(completionHandler: @escaping (_ result:[Pokemon]) -> Void ){
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        view.addSubview(activityIndicator)
        activityIndicator.center = CGPoint(x: view.frame.size.width*0.5, y: view.frame.size.height*0.5)
        activityIndicator.startAnimating()
        
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
                        self.tableView.reloadData()
                    }
                case .failure(_):
                    fatalError("error occured")
                }
                activityIndicator.stopAnimating()
                completionHandler(pokemons) })
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "PokemonDetailSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "PokemonDetailSegue",
            let destination = segue.destination as? PokemonDetailViewController,
            let pokIndex = tableView.indexPathForSelectedRow?.row
        {
            destination.name = poke[pokIndex].name
            destination.id = String(poke[pokIndex].id)
            destination.preid = String(poke[pokIndex].pre_evolution_id ?? 0)
            destination.hei = poke[pokIndex].height
            destination.wei = poke[pokIndex].weight
            destination.desc = poke[pokIndex].desc
            destination.type1 = poke[pokIndex].type1
            destination.type2 = poke[pokIndex].type2 ?? ""
        }
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
