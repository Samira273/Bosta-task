//
//  ProfileVC.swift
//  BostaTask
//
//  Created by Samira Marassy on 17/06/2022.
//

import UIKit

class ProfileVC: BaseVC {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var albumsTableView: UITableView!
    
    var viewModel: ProfileVM!
    private lazy var albumsDataSource = makeAlbumsDataSource()
    
    init(viewModel: ProfileVM) {
        self.viewModel = viewModel
        super.init(viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        viewModel.updateProfileTableView = updateAlbumsDataSource
    }
   
    
    func prepareView() {
        ProfileTableViewCell.register(with: albumsTableView)
        albumsTableView.delegate = self
        albumsTableView.dataSource = albumsDataSource
    }
    
    func loadData() {
        viewModel.getUserProfile {[weak self] profile in
            guard let profile = profile else { return }
            self?.bindDataToView(profile)
        }
    }
    
    func bindDataToView(_ profile: ProfileModel) {
        userNameLabel.text = profile.name
        addressLabel.text = profile.address?.fullAddress
    }
    
    func makeAlbumsDataSource() -> UITableViewDiffableDataSource<ProfileSections, AlbumModel> {
        
      let dataSource = UITableViewDiffableDataSource<ProfileSections, AlbumModel>(
        tableView: albumsTableView,
        cellProvider: { (tableView, indexPath, album) ->
          UITableViewCell? in
            if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
                return ProfileTableViewCell.dequeue(from: self.albumsTableView, for: indexPath, with: album, lastCell: true)
            } else {
                return ProfileTableViewCell.dequeue(from: self.albumsTableView, for: indexPath, with: album)
            }
            
      })
      return dataSource
    }
    
    func updateAlbumsDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<ProfileSections, AlbumModel>()
        snapshot.appendSections(ProfileSections.allCases)
        snapshot.appendItems(viewModel.getUserAlbums() ?? [], toSection: .main)
        albumsDataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension ProfileVC: UITableViewDelegate {
   
}

enum ProfileSections: CaseIterable {
    case main
}
