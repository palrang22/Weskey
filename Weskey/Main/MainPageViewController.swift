
import UIKit

class MainPageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var RecentPost: UICollectionView!
    
    var recentPosts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RecentPost.dataSource = self
        RecentPost.delegate = self
        
        setupCollectionViewLayout()
        
        recentPosts = sampleData.prefix(5).map { $0 }
        RecentPost.reloadData()
    }
    
    @IBAction func ViewAllPostTapped(_ sender: Any) {
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 2
        }
    }
    
    func setupCollectionViewLayout() {
        if let layout = RecentPost.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 0
            layout.estimatedItemSize = .zero
            layout.minimumLineSpacing = 10
            layout.itemSize = CGSize(width: RecentPost.frame.width, height: 62)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCollectionCell", for: indexPath) as! RecentPostCell
        let post = recentPosts[indexPath.item]
        cell.configure(with: post)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 62)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post: Post = recentPosts[indexPath.item]
        performSegue(withIdentifier: "ShowDetailPostFromMain", sender: post)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailPostFromMain",
           let detailVC = segue.destination as? DetailPostViewController,
           let post = sender as? Post {
            detailVC.post = post
        }
    }
}

class RecentPostCell: UICollectionViewCell {
    @IBOutlet weak var segImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellBorder()
    }
    
    func setupCellBorder() {
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.borderWidth = 1.0
        contentView.layer.cornerRadius = 8.0
        contentView.layer.masksToBounds = true
    }
    
    func configure(with post: Post) {
        titleLabel.text = post.title
        contentLabel.text = post.content
        let separator = UIView(frame: CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: 1))
        separator.backgroundColor = UIColor.lightGray
        self.contentView.addSubview(separator)
    }
}
