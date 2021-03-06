//
//  CategoryListViewModel.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 2/1/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import RxSwift
import ShopApp_Gateway

class CategoryListViewModel: BasePaginationViewModel {
    private let categoryListUseCase: CategoryListUseCase
    
    var items = Variable<[ShopApp_Gateway.Category]>([])

    init(categoryListUseCase: CategoryListUseCase) {
        self.categoryListUseCase = categoryListUseCase
    }
    
    func reloadData() {
        paginationValue = nil
        loadRemoteData()
    }
    
    func loadNextPage() {
        paginationValue = items.value.last?.paginationValue
        loadRemoteData()
    }
    
    private func loadRemoteData() {
        let showHud = items.value.isEmpty
        state.onNext(ViewState.make.loading(showHud: showHud))
        categoryListUseCase.getCategoryList { [weak self] (catogories, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if let categories = catogories {
                strongSelf.updateCategories(with: categories)
                strongSelf.state.onNext(.content)
            }
            strongSelf.canLoadMore = catogories?.count ?? 0 == kItemsPerPage
        }
    }
    
    private func updateCategories(with categories: [ShopApp_Gateway.Category]) {
        if paginationValue == nil {
            items.value.removeAll()
        }
        items.value += categories
    }
    
    // MARK: - BaseViewModel
    
    override func tryAgain() {
        reloadData()
    }
}
