//
//  ConcentrationThemeChooserVC.swift
//  Set
//
//  Created by GANG_FANG on 2018/10/12.
//  Copyright © 2018 gfang. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserVC: UIViewController, UISplitViewControllerDelegate {

    private var themes = ["face": ["😀", "😃", "😄", "😁", "😆", "😅", "😂"],
                          "animal": ["🐶", "🐱", "🦊", "🐻", "🐹", "🐰", "🐭"],
                          "fruit": ["🍎", "🍐", "🍋", "🍉", "🍊", "🍌", "🍏"]]
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cencentrationGameVC = segue.destination as? ConcentrationGameVC {
            if segue.identifier == "faceTheme" {
                cencentrationGameVC.emojiChoices = themes["face"]
            } else if segue.identifier == "animalTheme" {
                cencentrationGameVC.emojiChoices = themes["animal"]
            } else if segue.identifier == "fruitTheme" {
                cencentrationGameVC.emojiChoices = themes["fruit"]
            }
        }
    }
    
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if let concentrationGameVC = secondaryViewController as? ConcentrationGameVC {
            if concentrationGameVC.emojiChoices == nil {
                return true
            }
        }
        return false
    }
}
