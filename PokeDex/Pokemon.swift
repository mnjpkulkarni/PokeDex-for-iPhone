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
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    
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
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
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
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
            
            if let height = dict["height"] as? String {
                self._height = height
            }
            
            if let attack = dict["attack"] as? Int{
                self._attack = "\(attack)"
            }
            
            if let defense = dict["defense"] as? Int {
                self._defense = "\(defense)"
            }

            if let types = dict["types"] as? [Dictionary<String, String>] , types.count > 0 {
                
                if let name = types[0]["name"] {
                    
                    self._type = name.capitalized
                }
                
                if types.count > 1 {
                    
                    for x in 1..<types.count {
                        
                        if let name = types[x]["name"] {
                            
                            self._type! += "/\(name.capitalized)"
                        }
                    }
                }
                
                print(self._type)
                
            } else {
                
                self._type = ""
            }
            
            if let descArray = dict["descriptions"] as? [Dictionary<String,String>] , descArray.count > 0 {
                
                if let url = descArray[0]["resource_uri"] {
                    
                    let descURL = "\(BASE_URL)\(url)"
                    
                    Alamofire.request(descURL).responseJSON(completionHandler: { (response) in
                        
                        if let descDict = response.result.value as? Dictionary<String, AnyObject> {
                            
                            if let description = descDict["description"] as? String {
                                self._description = description
                                print(self._description)
                            }
                            
                        }
                        completed()
                    })
                }
                
            }
            
            else {
                self._description = ""
            }

            if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] , evolutions.count > 0 {
                
                if let nextEvo = evolutions[0]["to"] as? String {
                    
                    if nextEvo.range(of: "mega") == nil {
                        
                        self._nextEvolutionName = nextEvo
                        
                        if let uri = evolutions[0]["resource_uri"] as? String {
                            
                            let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                            let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                            
                            self._nextEvolutionId = nextEvoId
                            
                            if let lvlExist = evolutions[0]["level"] {
                                
                                if let lvl = lvlExist as? Int {
                                    
                                    self._nextEvolutionLevel = "\(lvl)"
                                }
                                
                            } else {
                                
                                self._nextEvolutionLevel = ""
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
            
            }
            
            completed()

            
        }
        
    }
    
}
