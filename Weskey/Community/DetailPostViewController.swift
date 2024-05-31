
import UIKit

class DetailPostViewController: UIViewController {
    
    @IBOutlet weak var PostTitle: UILabel!
    @IBOutlet weak var PostContent: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    
    var post: Post?
    var likeCount: Int = 0
    var dislikeCount: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        updateButtonTitles()
        if let post = post {
            PostTitle.text = post.title
            PostContent.text = post.content
        }
        PostContent.setLineSpacing(lineSpacing: 5)
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        likeCount += 1
        updateButtonTitles()
    }
    
    @IBAction func dislikeButtonTapped(_ sender: UIButton) {
        dislikeCount += 1
        updateButtonTitles()
    }
    
    func updateButtonTitles() {
        likeButton.setTitle("추천   \(likeCount)", for: .normal)
        dislikeButton.setTitle("비추천   \(dislikeCount)", for: .normal)
    }

}
    
    
    
