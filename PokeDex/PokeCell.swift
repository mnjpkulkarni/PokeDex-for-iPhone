//
//  PokeCell.swift
//  PokeDex
//
//  Created by Manoj Kulkarni on 8/1/17.
//  Copyright © 2017 Manoj Kulkarni. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var thumbImg: UIImageView!
    
    
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 10.0
    }
    
    func configureCell(_ pokemon: Pokemon) {
        
        self.pokemon = pokemon
        
        nameLbl.text = self.pokemon.name.capitalized
        
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }
    
    
    
}
