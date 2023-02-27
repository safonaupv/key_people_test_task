//
//  UIView + Embed.swift
//  KeyPeopleTestTask
//
//  Created by Pavel Safonau on 24.02.23.
//

import UIKit

extension UIView {
    func embed(_ subview: UIView) {
        addSubview(subview)
        setupConstraints(of: subview)
    }
    
    func setupConstraints(of subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([subview.leftAnchor.constraint(equalTo: self.leftAnchor),
                                     subview.topAnchor.constraint(equalTo: self.topAnchor),
                                     subview.rightAnchor.constraint(equalTo: self.rightAnchor),
                                     subview.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
    }
}
