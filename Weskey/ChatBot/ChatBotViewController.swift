import UIKit

class ChatBotViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backBarButtonItem = UIBarButtonItem(title: "뒤로가기", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .systemOrange
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    @IBAction func startCustomWhiskeyRecommendation(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowChatBot", sender: "맞춤 위스키 추천 시작!")
    }
    
    @IBAction func recommendValueWhiskey(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowChatBot", sender: "가성비 좋은 위스키 추천해줘")
    }
    
    @IBAction func recommendSpecialOccasionWhiskey(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowChatBot", sender: "특별한 기념일에 어울리는 위스키 추천해줘")
    }
    
    @IBAction func recommendBeginnerWhiskey(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowChatBot", sender: "초보자도 먹기 쉬운 위스키 추천해줘")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChatBot",
           let destinationVC = segue.destination as? ChattingViewController,
           let initialMessage = sender as? String {
            destinationVC.initialMessage = initialMessage
            destinationVC.clearMessages()
        }
    }
}
