# Drag issue with ASDisplayNode

When adding a dragged node from a supernode to another, it causes the panGesture to be cancelled. 

`private func dragged(_ panGesture: UIPanGestureRecognizer) {
        guard panGesture.view != nil else {return} // View here is wrapped in ASDisplayNode
        switch panGesture.state {
            case .began:
                self.superview!.superview!.addSuperview(panGesture.view!)
            case .cancelled:
                print("Cancelled!") /// Fires, Why???
        }
}`

However, this exact example works perfectly with `UIKit` default `UIView`s.

Also, moving the layers to super does *work(ish)*, and doesn't detach the layer from the node, but it's coordination is set to (0,0) (on the supernode.supernode)
The problem with this approach is that I cannot manipulate the layer directly, nor the node/uiview position change affect anything. (including all sorts of `setNeedsLayout, setNeedsDisplay`.

For some reason on the next .changed event, if I change the view position, it does affect it. (Code with notes):
`
@objc func dragged(_ panGesture: UIPanGestureRecognizer) {
        guard let draggedView = panGesture.view else { return }
        
        switch panGesture.state {
        case .began:
            _beginDragLocation = draggedView.center
            _beginDragLocation = draggedView.convert(_beginDragLocation!, to: supernode!.supernode!.view)
            
//            supernode!.supernode!.view.addSubview(draggedView) // Causes immeditate cancelled.
            
            // The following does work(ish), however, it detaches the relaion between the CALayer and the UIView.
            // So from that point, I cannot directly manipulate neither the view nor the layer (since the view reference is gone).
            supernode!.supernode!.layer.addSublayer(draggedView.layer)
            
            // draggedView.center = _beginDragLocation! // not working
            // self.style.layoutPosition = _beginDragLocation! // not working either
            // self.setNeedsLayout()
            // self.setNeedsDisplay()
        case .changed:
            let translation = panGesture.translation(in: self.supernode!.supernode!.view)
//            draggedView.center = CGPoint(x: _beginDragLocation!.x + translation.x, y: _beginDragLocation!.y + translation.y) // when applited, it does cause the node to change position.
        case .cancelled:
            print("cancelled!")
        default:
            print("default!")
        }
        
}
`
