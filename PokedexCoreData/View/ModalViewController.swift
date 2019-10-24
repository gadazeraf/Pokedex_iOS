//
//  ModalViewController.swift
//  PokedexCoreData
//
//  Created by Gad on 20/10/2019.
//  Copyright © 2019 Azeraf. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {

    var img = UIImageView()
    var name = ""
    var id = integer_t(0)
    var type1 = ""
    var type2 = ""
    var lvl = integer_t(0)
    var shiny = false
    var (attack1, typea1) = ("","")
    var (attack2, typea2) = ("","")
    var (attack3, typea3) = ("","")
    var (attack4, typea4) = ("","")

    
    @IBOutlet weak var PokImg: UIImageView?
    @IBOutlet weak var pokName: UILabel?
    @IBOutlet weak var pokId: UILabel?
    @IBOutlet weak var pokType1: UILabel?
    @IBOutlet weak var pokType2: UILabel?
    @IBOutlet weak var pokLevel: UILabel!
    @IBOutlet weak var pokShiny: UILabel!
    @IBOutlet weak var pokAttack1: UILabel!
    @IBOutlet weak var pokAttack2: UILabel!
    @IBOutlet weak var pokAttack3: UILabel!
    @IBOutlet weak var pokAttack4: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    //wait to improve: generate label
    
    override func viewWillAppear(_ animated: Bool) {
        pokName?.text = name
        PokImg?.download(string: "http://pokedex-mti.twitchytv.live/images/\(id).png")
        pokId?.text = "# \(id)"
        pokType1?.text = "Type: " + type1
        pokType2?.text = "Type2: " + type2
        pokLevel?.text = "lvl: \(lvl)"
        pokAttack1?.text = "• \(attack1) (type: \(typea1))"
        
        if (attack2 != "null") {
            pokAttack2?.text = "• \(attack2) (type: \(typea2))"
            pokAttack2.alpha = 1
            attackLabel.text = "Attacks:"
        }
        if (attack3 != "null") {
            pokAttack3?.text = "• \(attack3) (type: \(typea3))"
            pokAttack3.alpha = 1
        }
        if (attack4 != "null") {
            pokAttack4?.text = "• \(attack4) (type: \(typea4))"
            pokAttack4.alpha = 1
        }
        if (shiny) {
            pokShiny.alpha = 1
        }
        if (type2 != "null") {
            pokType2?.alpha = 1
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 8
    }

    @IBAction func closeButton(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToTableView", sender: self)
    }

}
