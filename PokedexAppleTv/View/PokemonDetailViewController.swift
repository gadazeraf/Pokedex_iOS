//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Gad on 04/10/2019.
//  Copyright © 2019 Azeraf. All rights reserved.
//

import UIKit

class PokemonDetailViewController: UIViewController {
    
    var img = UIImageView()
    var name = ""
    var id = ""
    var preid = ""
    var wei = ""
    var hei = ""
    var type1 = ""
    var type2 = ""
    var desc = ""
    
    @IBOutlet weak var PokImg: UIImageView?
    @IBOutlet weak var pokName: UILabel?
    @IBOutlet weak var pokId: UILabel?
    @IBOutlet weak var preEvolutionId: UILabel?
    @IBOutlet weak var pokWei: UILabel?
    @IBOutlet weak var pokHei: UILabel?
    @IBOutlet weak var pokType1: UILabel?
    @IBOutlet weak var pokType2: UILabel?
    @IBOutlet weak var pokDescription: UILabel?
    
    override func viewWillAppear(_ animated: Bool) {
        pokName?.text = name
        PokImg?.download(string: "http://pokedex-mti.twitchytv.live/images/\(id).png")
        pokId?.text = "#" + id
        preEvolutionId?.text = "Pre evolution: #" + preid
        pokHei?.text = "height: " + hei
        pokWei?.text = "weight: " + wei
        pokType1?.text = "Type: " + type1
        pokType2?.text = "Type2: " + type2
        pokDescription?.text = desc
        
        if (preid != "0") {
            preEvolutionId?.alpha = 1
        }
        if (type2 != "") {
            pokType2?.alpha = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
