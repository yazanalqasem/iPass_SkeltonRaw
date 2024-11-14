import UIKit

class FiveImageCarouselFlowLayout: UICollectionViewFlowLayout {
    
    let scaleFactor: CGFloat = 0.5 // Scale down for non-center items
    let activeDistance: CGFloat = 250 // Distance at which scaling applies
    let rotationAngle: CGFloat = .pi / 10 // Angle for 3D rotation
    
    override func prepare() {
        super.prepare()
        scrollDirection = .horizontal
        minimumLineSpacing = -100 // Negative spacing for overlap
        itemSize = CGSize(width: 200, height: 300) // Adjust size to allow 5 items
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        let centerX = collectionView!.contentOffset.x + collectionView!.bounds.size.width / 2
        
        for attribute in attributes {
            let distance = centerX - attribute.center.x
            let normalizedDistance = distance / activeDistance
            
            // Scale and rotate cells based on distance from center
            let scale = max(1 - abs(normalizedDistance) * (1 - scaleFactor), scaleFactor)
            let rotation = normalizedDistance * rotationAngle
            
            var transform = CATransform3DIdentity
            transform = CATransform3DScale(transform, scale, scale, 1.0)
            transform = CATransform3DRotate(transform, rotation, 0, 1, 0)
            
            attribute.transform3D = transform
            attribute.zIndex = Int(scale * 10)
        }
        
        return attributes
    }
    
    // Ensure snapping to center item when scrolling
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let collectionViewCenter = collectionView!.bounds.size.width / 2
        let proposedCenterX = proposedContentOffset.x + collectionViewCenter
        
        guard let attributes = layoutAttributesForElements(in: collectionView!.bounds) else { return .zero }
        
        var closestAttribute: UICollectionViewLayoutAttributes?
        
        for attribute in attributes {
            if closestAttribute == nil || abs(attribute.center.x - proposedCenterX) < abs(closestAttribute!.center.x - proposedCenterX) {
                closestAttribute = attribute
            }
        }
        
        return CGPoint(x: closestAttribute!.center.x - collectionViewCenter, y: proposedContentOffset.y)
    }
}


