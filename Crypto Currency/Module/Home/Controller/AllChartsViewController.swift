//
//  AllChartsViewController.swift
//  Crypto Currency
//
//  Created by Aidar Bekturov on 13/12/21.
//

import UIKit
import RealmSwift

class AllChartsViewController: UIViewController {
    
    @IBOutlet weak var chartsCollView: UICollectionView!
    
    private var searchController = UISearchController(searchResultsController: nil)
    
    private var isSearchBarEmpty: Bool {
        searchController.searchBar.text?.isEmpty == true
    }
    
    private var isFilltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    private var arrOfModels: [data] = []
    private var filteredArr: [SaveModel] = []
    private var dataBaseArr: [SaveModel] = []
    
    private let realm = try! Realm()
    
    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollView()
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        removeRightButton()
        getInfo()
        getFromDataBase()
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func configureCollView() {
        chartsCollView.delegate = self
        chartsCollView.dataSource = self
        chartsCollView.register(UINib(nibName: ChartsCollectionViewCell.identifier(), bundle: nil),
                                forCellWithReuseIdentifier: ChartsCollectionViewCell.identifier())
    }
}

// tuning collection view
extension AllChartsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        isFilltering
        ? filteredArr.count
        : (HTTPRequest.isConnectedToNetwork()
           ? arrOfModels.count
           : dataBaseArr.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartsCollectionViewCell.identifier(), for: indexPath) as! ChartsCollectionViewCell
        if !HTTPRequest.isConnectedToNetwork() {
            if isFilltering {
                let model = filteredArr[indexPath.item]
                cell.configureCell(with: model, balance: 43434.30)
                return cell
            }
            let model = dataBaseArr[indexPath.item]
            cell.configureCell(with: model, balance: 43434.30)
            return cell
        } else {
            if isFilltering {
                let model = filteredArr[indexPath.item]
                cell.configureCell(with: model, balance: 43434.30)
                return cell
            }
            let model = arrOfModels[indexPath.item]
            cell.configureCell(with: model, balance: 43434.30)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 405, height: 80)
    }
}

// for searching in array of crypto coin
extension AllChartsViewController: UISearchResultsUpdating {
    private func filltering(_ searchText: String) {
        let predict = NSPredicate.init(format: "symbol CONTAINS[cd] %@", searchText)
        filteredArr = Array(realm.objects(SaveModel.self).filter(predict))
        
        chartsCollView.reloadData()
    }
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filltering(searchBar.text!)
    }
}

// Server methods
extension AllChartsViewController {
    private func getInfo() {
        ServerManager.instance.getChange { cur, err in
            if let err = err {
                print(err)
            }
            DispatchQueue.main.async {
                self.arrOfModels = cur?.data ?? [data]()
                self.chartsCollView.reloadData()
            }
        }
    }
}

//MARK: - local DataBase methods
// gettin from local storage
extension AllChartsViewController {
    private func getFromDataBase() {
        dataBaseArr = Array(realm.objects(SaveModel.self))
        chartsCollView.reloadData()
    }
}
