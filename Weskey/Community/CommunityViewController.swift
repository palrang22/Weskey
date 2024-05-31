
import UIKit

class CommunityViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var postingButton: UIButton!
    @IBOutlet weak var CommunitySegment: UISegmentedControl!
    @IBOutlet weak var BestPosts: UICollectionView!
    @IBOutlet weak var PostCollections: UICollectionView!
    
    var filteredPosts: [Post] = []
    var bestPosts: [Post] = bestSampleData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BestPosts.dataSource = self
        BestPosts.delegate = self
        PostCollections.dataSource = self
        PostCollections.delegate = self
        
        setupCollectionViewLayout(for: BestPosts)
        setupCollectionViewLayout(for: PostCollections)
        
        filterPosts(for: CommunitySegment.selectedSegmentIndex)
        
        configButton()
    }
    
    @IBAction func PostingButtonTapped(_ sender: Any) {
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        filterPosts(for: sender.selectedSegmentIndex)
    }
    
    func configButton() {
        postingButton.layer.shadowColor = UIColor.black.cgColor
        postingButton.layer.shadowOpacity = 0.5
        postingButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        postingButton.layer.shadowRadius = 4
    }
    
    func setupCollectionViewLayout(for collectionView: UICollectionView) {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 0
            layout.estimatedItemSize = .zero
            layout.minimumLineSpacing = 10
        }
    }
    
    func filterPosts(for index: Int) {
        let category = CommunitySegment.titleForSegment(at: index) ?? ""
        if category == "전체" {
            filteredPosts = sampleData
        } else {
            filteredPosts = sampleData.filter { $0.category == category }
        }
        PostCollections.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == BestPosts {
            return bestPosts.count
        } else {
            return filteredPosts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == BestPosts {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestPostCell", for: indexPath) as! BestPostCell
            let post = bestPosts[indexPath.item]
            cell.configure(with: post)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCollectionCell", for: indexPath) as! PostCollectionCell
            let post = filteredPosts[indexPath.item]
            cell.configure(with: post)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 62)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post: Post
        if collectionView == BestPosts {
            post = bestPosts[indexPath.item]
        } else {
            post = filteredPosts[indexPath.item]
        }
        performSegue(withIdentifier: "ShowDetailPost", sender: post)
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailPost",
           let detailVC = segue.destination as? DetailPostViewController,
           let post = sender as? Post {
            detailVC.post = post
        }
    }
}


class BestPostCell: UICollectionViewCell {
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


class PostCollectionCell: UICollectionViewCell {
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
        
        switch post.category {
        case "자유":
            segImg.image = UIImage(named: "communityFree")
        case "리뷰":
            segImg.image = UIImage(named: "communityReview")
        case "꿀팁":
            segImg.image = UIImage(named: "communityTip")
        case "질문":
            segImg.image = UIImage(named: "communityQuestion")
        default:
            segImg.image = nil
        }
    }
}
