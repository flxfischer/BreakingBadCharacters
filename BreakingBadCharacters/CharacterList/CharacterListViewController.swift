//
//  ViewController.swift
//  BreakingBadCharacters
//
//  Created by Felix Fischer on 06/08/2021.
//

import UIKit
import Combine

class CharacterListViewController: UIViewController {
    
    private var cancellables: [AnyCancellable] = []
    
    private(set) var selectedCell: CharacterListItemCell?
    
    private lazy var collectionViewLayout = CharacterListCollectionViewLayout()
    
    private lazy var collectionViewDataSource = CharacterListDataSource()
    
    private var transitionAnimator: TransitionAnimator?
    
    private lazy var backgroundImage: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "background2"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        cv.dataSource = collectionViewDataSource
        cv.delegate = self
        cv.register(CharacterListItemCell.self, forCellWithReuseIdentifier: CharacterListItemCell.reuseIdentifier)
        cv.backgroundColor = .clear
        cv.backgroundView = backgroundImage
        return cv
    }()
    
    private lazy var seasonsFilterButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "All Seasons", style: .plain, target: self, action: #selector(seasonFilterButtonPressed))
        
        viewModel?.$filterButtonTitle.sink {
            button.title = $0
        }.store(in: &cancellables)
        
        return button
    }()
    
    var viewModel: CharacterListViewModel? {
        didSet {
            viewModel?.$state.sink(receiveValue: { state in
                switch state {
                case .loaded(let characters):
                    self.collectionViewDataSource.characters = characters
                    self.collectionView.reloadData()
                default:
                    break
                // TODO: Implement views for error and loading
                }
            }).store(in: &cancellables)
        }
    }
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController()
        sc.searchResultsUpdater = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Character name"
        sc.hidesNavigationBarDuringPresentation = false
        return sc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Breaking Bad"
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.rightBarButtonItem = seasonsFilterButton
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        viewModel?.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc private func seasonFilterButtonPressed() {
        let seasonsFilterMenu = UIAlertController(title: "Filter by Season", message: "Filter Characters by apearance in seasons", preferredStyle: .actionSheet)
        
        let action = UIAlertAction(title: "All Seasons", style: .default) { _ in
            self.viewModel?.filterResults(by: nil)
        }
        seasonsFilterMenu.addAction(action)
        
        [1,2,3,4,5].forEach { season in
            let action = UIAlertAction(title: "Season \(season)", style: .default) { _ in
                self.viewModel?.filterResults(by: season)
            }
            seasonsFilterMenu.addAction(action)
        }
        
        present(seasonsFilterMenu, animated: true, completion: nil)
    }
}

extension CharacterListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = collectionView.cellForItem(at: indexPath) as? CharacterListItemCell
        viewModel?.didSelectItem(at: indexPath)
    }
}

extension CharacterListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel?.filterResults(for: searchController.searchBar.text)
    }
}

