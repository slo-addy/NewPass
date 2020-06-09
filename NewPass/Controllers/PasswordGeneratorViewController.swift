//
//  PasswordGeneratorViewController.swift
//  NewPass
//
//  Created by Addison Francisco on 7/17/18.
//  Copyright © 2018 Addison Francisco. All rights reserved.
//

import UIKit

class PasswordGeneratorViewController: UIViewController {

    private var viewModel = PasswordViewModel()
    // Default password length to be 10 characters
    // TODO: Move passwordLength and passwordString into view model
    private var passwordLength = Constants.defaultPasswordLength
    private var passwordString = NSAttributedString(string: "")
    private var passwordSwitches: [PasswordAttributeSwitch]!

    @IBOutlet weak var passwordLabelViewContainer: UIView!
    // Animates from center to top
    @IBOutlet weak var passwordLabel1: UILabel!
    // Animates from bottom to center
    @IBOutlet weak var passwordLabel2: UILabel!
    @IBOutlet weak var passwordLabel1BottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordLabel2BottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordLengthLabel: UILabel!
    @IBOutlet weak var passwordLengthSlider: UISlider!
    @IBOutlet weak var lowercaseLetterSwitch: PasswordAttributeSwitch!
    @IBOutlet weak var uppercaseLetterSwitch: PasswordAttributeSwitch!
    @IBOutlet weak var numberSwitch: PasswordAttributeSwitch!
    @IBOutlet weak var symbolSwitch: PasswordAttributeSwitch!
    @IBOutlet weak var generatePasswordButton: UIButton!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        configureInitialState()
    }

    // MARK: View Layout

    private func configureViews() {
        passwordLabel1.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(presentPasswordShare)))
        generatePasswordButton.addTarget(self, action: #selector(generatePasswordTouchBegan(_:)), for: .touchDown)

        passwordSwitches = [lowercaseLetterSwitch, numberSwitch, symbolSwitch, uppercaseLetterSwitch]

        // Assign attributes to password switches
        lowercaseLetterSwitch.attributeType = .lowercaseLetters
        uppercaseLetterSwitch.attributeType = .uppercaseLetters
        numberSwitch.attributeType = .numbers
        symbolSwitch.attributeType = .symbols

        // Roundify view corners
        passwordLabelViewContainer.roundify(cornerRadius: 6)
        generatePasswordButton.roundify(cornerRadius: 6)
    }

    /// Sets default view states and generates initial password
    private func configureInitialState() {
        passwordString = viewModel.getRandomPassword(length: passwordLength)

        for passwordSwitch in passwordSwitches {
            if viewModel.passwordAttributes.contains(passwordSwitch.attributeType) {
                passwordSwitch.setOn(true, animated: true)
            }
        }

        passwordLengthSlider.setValue(Float(passwordLength), animated: true)
        passwordLengthLabel.text = "Password Length: \(passwordLength)"

        passwordLabel1.attributedText = passwordString
    }

    private func updateLabelsForPassword() {
        passwordLabel2.attributedText = passwordString
        passwordLengthLabel.text = "Password Length: \(passwordLength)"
    }

    private func updateLabelsWithAnimation() {
        generatePasswordButton.isEnabled = false
        updateLabelsForPassword()

        // TODO: Abstract this out into custom class

        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 5,
                       options: [],
                       animations: {
                        performLayoutUpdatesForAnimation()
        },
                       completion: { _ in
                        self.generatePasswordButton.isEnabled = true
                        self.passwordLabel1.attributedText = self.passwordLabel2.attributedText
                        performLayoutUpdatesForCompletion()

                        if self.generatePasswordButton.state == .highlighted {
                            self.randomPasswordFromViewModel()
                            self.updateLabelsForPassword()
                            animateWithReducedDuration()
                        }
        })

        func animateWithReducedDuration() {
            UIView.animate(withDuration: 0.07,
                           delay: 0,
                           options: [],
                           animations: {
                            performLayoutUpdatesForAnimation()
            },
                           completion: { _ in
                            self.generatePasswordButton.isEnabled = true
                            self.passwordLabel1.attributedText = self.passwordLabel2.attributedText
                            performLayoutUpdatesForCompletion()

                            guard self.viewModel.hasSelectedPasswordAttributes else {
                                self.presentAlertForEmptyAttributes()
                                return
                            }

                            if self.generatePasswordButton.state == .highlighted {
                                self.randomPasswordFromViewModel()
                                self.updateLabelsForPassword()
                                animateWithReducedDuration()
                            }
            })
        }

        func performLayoutUpdatesForAnimation() {
            self.passwordLabel1.alpha = 0
            self.passwordLabel1BottomConstraint.constant = self.passwordLabelViewContainer.frame.height
            self.passwordLabel2.alpha = 1
            self.passwordLabel2BottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }

        func performLayoutUpdatesForCompletion() {
            self.passwordLabel1.alpha = 1
            self.passwordLabel1BottomConstraint.constant = 0
            self.passwordLabel2.alpha = 0
            self.passwordLabel2BottomConstraint.constant = 0 - self.passwordLabelViewContainer.frame.height
            self.view.layoutIfNeeded()
        }
    }

	// MARK: - Actions

    @IBAction private func attributeSwitchDidChange(_ attributeSwitch: PasswordAttributeSwitch) {
        viewModel.passwordAttributes = passwordSwitches.filter { $0.isOn }.map { switchThatIsOn -> PasswordAttribute in
            return switchThatIsOn.attributeType
        }
    }

    @IBAction private func passwordLengthSliderDidMove(_ sender: Any) {
        passwordLength = Int(passwordLengthSlider.value)
        passwordLengthLabel.text = "Password Length: \(passwordLength)"
    }

    @IBAction private func generatePasswordTouchBegan(_ sender: UIButton) {
        if viewModel.hasSelectedPasswordAttributes {
            randomPasswordFromViewModel()
            updateLabelsWithAnimation()
        } else {
            presentAlertForEmptyAttributes()
        }
    }

    private func randomPasswordFromViewModel() {
        if viewModel.hasSelectedPasswordAttributes {
            passwordString = viewModel.getRandomPassword(length: passwordLength)
            HapticEngine().hapticTap(impactStyle: .light)
        } else {
            presentAlertForEmptyAttributes()
        }
    }

	// MARK: - Share Activity

    @objc private func presentPasswordShare() {
        let items = [passwordString.string]
        let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        // Because why...
        let excludedActivityTypes: [UIActivity.ActivityType] = [.postToFacebook, .postToTwitter]

        vc.excludedActivityTypes = excludedActivityTypes
        present(vc, animated: true, completion: nil)
    }

    private func presentAlertForEmptyAttributes() {
        let alertViewController = NPAlertViewController(title: "Hold On",
                                                        message: "You need at least one attribute selected to generate a password.",
                                                        buttonTitle: "Okay")
        alertViewController.modalPresentationStyle = .overFullScreen
        alertViewController.modalTransitionStyle = .crossDissolve
        alertViewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)

        self.present(alertViewController, animated: true)
        HapticEngine().hapticWarning()
    }

}

extension PasswordGeneratorViewController {

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        switch motion {
        case .motionShake:
            randomPasswordFromViewModel()
            updateLabelsWithAnimation()
        default:
            break
        }
    }

}
