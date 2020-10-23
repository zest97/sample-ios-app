//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Hlyan Htet on 22/10/2020.
//

import UIKit

class PokemonViewController: UIViewController {
    
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var numberLabel : UILabel!
    @IBOutlet var firstTypeLabel : UILabel!
    @IBOutlet var secondTypeLabel : UILabel!
    @IBOutlet var frontImage : UIImageView!
    @IBOutlet var backImage : UIImageView!
    @IBOutlet var ToggleBtn : UIButton!
    
    var pokemon : Pokemon!

    fileprivate func resetLabelText() {
        firstTypeLabel.text = "-"
        secondTypeLabel.text = "-"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetLabelText()

        if UserDefaults.standard.bool(forKey: pokemon.name) {
            ToggleBtn.setTitle("Release", for: .normal)
        } else {
            ToggleBtn.setTitle("Catch", for: .normal)
        }

        fetchAndUpdateData(Endpoint: pokemon.url)
    }
    
    @IBAction func toggleCatch() {
        if UserDefaults.standard.bool(forKey: pokemon.name) {
            UserDefaults.standard.set(false, forKey: pokemon.name)
            ToggleBtn.setTitle("Catch", for: .normal)
        } else {
            UserDefaults.standard.set(true, forKey: pokemon.name)
            ToggleBtn.setTitle("Release", for: .normal)
        }
    }
    
    func fetchAndUpdateData(Endpoint : String) {
        let url = URL(string: Endpoint)
        
        guard let u = url else {
            return
        }
        
        URLSession.shared.dataTask(with: u, completionHandler: { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let pokemonData = try JSONDecoder().decode(PokemonData.self, from: data)
                
                self.setFrontImage(Endpoint: pokemonData.sprites.front_default)
                self.setBackImage(Endpoint: pokemonData.sprites.back_default)
                
                DispatchQueue.main.async {
                    self.nameLabel.text = self.pokemon.name
                    self.numberLabel.text = String(format: "#%03d", pokemonData.id)
                    
                    for typeEntry in pokemonData.types {
                        if typeEntry.slot == 1 {
                            self.firstTypeLabel.text = typeEntry.type.name
                        } else if typeEntry.slot == 2 {
                            self.secondTypeLabel.text = typeEntry.type.name
                        }
                    }
                }
            } catch let error {
                print("\(error)")
            }
        }).resume()
    }
    
    func setFrontImage(Endpoint : String) {
        let url = URL(string: Endpoint)
        
        guard let u = url else {
            return
        }
        URLSession.shared.dataTask(with: u, completionHandler: { (data, response, error) in
            guard
            let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
            let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
            let data = data, error == nil,
            let image = UIImage(data: data)
            else { return }
            
            DispatchQueue.main.async {
                self.frontImage.image = image
                self.frontImage.contentMode = .scaleAspectFill
            }
        }).resume()
    }
    
    func setBackImage(Endpoint : String) {
        let url = URL(string: Endpoint)
        
        guard let u = url else {
            return
        }
        URLSession.shared.dataTask(with: u, completionHandler: { (data, response, error) in
            guard
            let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
            let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
            let data = data, error == nil,
            let image = UIImage(data: data)
            else { return }
            
            DispatchQueue.main.async {
                self.backImage.image = image
                self.backImage.contentMode = .scaleAspectFill
            }
        }).resume()
    }

}
