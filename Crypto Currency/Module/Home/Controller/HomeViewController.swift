//
//  HomeViewController.swift
//  Crypto Currency
//
//  Created by Aidar Bekturov on 13/12/21.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var ChartsCollView: UICollectionView!
    @IBOutlet weak var BalanceCollView: UICollectionView!
    
    private var arrOfModels: [data] = []
    
    private var realm = try! Realm()
    private var dataBaseArr: [SaveModel] = [] {
        didSet {
            ChartsCollView.reloadData()
            ChartsCollView.layoutIfNeeded()
        }
    }
    
    // Life cycle of view controller
    override func viewDidLoad() {
        super.viewDidLoad()
        server()
        getFromDataBase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // for checking internet connectivity
        if !HTTPRequest.isConnectedToNetwork(){createAlert(with: "No Internet", message: "Check connctinvity to internet")}
    }
    
    // configure UI of app
    private func configureUI() {
        setRightButton()
        setBackButton(with: "arrow.left", title: "Portfolio")
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        ChartsCollView.delegate = self
        ChartsCollView.dataSource = self
        ChartsCollView.register(UINib(nibName: ChartsCollectionViewCell.identifier(), bundle: nil),
                                forCellWithReuseIdentifier: ChartsCollectionViewCell.identifier())
        
        BalanceCollView.delegate = self
        BalanceCollView.dataSource = self
        BalanceCollView.register(UINib(nibName: BalanceCollectionViewCell.identifier(), bundle: nil),
                                 forCellWithReuseIdentifier: BalanceCollectionViewCell.identifier())
    }
    
    @IBAction func AllChartsTapped(_ sender: UIButton) {
        let controller = AllChartsViewController.getVC(storyboardName: .Main)
        controller.modalTransitionStyle = .crossDissolve
        
        navigationController?.pushViewController(controller, animated: true)
    }
}


// tune collection view
extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case ChartsCollView:
            return (HTTPRequest.isConnectedToNetwork() ? arrOfModels.count : dataBaseArr.count)
        case BalanceCollView:
            return 1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case ChartsCollView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartsCollectionViewCell.identifier(), for: indexPath) as! ChartsCollectionViewCell
            if !HTTPRequest.isConnectedToNetwork() {
                if indexPath.item < dataBaseArr.count {
                    let model = dataBaseArr[indexPath.item]
                    cell.configureCell(with: model, balance: 43434.30)
                    return cell
                } else {
                    return UICollectionViewCell()
                }
            }
            cell.configureCell(with: arrOfModels[indexPath.item], balance: 43434.30)
            return cell
        case BalanceCollView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BalanceCollectionViewCell.identifier(), for: indexPath) as! BalanceCollectionViewCell
            cell.configureCell()
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case ChartsCollView:
            return CGSize(width: 405, height: 80)
        case BalanceCollView:
            return CGSize(width: 350, height: 180)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
}

//MARK: - Server methods
extension HomeViewController {
    private func server() {
        ServerManager.instance.getChange { cur, err in
            if let err = err {
                print(err)
            }
            DispatchQueue.main.async {
                self.arrOfModels = cur?.data ?? [data]()
                self.ChartsCollView.reloadData()
            }
        }
    }
}

//MARK: - Realm DataBase
extension HomeViewController {
    private func getFromDataBase() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else{return}
            self.dataBaseArr = Array(self.realm.objects(SaveModel.self))
        }
    }
}
