//
//  HomeViewController.swift
//  MovieTouch
//
//  Created by Willian Rafael Perez Rodrigues on 01/07/19.
//  Copyright © 2019 Will Rodrigues. All rights reserved.
//

import UIKit
import RxSwift

class UpcomingViewController: BaseViewController {

    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: CustomSearchBar!
    
    
    // MARK: - Variables
    let disposeBag = DisposeBag()
    private var upcomingListVM: UpcomingListViewModel?
    var isFetchingMovies = false
    var searchTextHasChanged = false
    var searchMode = false {
        didSet {
            self.searchTextHasChanged = false
            self.view.endEditing(true)
            self.upcomingListVM?.removeAll()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.contentOffset = CGPoint(x: 0, y: 0)
            }
            self.searchMode ? self.populateSearchedMovies() : self.populateMovies()
        }
    }
    
    // MARK: - ViewController Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.configureCollectionView()
        self.populateMovies()
        self.retrieveGenres()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.collectionView.reloadData()
    }
    
    // MARK: - Functions
    private func configureCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    private func populateMovies() {
        if !self.isFetchingMovies, let upcomingMoviesPath = Constants().upcomingMoviesPath, let newPagequeryItems = self.generateNewPageQueryItem() {
            self.isFetchingMovies = true
            let resource = Resource<MoviesResponse>(url: upcomingMoviesPath, queryItems: newPagequeryItems)
            URLRequest.load(resource: resource)
                .retry(3)
                .catchError { error in
                    print(error.localizedDescription)
                    self.isFetchingMovies = false
                    return Observable.just(MoviesResponse())
                }.subscribe(onNext: { moviesResponse in
                    if self.upcomingListVM == nil {
                        self.upcomingListVM = UpcomingListViewModel(moviesResponse)
                    } else {
                        self.upcomingListVM?.add(moviesResponse: moviesResponse)
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    self.isFetchingMovies = false
                }).disposed(by: disposeBag)
        }
    }
    
    private func populateSearchedMovies() {
        if !self.isFetchingMovies, let upcomingMoviesPath = Constants().searchMoviePath, let newPagequeryItems = self.generateNewPageQueryItem() {
            self.isFetchingMovies = true
            var queryItems: [URLQueryItem] = []
            queryItems.append(contentsOf: self.generateSearchQueryItem(searchText: searchBar.text ?? ""))
            queryItems.append(contentsOf: newPagequeryItems)
            let resource = Resource<MoviesResponse>(url: upcomingMoviesPath, queryItems: queryItems)
            URLRequest.load(resource: resource)
                .retry(3)
                .catchError { error in
                    print(error.localizedDescription)
                    self.isFetchingMovies = false
                    return Observable.just(MoviesResponse())
                }.subscribe(onNext: { moviesResponse in
                    if self.upcomingListVM == nil {
                        self.upcomingListVM = UpcomingListViewModel(moviesResponse)
                    } else {
                        self.upcomingListVM?.add(moviesResponse: moviesResponse)
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    self.isFetchingMovies = false
                }).disposed(by: disposeBag)
        }
    }
    
    private func retrieveGenres() {
        if let genreListPath = Constants().genreListPath {
            let resource = Resource<Genres>(url: genreListPath, queryItems: [])
            URLRequest.load(resource: resource)
                .retry(3)
                .catchError { error in
                    print(error.localizedDescription)
                    return Observable.just(Genres())
                }.subscribe(onNext: { genresResponse in
                    self.upcomingListVM?.genresList = genresResponse
                }).disposed(by: disposeBag)
        }
    }
    
    private func generateNewPageQueryItem() -> [URLQueryItem]? {
        if (self.upcomingListVM?.page ?? 0) < (self.upcomingListVM?.totalPages ?? 1) {
            let newPage = (self.upcomingListVM?.page ?? 0) + 1
            return [URLQueryItem(name: "page", value: "\(newPage)")]
        } else {
            return nil
        }
    }
    
    private func generateSearchQueryItem(searchText: String) -> [URLQueryItem] {
        return !searchText.isEmpty ? [URLQueryItem(name: "query", value: searchText)] : []
    }
}

// MARK: - ScrollView Functions
extension UpcomingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.upcomingListVM?.upcomingVM.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let upcomingVM = self.upcomingListVM?.resultAt(indexPath.row)
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingCollectionViewCell", for: indexPath) as? UpcomingCollectionViewCell {
            
            upcomingVM?.releaseDate.asDriver(onErrorJustReturn: "")
                .drive(cell.lblReleased.rx.text)
                .disposed(by: disposeBag)
            
            upcomingVM?.posterUrl.asObservable()
                .subscribe(onNext: { urlString in
                    cell.imgPoster.downloadImageFrom(urlString)
                }).disposed(by: disposeBag)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = 0
        var height: CGFloat = 0
        if UIApplication.shared.statusBarOrientation.isPortrait {
            let moviesPerRow: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 4 : 2
            width = (collectionView.bounds.width / moviesPerRow) - 10
            height = (width * 2)
        } else {
            let moviesPerRow: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 8 : 4
            width = (collectionView.bounds.width / moviesPerRow) - 10
            height = (width * 2)
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected item: \(indexPath.row)")
        if let detailsVC = UIStoryboard(name: "Upcoming", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController, let result = self.upcomingListVM?.resultAt(indexPath.row).result {
            detailsVC.movieDetailsViewModel = MovieDetailsViewModel(result, genres: self.upcomingListVM?.genresList)
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}

// MARK: - Pagination
extension UpcomingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let contentSizeHeight = scrollView.contentSize.height
        if contentOffsetY > (contentSizeHeight - scrollView.frame.size.height) {
            if (self.searchBar.text ?? "").isEmpty {
                self.populateMovies()
            } else {
                self.populateSearchedMovies()
            }
        }
    }
}

// MARK: - SearchBar Functions
extension UpcomingViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !(searchBar.text ?? "").isEmpty && (!self.searchMode || self.searchMode) {
            self.searchMode = true
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchTextHasChanged = true
        if searchText.isEmpty && self.searchMode {
            self.searchMode = false
        }
    }
}
