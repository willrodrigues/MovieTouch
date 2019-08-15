//
//  MovieDetailsViewController.swift
//  MovieTouch
//
//  Created by Willian Rafael Perez Rodrigues on 05/07/19.
//  Copyright © 2019 Will Rodrigues. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class MovieDetailsViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var imgPoster: CustomImageView!
    @IBOutlet weak var imgPosterHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgPosterWidthContraint: NSLayoutConstraint!
    @IBOutlet weak var lblMovieName: UILabel!
    @IBOutlet weak var lblGenre: UILabel!
    @IBOutlet weak var lblOverViewTitle: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    
    // MARK: - Variables
    let disposeBag = DisposeBag()
    var movieDetailsViewModel: MovieDetailsViewModel?

    // MARK: - ViewController Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurePosterSize(self.view.bounds.width)
        self.fillUpScreen()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.configurePosterSize(size.width)
    }
    
    // MARK: - Functions
    private func configurePosterSize(_ width: CGFloat) {
        let halfViewWidth = width / 2
        let imgWidth = halfViewWidth > 400 ? 400 : halfViewWidth
        let imgHeight = imgWidth * 2
        self.imgPosterWidthContraint.constant = imgWidth
        self.imgPosterHeightConstraint.constant = imgHeight
    }
    
    private func fillUpScreen() {
        movieDetailsViewModel?.releaseDate.asDriver(onErrorJustReturn: "")
            .drive(self.lblReleaseDate.rx.text)
            .disposed(by: disposeBag)

        movieDetailsViewModel?.title.asDriver(onErrorJustReturn: "")
            .drive(self.lblMovieName.rx.text)
            .disposed(by: disposeBag)
        
        movieDetailsViewModel?.overview.subscribe(onNext: { overViewText in
            self.lblOverview.text = overViewText
            self.lblOverview.isHidden = overViewText.isEmpty
            self.lblOverViewTitle.isHidden = overViewText.isEmpty
        }).disposed(by: disposeBag)
        
        
        movieDetailsViewModel?.genreValues.asDriver(onErrorJustReturn: "")
            .drive(self.lblGenre.rx.text)
            .disposed(by: disposeBag)

        movieDetailsViewModel?.posterUrl.asObservable()
            .subscribe(onNext: { urlString in
                self.imgPoster.downloadImageFrom(urlString)
            }).disposed(by: disposeBag)
    }
}
