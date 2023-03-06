//
//  PasswordGeneratorViewController.swift
//  NewPass
//
//  Created by Addison Francisco on 7/17/18.
//  Copyright © 2018 Addison Francisco. All rights reserved.
//

import UIKit

final class PasswordGeneratorViewController: UIViewController {
    
    private var viewModel = PasswordGeneratorViewModel(passwordAttributes: Constants.defaultPasswordAttributes,
                                                       passwordLength: Constants.defaultPasswordLength)
    private var passwordSwitches: [NPAttributeSwitch]!
    
    @IBOutlet private weak var passwordLabelViewContainer: UIView!
    @IBOutlet private weak var passwordFadeOutLabel: UILabel!
    @IBOutlet private weak var passwordFadeOutLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var passwordFadeInLabel: UILabel!
    @IBOutlet private weak var passwordFadeInLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var passwordLengthLabel: UILabel!
    @IBOutlet private weak var passwordLengthSlider: UISlider!
    @IBOutlet private weak var lowercaseLetterSwitch: NPAttributeSwitch!
    @IBOutlet private weak var uppercaseLetterSwitch: NPAttributeSwitch!
    @IBOutlet private weak var numberSwitch: NPAttributeSwitch!
    @IBOutlet private weak var symbolSwitch: NPAttributeSwitch!
    @IBOutlet private weak var generatePasswordButton: UIButton!
    
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
        passwordLabelViewContainer.roundify(cornerRadius: 6)
        passwordFadeOutLabel.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(presentPasswordShare)))
        
        lowercaseLetterSwitch.attributeType = .lowercaseLetters
        uppercaseLetterSwitch.attributeType = .uppercaseLetters
        numberSwitch.attributeType = .numbers
        symbolSwitch.attributeType = .symbols
        passwordSwitches = [lowercaseLetterSwitch, numberSwitch, symbolSwitch, uppercaseLetterSwitch]
        
        generatePasswordButton.roundify(cornerRadius: 6)
    }
    
    /// Sets default view states and generates initial password
    private func configureInitialState() {
        for passwordSwitch in passwordSwitches {
            if viewModel.passwordAttributes.contains(passwordSwitch.attributeType) {
                passwordSwitch.setOn(true, animated: true)
            }
        }
        
        passwordLengthSlider.setValue(Float(viewModel.passwordLength), animated: true)
        passwordLengthLabel.text = "Password Length: \(viewModel.passwordLength)"
        passwordFadeOutLabel.text = "Tap Below or Shake"
    }
    
    /// Animates the `passwordFadeOutLabel` up out of view and `passwordFadeInLabel` up (from bottom) in to view.
    /// This is a recursive function that will perform a faster animation and continue generating passwords if
    /// the user keeps holding down the `generatePasswordButton`.
    ///
    /// - parameters:
    /// 	- withFastAnimation: Determines if faster animation should be configured
    ///
    private func animatePasswordGeneration(withFastAnimation: Bool = false) {
        HapticEngine().hapticTap()
        
        do {
            try viewModel.generatePassword()
        }
        catch {
            presentErrorAlert(error as? PasswordGenerationError ?? .unknown)
            generatePasswordButton.isEnabled = true
            return
        }
        
        // Label with new password that will animate into view
        passwordFadeInLabel.attributedText = viewModel.styledPassword
        
        UIView.animate(withDuration: withFastAnimation ? 0.07 : 0.32,
                       delay: 0,
                       usingSpringWithDamping: withFastAnimation ? 0.1 : 0.5,
                       initialSpringVelocity: 5,
                       animations: { performLayoutUpdatesForAnimation() }) { _ in
            self.generatePasswordButton.isEnabled = true
            self.passwordFadeOutLabel.attributedText = self.passwordFadeInLabel.attributedText
            
            performLayoutUpdatesForCompletion()
            
            if self.generatePasswordButton.state == .highlighted {
                self.animatePasswordGeneration(withFastAnimation: true)
            }
        }
        
        /// Animates the old password out of view and new password in to view
        func performLayoutUpdatesForAnimation() {
            passwordFadeOutLabel.alpha = 0
            passwordFadeOutLabelBottomConstraint.constant = passwordLabelViewContainer.frame.height
            passwordFadeInLabel.alpha = 1
            passwordFadeInLabelBottomConstraint.constant = 0
            view.layoutIfNeeded()
        }
        
        /// Reposition labels to prepare for next animation
        func performLayoutUpdatesForCompletion() {
            passwordFadeOutLabel.alpha = 1
            passwordFadeOutLabelBottomConstraint.constant = 0
            passwordFadeInLabel.alpha = 0
            passwordFadeInLabelBottomConstraint.constant = 0 - passwordLabelViewContainer.frame.height
            view.layoutIfNeeded()
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func attributeSwitchDidChange(_ attributeSwitch: NPAttributeSwitch) {
        let attributes = passwordSwitches.filter { $0.isOn }.map { switchThatIsOn -> PasswordAttribute in
            return switchThatIsOn.attributeType
        }
        
        viewModel.passwordAttributes = attributes
    }
    
    @IBAction private func passwordLengthSliderDidMove(_ sender: UISlider) {
        let newPasswordLength = Int(passwordLengthSlider.value)
        viewModel.passwordLength = newPasswordLength
        passwordLengthLabel.text = "Password Length: \(newPasswordLength)"
    }
    
    @IBAction private func generatePasswordTouchBegan(_ sender: UIButton) {
        generatePasswordButton.isEnabled = false
        animatePasswordGeneration()
    }
    
    // MARK: - Share Activity
    
    @objc private func presentPasswordShare() {
        let items = [viewModel.styledPassword.string]
        let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        // Because why...
        vc.excludedActivityTypes = [.postToFacebook, .postToTwitter]
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Error Handling
    
    private func presentErrorAlert(_ error: PasswordGenerationError) {
        let alertViewController = NPAlertViewController(title: error == .noAttributes ? "Hold On" : "Uh Oh",
                                                        message: error.description,
                                                        buttonTitle: "Okay") {
            self.generatePasswordButton.isEnabled = true
        }
        alertViewController.modalPresentationStyle = .overFullScreen
        alertViewController.modalTransitionStyle = .crossDissolve
        alertViewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        present(alertViewController, animated: true)
        HapticEngine().hapticWarning()
    }
    
}

extension PasswordGeneratorViewController {
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        switch motion {
        case .motionShake:
            animatePasswordGeneration()
        default:
            break
        }
    }
    
}
