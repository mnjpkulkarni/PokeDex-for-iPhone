//
//  Pokemon.swift
//  PokeDex
//
//  Created by Manoj Kulkarni on 8/1/17.
//  Copyright © 2017 Manoj Kulkarni. All rights reserved.
//


import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: Int!
    private var _weight: Int!
    private var _attack: Int!
    
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    
    private var type1: String!
    private var type2: String!
    
    var nextEvolutionLevel: String {
        
        if _nextEvolutionLevel == nil {
            
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    
    var nextEvolutionId: String {
        
        if _nextEvolutionId == nil {
            
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionName: String {
        
        if _nextEvolutionName == nil {
            
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    private var _pokemonURL: String!
    
    var weight: Int {
        if _weight == nil {
            _weight = nil
        }
        return _weight
    }
    
    var height: Int {
        if _height == nil {
            _height = nil
        }
        return _height
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var attack: Int {
        if _attack == nil {
            _attack = nil
        }
        return _attack
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    
    init(name: String, pokedexId: Int) {
        
        self._name = name
        self._pokedexId = pokedexId
        
        self._pokemonURL = "\(BASE_URL)\(POKEMON_URL)\(self.pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? Int {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? Int {
                    self._height = height
                }
                
                if let baseExp = dict["base_experience"] as? Int {
                   self._attack = baseExp
                }
                
                if let types = dict["types"] as? [Dictionary<String, AnyObject>], types.count > 1 {
                    
                    if let types1 = types[0]["type"] as? Dictionary<String, AnyObject> {
                        if let name1 = types1["name"] as? String {
                            self.type1 = name1
                        }
                    }
                    
                    if types.count > 1 {
                        
                        if let types2 = types[1]["type"] as? Dictionary<String, AnyObject> {
                            if let name2 = types2["name"] as? String {
                                self.type2 = name2
                            }
                        }
                        
                        self._type = self.type1+"/"+self.type2
                    }
                    
                    if types.count == 1{
                        self._type = self.type1
                    }
                }
                
                
            }
            
            completed()

            
        }
        
    }
    
}
