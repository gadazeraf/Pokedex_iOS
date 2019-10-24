//
//  ViewController.swift
//  PokedexCoreData
//
//  Created by Gad on 04/10/2019.
//  Copyright © 2019 Azeraf. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate {

    var pokemon: [Pokemon] = []
    var searchPokemon: [Pokemon] = []
    var searching = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadTableView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchPokemon.count
        } else {
            return pokemon.count
        }
    }
    
    func displayPokemon(list: [Pokemon], cell: ContentTableViewCell, indexPath: IndexPath) {
        cell.PokName.text = list[indexPath.row].species?.name
        cell.PokNumber.text = "# \(list[indexPath.row].species?.pokedex_number ?? 0)"
        cell.PokImg.download(string: "http://pokedex-mti.twitchytv.live/images/\(list[indexPath.row].species?.pokedex_number ?? 0).png")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ContentTableViewCell
        
        if searching {
            displayPokemon(list: searchPokemon, cell: cell, indexPath: indexPath)
        } else {
            displayPokemon(list: pokemon, cell: cell, indexPath: indexPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching {
            searchLaunchModal(list: searchPokemon, indexPath: indexPath)
        } else {
            searchLaunchModal(list: pokemon, indexPath: indexPath)
        }
    }
    
    @IBAction func buttonAddPressed(_ sender: Any) {
        loadData()
    }
    
    
    @IBAction func unwindToMainPage(sender: UIStoryboardSegue) {
        loadTableView()
        tableView.reloadData()
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

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchPokemon = pokemon.filter({$0.species!.name!.prefix(searchText.count).capitalized == searchText.capitalized})
        searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
        view.endEditing(true)
    }
}
