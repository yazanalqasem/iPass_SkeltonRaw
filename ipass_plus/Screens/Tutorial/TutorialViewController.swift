//
//  TutorialViewController.swift
//  ipass_plus
//
//  Created by MOBILE on 18/04/24.
//

import UIKit

class TutorialViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var nxtBtn: UIButton!
    @IBOutlet weak var pgController: UIPageControl!
    @IBOutlet weak var tutorialCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tutorialCollection.dataSource = self
                // register the cells, so the collectionView will "know" which cell you are referring to.
        self.tutorialCollection.register(UINib(nibName: "TutorialCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TutorialCollectionViewCell")
        // Do any additional setup after loading the view.
       
    }
    
    @IBAction func skipClick(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func nextClick(_ sender: Any) {
        let visibleItems: NSArray = self.tutorialCollection.indexPathsForVisibleItems as NSArray
            let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
          
        let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
        
        if(nextItem.row < 4) {
            if(nextItem.row == 3) {
                nxtBtn.setTitle("Home", for: .normal)
            }
            else {
                nxtBtn.setTitle("Next", for: .normal)
            }
            self.pgController.currentPage = nextItem.row
            self.tutorialCollection.scrollToItem(at: nextItem, at: .left, animated: true)
        }
        else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
//                   if nextItem.row < ImgArr.count {
//                self.collectionView.scrollToItem(at: nextItem, at: .left, animated: true)
//
//            }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
        pgController.numberOfPages = 4
       
        tutorialCollection.reloadData()
    }
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 10 // Assuming 'photos' is your array of pages
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            // return number of cell you wanted to show, based on your data model
            return 4
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorialCollectionViewCell", for: indexPath) as! TutorialCollectionViewCell
            //cell.lbl.text = String(indexPath.row)
            cell.img.image = UIImage.init(named: "t" + String(indexPath.row + 1))
          
            if(indexPath.row == 3) {
                nxtBtn.setTitle("Home", for: .normal)
            }
            else {
                nxtBtn.setTitle("Next", for: .normal)
            }
            
            return cell
        }

    private func scrollViewDidScroll(scrollView: UIScrollView) {
        let xPoint = scrollView.contentOffset.x + scrollView.frame.width / 2
        let yPoint = scrollView.frame.height / 2
        let center = CGPoint(x: xPoint, y: yPoint)
        if let ip = tutorialCollection.indexPathForItem(at: center) {
            self.pgController.currentPage = ip.row
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let indexPath = tutorialCollection.indexPathsForVisibleItems.first {
            pgController.currentPage = indexPath.row
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height:collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
        
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
        
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets.zero
        }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
