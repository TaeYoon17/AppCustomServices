//
//  ImageViewer+UIKit.swift
//  ImageSlider
//
//  Created by Developer on 5/29/24.
//

import Foundation
import UIKit
extension ImageViewer{
    final class UIKit:UIViewController{
        var images:[UIImage] = ["ARKit","AsyncSwift","C++","macOS","Metal"].map{UIImage(named: $0)!}
        var imageID:[UUID] = []
        lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        var layout:UICollectionViewCompositionalLayout{
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            let size:NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            let layout = UICollectionViewCompositionalLayout(section: section)
            layout.configuration = .init()
            layout.configuration.scrollDirection = .horizontal
            return layout
        }
        enum SectionHeader{ case wow }
        var dataSource: DataSource!
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.addSubview(collectionView)
            view.backgroundColor = .black
            collectionView.backgroundColor = .black
            collectionView.isPagingEnabled = false
            collectionView.isScrollEnabled = false
            collectionView.contentInsetAdjustmentBehavior = .never
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
                collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ])
            self.imageID = images.map{_ in UUID()}
            let registration = self.cellRegistration
            dataSource = .init(imageIDs: imageID, collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
                collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
            })
            
            self.navigationItem.leftBarButtonItem = .init(title: "", image: .init(systemName: "xmark"), primaryAction: .init(handler: {[weak self] _ in
                self?.dismiss(animated: true)
            }))
            self.navigationItem.leftBarButtonItem?.tintColor = .white
        }
    }
}
final class ImgViewWrapper:UICollectionViewCell{
    var viewImage:UIImage?{
        didSet{
            viewer.image = viewImage
        }
    }
    let viewer = ImgView(frame: .zero)
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(viewer)
        self.viewer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.contentView.leadingAnchor.constraint(equalTo: viewer.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: viewer.trailingAnchor),
            self.contentView.topAnchor.constraint(equalTo: viewer.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: viewer.bottomAnchor)
        ])
        
    }
}
extension ImageViewer.UIKit{
    final class DataSource: UICollectionViewDiffableDataSource<SectionHeader, UUID>{
        init(imageIDs:[UUID],collectionView: UICollectionView, cellProvider: @escaping UICollectionViewDiffableDataSource<ImageViewer.UIKit.SectionHeader, UUID>.CellProvider) {
            super.init(collectionView: collectionView, cellProvider: cellProvider)
            var snapshot = NSDiffableDataSourceSnapshot<ImageViewer.UIKit.SectionHeader, UUID>()
            snapshot.appendSections([.wow])
            snapshot.appendItems(imageIDs)
            self.apply(snapshot)
        }
    }
    var cellRegistration: UICollectionView.CellRegistration<ImgViewWrapper,UUID>{
        UICollectionView.CellRegistration {[weak self] cell, indexPath, itemIdentifier in
            guard let self,let imageIdx = self.imageID.firstIndex(of: itemIdentifier) else {return}
            cell.viewImage = self.images[safe: imageIdx]
        }
    }
}
extension Collection{
    subscript(safe index: Index) -> Element?{
        get{
            indices.contains(index) ? self[index] : nil
        }
    }
}
