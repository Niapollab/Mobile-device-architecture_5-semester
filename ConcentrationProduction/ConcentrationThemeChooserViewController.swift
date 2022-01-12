import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {
    let themes = [
        "Sports": "⚽️🏀🏈⚾️🥎🎾🏐🏉🎱🪀",
        "Animals": "🐶🐱🐭🐹🐰🦊🐻🐼🐨🐯",
        "Faces": "😀😃😄😁😆😅😂🤣☺️😊"
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
    
    @IBAction func changeTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle {
                let theme = themeName == "Random" ? themes[themes.keys.randomElement()!]! : themes[themeName]!
                cvc.theme = theme
            }
        } else if let cvc = lastSeguedToConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle {
                let theme = themeName == "Random" ? themes[themes.keys.randomElement()!]! : themes[themeName]!
                cvc.theme = theme
            }
            navigationController?.pushViewController(cvc, animated: true)
        }
        else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle {
                let theme = themeName == "Random" ? themes[themes.keys.randomElement()!]! : themes[themeName]!
                print(theme)
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.theme = theme
                    lastSeguedToConcentrationViewController = cvc
                }
            }
        }
    }
}
