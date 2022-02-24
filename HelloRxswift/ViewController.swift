import UIKit
import RxSwift

class ViewController: UIViewController {
    
    
    @IBOutlet weak var applyFilterButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true //titulos maiores
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let navC = segue.destination as? UINavigationController,
            let photosCVC = navC.viewControllers.first as? PhotosCollectionViewController else {
                fatalError("Segue destination is not found")
            }
        
        photosCVC.selectedPhoto.subscribe(onNext: { [weak self] photo in
            self?.updateUi(with: photo)
            
        }).disposed(by: self.disposeBag)
        
    }
    
    private func updateUi(with image: UIImage) {
        self.photoImageView.image = image
        self.applyFilterButton.isHidden = false
    }
    
    @IBAction func applyFilter(_ sender: Any) {
        guard let sourceImage = self.photoImageView.image else { return }
        
        FilterService().applyFilter(to: sourceImage).subscribe(onNext: { filteredImage in
            DispatchQueue.main.async {
                self.photoImageView.image = filteredImage
            }
        }).disposed(by: disposeBag)
        
    }
}

