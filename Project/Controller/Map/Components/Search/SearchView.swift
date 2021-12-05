//
//  SearchView.swift
// Full
//
//  Created by dev on 11/5/19.
//  Copyright © 2019 dev. All rights reserved.

import Foundation
import SnapKit
import Closures

protocol SearchViewDelegate: AnyObject {
    func didTapSearchField()
}

class SearchView: UIView {
    
    // MARK: - Public var
    public weak var delegate: SearchViewDelegate?
    
    // MARK: - Private var
    private var stackSearch = UIStackView()
    private var stackBackground = UIView()
    private var searchBar = UISearchBar()
    
    // MARK: - Init
    init() {
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        addSubview(stackSearch)
        stackSearch.backgroundColor = .clear
        stackSearch.axis = .horizontal
        stackSearch.spacing = 4
        stackSearch.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackSearch.addSubview(stackBackground)
        stackBackground.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        stackBackground.backgroundColor = .white
        stackBackground.layer.cornerRadius = 20
        stackBackground.layer.masksToBounds = true
        
        // add search bar
        stackSearch.addArrangedSubview(searchBar)
        
        let colorImage = UIImage.imageWithColor(color: UIColor.white, size: 40.0).roundedImage(20)
        
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
                string: "search_placeholder".localized(),
                attributes: [NSAttributedString.Key.foregroundColor: Theme.searchBar(.text).value])
        } else {
            if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
                searchField.attributedPlaceholder = NSAttributedString(
                    string: "search_placeholder".localized(),
                    attributes: [NSAttributedString.Key.foregroundColor: Theme.searchBar(.text).value])
            }
        }
        
        if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField,
           let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
            glassIconView.image = UIImage(named: "search")
            glassIconView.contentMode = .scaleAspectFit
            glassIconView.tintColor = Theme.blueDarker.value
        }
        searchBar.tintColor = Theme.blueDarker.value
        searchBar.barTintColor = .clear
        searchBar.searchBarStyle = .minimal
        searchBar.barStyle = .default
        searchBar.delegate = self
        searchBar.setSearchFieldBackgroundImage(colorImage, for: .normal)
        searchBar.setImage(nil, for: UISearchBar.Icon.clear, state: .normal)
        
    }
}

// MARK: UISearchBar Delegate
extension SearchView: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.delegate?.didTapSearchField()
    }
}
