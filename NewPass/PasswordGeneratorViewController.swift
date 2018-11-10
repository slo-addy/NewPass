//
//  PasswordGeneratorViewController.swift
//  NewPass
//
//  Created by Addison Francisco on 7/17/18.
//  Copyright © 2018 Addison Francisco. All rights reserved.
//

import UIKit

struct Constants {
    static let DEFAULT_PASSWORD_LENGTH = 10
}

class PasswordGeneratorViewController: UIViewController {

    private var viewModel = PasswordGeneratorViewModel()

    // Default password length to be 10 characters
    private var passwordLength = Constants.DEFAULT_PASSWORD_LENGTH
    private var passwordString = NSAttributedString(string: "")
    private var passwordSwitches: [PasswordAttributeSwitch]!

    @IBOutlet weak var passwordLabelViewContainer: UIView!
    // Animates from center to top
    @IBOutlet weak var passwordLabel1: PasswordLabel!
    // Animates from bottom to center
    @IBOutlet weak var passwordLabel2: PasswordLabel!
    @IBOutlet weak var passwordLabel1BottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordLabel2BottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordLengthLabel: UILabel!
    @IBOutlet weak var passwordLengthSlider: UISlider!
    @IBOutlet weak var lowercaseLetterSwitch: PasswordAttributeSwitch!
    @IBOutlet weak var uppercaseLetterSwitch: PasswordAttributeSwitch!
    @IBOutlet weak var numberSwitch: PasswordAttributeSwitch!
    @IBOutlet weak var symbolSwitch: PasswordAttributeSwitch!
    @IBOutlet weak var generatePasswordButton: UIButton!

    // Change status bar to light color for app's dark background
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        generatePasswordButton.addTarget(self, action: #selector(generatePasswordTouchBegan(_:)), for: .touchDown) // see note below

        passwordSwitches = [lowercaseLetterSwitch, numberSwitch, symbolSwitch, uppercaseLetterSwitch]

        // Assign attributes to password switches
        lowercaseLetterSwitch.attributeType = .containsLowercaseLetters
        uppercaseLetterSwitch.attributeType = .containsUppercaseLetters
        numberSwitch.attributeType = .containsNumbers
        symbolSwitch.attributeType = .containsSymbols
        symbolSwitch.initialState = false // only this one should start off.

        // Roundify view corners
        passwordLabelViewContainer.roundify(cornerRadius: 6)
        generatePasswordButton.roundify(cornerRadius: 6)

        // Configure default password and update views
        defaultPasswordSetup()
    }

    @IBAction func attributeSwitchDidChange(_ attributeSwitch: PasswordAttributeSwitch) {
        // first, filter the switches that are on.
        // next, use 'map' to get the attribute type of each on-switch.
        viewModel.passwordAttributes = passwordSwitches.filter { $0.isOn }.map { switchThatIsOn -> PasswordAttribute in
            return switchThatIsOn.attributeType
        }
    }

    @IBAction func passwordLengthSliderDidMove(_ sender: Any) {
        passwordLength = Int(passwordLengthSlider.value)
        passwordLengthLabel.text = "Password Length: \(passwordLength)"
    }

    // I think most iOS applications use .touchUpInside
    // this is kind of fun to have it backwards, but also might not what users are expecting. not a big deal either way. 😀
    @IBAction @objc func generatePasswordTouchBegan(_ sender: UIButton) {
        generatePassword()
    }

    // since we can kickoff this chain of events from two places, either the button tap or the shake gesture,
    // it makes more sense to pull out the logic into its own function that can be called from either place. that way, we can have the
    // hasSelectedPasswordAttributes check in only one place.
    // Plus, in each place that kicksoff the chain of events, those places can simply call `generatePassword()`
    private func generatePassword() {

        // guard against no attributes selected. If we dont' have any, then don't even execute the rest of this function.
        // totally a style preference, but I think this is cleaner than if/else statements. This way, the rest of the function isn't nested inside an if/else block.
        guard viewModel.hasSelectedPasswordAttributes else {
            presentAlertForEmptyAttributes()
            return
        }

        // update the lables with our newly generated password:
        let newPassword = randomPasswordFromViewModel()

        // I updated this function so that it takes in the password.
        // I think that is easier to understand. Otherwise, some functions are saving to the variables at the top of the file, and others are reading from them
        // which can get really confusing to keep track of who is doing what. More passing data via functions and less saving them as class variables is generally better.
        // Note: I didn't go as far as I could have, but you get the idea. I bet it is possible to get rid of self.passwordString entirely, using only the lables to store the true value.
        updateLabels(with: newPassword)

        // I think this makes more sense here (in the button touch function, not the make-PW function)
        // When the user presses the button, 2 things happen. a) the pw updates. b) the haptic engine runs.
        // it seemed a little awkward for it to be in the randomPasswordFromViewModel() function... because it directly related to
        // user feedback, i.e. letting the user know they tapped thebutton, and it is not really related to making a random pw.
        HapticEngine.hapticTap(impactStyle: .light)
    }

    ///
    /// Generate and return the randomly generated pw.
    ///
    /// - Returns: will return a string
    ///
    private func randomPasswordFromViewModel() -> NSAttributedString {
        return viewModel.generateRandomPassword(length: passwordLength)
        // notice how simple this functions becomes when it only has one job: get the password from the view model. No more haptic or alert needed here.
    }

    private func updateLabelsForPassword() {
        passwordLabel2.attributedText = passwordString
        passwordLengthLabel.text = "Password Length: \(passwordLength)"
    }

    private func defaultPasswordSetup() {
        // Generate a default password when view loads
        passwordString = viewModel.generateRandomPassword(length: passwordLength)
        // Update password attribute switches for default password
        updateSwitchesToInitialState()
        // Update password legth slider for default password
        passwordLengthSlider.setValue(Float(passwordLength), animated: true)
        passwordLengthLabel.text = "Password Length: \(passwordLength)"
        // Update labels
        passwordLabel1.attributedText = passwordString
    }

    ///
    /// This function does a lot. It saves the new password as a variable at the top of this file, and also handles the animation of swapping out the
    /// old password for the new one in the UI. Plus, if the user still is holding down the button, this function will generate _another_ new password
    /// and call itself again.
    ///
    /// Perhaps consider renaming this function, as you have one function updateLabelsForPassword()
    /// that sounds like it should do something similar, but this one really does more than just update the lables... Not a big deal but still. 😀
    ///
    /// - Parameter newPassword: the new password to update to, both on the lable and in memory
    ///
    private func updateLabels(with newPassword: NSAttributedString, animationDuration: Double = 0.3) { // default to 0.3 if no duration provided
        self.passwordString = newPassword
        generatePasswordButton.isEnabled = false
        updateLabelsForPassword()

        UIView.animate(withDuration: animationDuration,
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

                        if self.generatePasswordButton.isHighlighted {
                            // if we are still holding down the button, call this function again, but this time with less duration.
                            self.updateLabels(with: self.randomPasswordFromViewModel(), animationDuration: 0.07)
                        }
        })


        func performLayoutUpdatesForAnimation() {
            self.passwordLabel1.alpha = 0
            self.passwordLabel1BottomConstraint.constant = 32
            self.passwordLabel2.alpha = 1
            self.passwordLabel2BottomConstraint.constant = 8
            self.view.layoutIfNeeded()
        }

        func performLayoutUpdatesForCompletion() {
            self.passwordLabel1.alpha = 1
            self.passwordLabel1BottomConstraint.constant = 8
            self.passwordLabel2.alpha = 0
            self.passwordLabel2BottomConstraint.constant = -16
            self.view.layoutIfNeeded()
        }
    }

    /// This function is used only for updating the switches to the initial default state
    private func updateSwitchesToInitialState() {
        passwordSwitches.forEach { passwordSwitch in

            passwordSwitch.setToInitialState()
        }
    }

    private func presentAlertForEmptyAttributes() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Hold On", message: "You need at least 1 attribute selected to generate a password.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Got it", style: .default, handler: { _ in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: {
            })
            HapticEngine.hapticWarning()
        }
    }
}

extension PasswordGeneratorViewController {
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        switch motion {
        case .motionShake:
            generatePassword() // call the exact same function that we called for the button press.
        default:
            // do nothing for other cases.
            // sort of a style thing, but I highly recommend using switches for all enums. using == can get messy and confusing fast.
            break
        }
    }
}
