//
//  FeedController.swift
//  PhotoLenta
//
//  Created by Alex Ch. on 18.06.2021.
//

import UIKit

class FeedController: UIViewController {

    private let logoContainerView: UIView = {
        let view = UIView()
        let logoImageView = UIImageView(image:#imageLiteral(resourceName: "feed"))
//        logoImageView.contentMode = .scaleAspectFit
        logoImageView.contentMode = .center
        logoImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 300, height: 1000))
//        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        view.addSubview(logoImageView)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponents()
    }

    fileprivate func configureViewComponents() {
        view.backgroundColor = .white
        view.addSubview(logoContainerView)
    }
}
