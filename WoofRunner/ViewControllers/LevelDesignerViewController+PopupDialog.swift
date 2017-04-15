//
//  LevelDesignerViewController+PopupDialog.swift
//  WoofRunner
//
//  Created by See Soon Kiat on 16/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import PopupDialog

extension LevelDesignerViewController {
    
    // - MARK: Popup Dialogs
    
    /**
     Displays a popup dialog that with a prompt. The dialog box is
     customised to display the results of a save level attempt.
     - parameter title: Title of the popup dialog box
     - parameter message: Message to be displayed in the dialog box
     */
    internal func showSaveFeedback(title: String, message: String) {
        let popup = PopupDialog(title: title, message: message, image: nil)
        
        let okBtn = DefaultButton(title: "OK") {
            popup.dismiss()
        }
        
        // Add buttons to dialog
        popup.addButton(okBtn)
        
        // Customising Dialog Style
        customisePopupDialog()
        
        self.present(popup, animated: true, completion: nil)
    }
    
    /**
     Displays a popup dialog that with a prompt. The dialog box is
     customised to display a reminder before exiting the Level Designer.
     */
    internal func showBackWarning() {
        let popup = PopupDialog(title: "Warning", message: "Any unsaved changes will be lost, proceed anyway?", image: nil)
        
        let okBtn = DefaultButton(title: "OK") {
            self.dismiss(animated: true, completion: nil)
        }
        
        let cancelBtn = CancelButton(title: "CANCEL") {
            popup.dismiss()
        }
        
        // Add buttons to dialog
        popup.addButtons([okBtn, cancelBtn])
        
        // Customising Dialog Style
        customisePopupDialog()
        
        self.present(popup, animated: true, completion: nil)
    }
    
    /**
     Displays a popup dialog that with a prompt. The dialog box is
     customised to display the text input area for renaming the level.
     */
    internal func showRenameDialog() {
        
        // Create a custom view controller
        let renameVC = RenameDialogViewController(nibName: "RenameDialogViewController", bundle: nil)
        
        // Create the dialog
        let popup = PopupDialog(viewController: renameVC, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: false)
        
        
        // Configure and add buttons
        let cancelBtn = CancelButton(title: "CANCEL", height: 60) {
            popup.dismiss()
        }
        
        let okBtn = DefaultButton(title: "OK", height: 60) {
            
            // Validate Input Level Name
            if self.validateLevelName(renameVC.getLevelName()) {
                
                // Hide warning text (in case it was previously visible)
                renameVC.hideWarningText()
                
                // Update Level Name
                self.currentLevelName = renameVC.getLevelName()
                self.spriteScene?.updateDisplayedLevelName(self.currentLevelName)
                
                // Dismiss popup
                popup.dismiss()
            } else {
                renameVC.showWarningText()
            }
        }
        okBtn.dismissOnTap = false
        
        
        popup.addButtons([cancelBtn, okBtn])
        customiseDialogButtons()
        
        // Present dialog
        present(popup, animated: true, completion: nil)
    }
    
    /// Handles the components required to customise the popup dialog
    private func customisePopupDialog() {
        customiseDialogAppearance()
        customiseDialogOverlayAppearance()
        customiseDialogButtons()
    }
    
    /// Handles the appearance of the dialog box
    private func customiseDialogAppearance() {
        let dialogAppearance = PopupDialogDefaultView.appearance()
        dialogAppearance.titleFont = UIFont(name: "AvenirNextCondensed-Bold", size: 25)!
        dialogAppearance.titleColor = UIColor(white: 0.4, alpha: 1)
        dialogAppearance.titleTextAlignment = .center
        dialogAppearance.messageFont = UIFont(name: "AvenirNextCondensed-DemiBold", size: 18)!
        dialogAppearance.messageColor = UIColor(white: 0.6, alpha: 1)
        dialogAppearance.messageTextAlignment = .center
    }
    
    /// Handles the overlay that masks the surrounding when a popup dialog is displayed
    private func customiseDialogOverlayAppearance() {
        let overlayAppearance = PopupDialogOverlayView.appearance()
        overlayAppearance.color = UIColor.clear
        overlayAppearance.blurRadius = 30
        overlayAppearance.blurEnabled = true
        overlayAppearance.liveBlur = false
    }
    
    /// Handles the appearance of the dialog buttons
    private func customiseDialogButtons() {
        // Default buttons
        let defaultBtnAppearance = DefaultButton.appearance()
        defaultBtnAppearance.titleFont = UIFont(name: "AvenirNextCondensed-DemiBold", size: 20)
        
        // Cancel Button
        let cancelBtnAppearance = CancelButton.appearance()
        cancelBtnAppearance.titleFont = UIFont(name: "AvenirNextCondensed-DemiBold", size: 20)
    }
    
    /// Handles the validation of the new level name
    private func validateLevelName(_ name: String) -> Bool {
        return !(name.characters.count < 5 || name.characters.count > 40)
    }
}
