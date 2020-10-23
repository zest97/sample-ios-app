//
//  ViewController.swift
//  Pokedex
//
//  Created by Hlyan Htet on 22/10/2020.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate {
    
    let cellName = "PokemonCell"
    
    let PokemenSegueID = "PokemonSegue"
    
    let pokeApiEndpoint = "https://pokeapi.co/api/v2/pokemon?limit=151"
    
    var pokemon : [Pokemon] = []
    
    var pokemonListResult : [Pokemon] = []
    
    @IBOutlet var searchBar : UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        fetchAndUpdateData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        pokemonListResult = pokemon.filter { Pokemon in
            return Pokemon.name.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.text != "" {
            return pokemonListResult.count
        }
        return pokemon.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath)
        if searchBar.text != "" {
            cell.textLabel?.text = capitalize(text: pokemonListResult[indexPath.row].name)
        } else {
            cell.textLabel?.text = capitalize(text: pokemon[indexPath.row].name)
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if PokemenSegueID == segue.identifier {
            if let destination = segue.destination as? PokemonViewController {
                if searchBar.text != "" {
                    destination.pokemon = pokemonListResult[tableView.indexPathForSelectedRow!.row]
                } else {
                    destination.pokemon = pokemon[tableView.indexPathForSelectedRow!.row]
                }

            }
        }
    }
    
    func fetchAndUpdateData() {
        let url = URL(string: pokeApiEndpoint)
        
        guard let u = url else {
            return
        }
        
        URLSession.shared.dataTask(with: u, completionHandler: { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let pokemonList = try JSONDecoder().decode(PokemonList.self, from: data)
                self.pokemon = pokemonList.results
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print("\(error)")
            }
        }).resume()
    }
    
    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }

}

