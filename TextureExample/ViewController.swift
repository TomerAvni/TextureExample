//
//  ViewController.swift
//  Texture Test
//

import UIKit
import AsyncDisplayKit

class ViewController: ASViewController<ASDisplayNode> {
    
    private let _dragView: DragView
    
    init() {
        _dragView = DragView()
        _dragView.backgroundColor = .orange
        _dragView.style.width = ASDimensionMake(100)
        _dragView.style.height = ASDimensionMake(100)
        
        super.init(node: ASDisplayNode())
        node.automaticallyManagesSubnodes = true
        
        let nodeContent = ASDisplayNode()
        nodeContent.automaticallyManagesSubnodes = true
        nodeContent.backgroundColor = .white
        nodeContent.style.width = ASDimension(unit: .fraction, value: 1)
        nodeContent.style.height = ASDimension(unit: .fraction, value: 1)
        node.addSubnode(nodeContent)
        
        let wrapper = ASDisplayNode()
        wrapper.backgroundColor = .red
        wrapper.automaticallyManagesSubnodes = true
        wrapper.clipsToBounds = true
        
        
        wrapper.layoutSpecBlock = {_,_ in
            return ASAbsoluteLayoutSpec(children: [self._dragView])
        }
        
        node.layoutSpecBlock = { _,_ in
            return ASInsetLayoutSpec(insets: .zero, child: nodeContent)
        }
        
        nodeContent.layoutSpecBlock = { _,_ in
            let wrapperInset = UIEdgeInsets(top: 80, left: 80, bottom: 80, right: 80)
            
            let wrapperWrapper = ASInsetLayoutSpec(insets: wrapperInset, child: wrapper)
            return ASInsetLayoutSpec(insets: .zero, child: wrapperWrapper)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class DragView: ASDisplayNode, UIGestureRecognizerDelegate {
    override func didLoad() {
        super.didLoad()
        let pan = UIPanGestureRecognizer(target: self, action:  #selector(self.dragged))
        pan.cancelsTouchesInView = false
        pan.delegate = self
        pan.minimumNumberOfTouches = 0
        view.addGestureRecognizer(pan)
    }
    
    private var _beginDragLocation: CGPoint?

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
    
    
}

