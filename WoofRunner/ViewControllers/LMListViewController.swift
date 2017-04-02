//
//  LMListViewController.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/25/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import FirebaseAuth

public enum LevelListType {
    case Downloaded
    case Created
}

public class LMListViewController: UIViewController {

    // MARK: - Public variables

    public var listType: LevelListType?

    // MARK: - Private variables

    private var vm = LMListViewModel()
    private let disposeBag = DisposeBag()

    // MARK: - IBOutlets

    @IBOutlet var viewTitle: UILabel!

    // MARK: - IBActions

    /// Stubbed action to test out RxSwift
    @IBAction func addGame(_ sender: UIButton) {
        if listType == .Downloaded {
            uploadOneGame()
        } else {
            addOneStubCreatedGame()
        }
    }

    // MARK: - Lifecyle methods

    public override func viewDidLoad() {
        vm.setListType(listType!)
        bindViewTitle()
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // For embeded segue
        if let destination = segue.destination as? LMListCollectionViewController {
            destination.games = vm.games
        }
    }

    // MARK: - Private methods

    /// Binds the list type variable to the viewTitle
    private func bindViewTitle() {
        vm.listType.asObservable().map { type in
            switch type {
            case .Downloaded:
                return "Downloaded Games"
            case .Created:
                return "Created Games"
            }
        }
        .bindTo(viewTitle.rx.text)
        .addDisposableTo(disposeBag)
    }

    /// Saves a new game to CoreData
    private func addOneStubCreatedGame() {
        vm.createOneGame()
    }

    private func uploadOneGame() {
        vm.uploadOneGame()
    }
}
