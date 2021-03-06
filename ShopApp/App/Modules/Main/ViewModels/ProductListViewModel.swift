//
//  ProductListViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/3/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift
import ShopApp_Gateway

class ProductListViewModel: GridCollectionViewModel {
    private let productListUseCase: ProductListUseCase
    
    var sortingValue: SortingValue!
    var keyPhrase: String?
    var excludePhrase: String?

    init(productListUseCase: ProductListUseCase) {
        self.productListUseCase = productListUseCase
    }
    
    func reloadData() {
        paginationValue = nil
        loadRemoteData()
    }
    
    func loadNextPage() {
        paginationValue = products.value.last?.paginationValue
        loadRemoteData()
    }
    
    private func loadRemoteData() {
        let showHud = products.value.isEmpty
        state.onNext(ViewState.make.loading(showHud: showHud))
        let reverse = sortingValue == .createdAt
        productListUseCase.getProductList(with: paginationValue, sortingValue: sortingValue, keyPhrase: keyPhrase, excludePhrase: excludePhrase, reverse: reverse) { [weak self] (products, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if let products = products {
                strongSelf.updateProducts(products: products)
                strongSelf.state.onNext(.content)
            }
            strongSelf.canLoadMore = products?.count ?? 0 == kItemsPerPage
        }
    }

    // MARK: - BaseViewModel

    override func tryAgain() {
        reloadData()
    }
}
