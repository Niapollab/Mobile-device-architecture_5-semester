import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {
    let themes = [
        "Sports": "⚽️🏀🏈⚾️🥎🎾🏐🏉🎱🪀⛳️🏸",
        "Animals": "🐶🐱🐭🐹🐰🦊🐻🐼🐨🐯🐥🐴",
        "Faces": "😀😃😄😁😆😅😂🤣☺️😊😎🤩"
    ]
    
    private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    private var lastSeguedToConcentrationViewController: ConcentrationViewController?
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    

    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme == nil {
                return true
            }
        }
        return false
    }
    
    @IBAction private func changeDifficulty(_ sender: UIButton) {
        let difficulty = sender.titleLabel!.text!
        
        if let cvc = splitViewDetailConcentrationViewController {
            cvc.difficulty = difficulty
            print("cvc split")
        } else if let cvc = lastSeguedToConcentrationViewController {
            cvc.difficulty = difficulty
            print("cvc segue")
            navigationController?.pushViewController(cvc, animated: true)
        }
        else {
            print("perform segue")
            performSegue(withIdentifier: "Choose Difficulty", sender: sender)
        }
    }
    
    @IBAction private func changeTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle {
                let theme = themeName == "Random" ? themes[themes.keys.randomElement()!]! : themes[themeName]!
                cvc.theme = theme
            }
            print("cvc split")
        } else if let cvc = lastSeguedToConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle {
                let theme = themeName == "Random" ? themes[themes.keys.randomElement()!]! : themes[themeName]!
                cvc.theme = theme
            }
            print("cvc segue")
            navigationController?.pushViewController(cvc, animated: true)
        }
        else {
            print("perform segue")
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle {
                let theme = themeName == "Random" ? themes[themes.keys.randomElement()!]! : themes[themeName]!
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.theme = theme
                    lastSeguedToConcentrationViewController = cvc
                }
            }
        }
        
        if segue.identifier == "Choose Difficulty" {
            if let difficulty = (sender as? UIButton)?.currentTitle {
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.difficulty = difficulty
                    lastSeguedToConcentrationViewController = cvc
                }
            }
        }
    }
}
