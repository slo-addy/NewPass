//
//  NPAlertViewController.swift
//  NewPass
//
//  Created by Addison Francisco on 6/4/20.
//  Copyright © 2020 Addison Francisco. All rights reserved.
//

import UIKit

class NPAlertViewController: UIViewController {

    private let containerView = NPAlertContainerView()
    private let titleLabel = NPTitleLabel(textAlignment: .center, fontSize: 20)
    private let messageLabel = NPBodyLabel(textAlignment: .center)
    private let actionButton = NPButton(backgroundColor: .systemPink, title: "Ok")
    private let padding: CGFloat = 20
    private var alertTitle: String?
    private var message: String?
    private var buttonTitle: String?
    private var buttonHandler: (() -> Void)?

    // MARK: - Initialization

    init(title: String, message: String, buttonTitle: String, buttonHandler: (() -> Void)?) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.message = message
        self.buttonTitle = buttonTitle
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        view.addSubviews(containerView)
        containerView.addSubviews(titleLabel, actionButton, messageLabel)

        configureContainerView()
        configureTitleLabel()
        configureActionButton()
        configureMessageLabel()
    }

    // MARK: - View Configuration

    private func configureContainerView() {
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }

    private func configureTitleLabel() {
        titleLabel.text = alertTitle

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    private func configureActionButton() {
        actionButton.setTitle(buttonTitle, for: .normal)
        actionButton.addTarget(self, action: #selector(didTouchDown), for: .touchDown)
        actionButton.addTarget(self, action: #selector(didTouchUp), for: .touchUpInside)
        actionButton.addTarget(self, action: #selector(didTouchUp), for: .touchUpOutside)

        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func configureMessageLabel() {
        messageLabel.text = message
        messageLabel.numberOfLines = 4

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12)
        ])
    }

    // MARK: - Actions

    @objc
    private func didTouchDown() {
        actionButton.alpha = 0.7
    }

    @objc
    private func didTouchUp() {
        actionButton.alpha = 1.0
        buttonHandler?()

        dismiss(animated: true)
    }

}
