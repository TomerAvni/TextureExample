//
//  ViewController.swift
//  Texture Test
//

import UIKit
import AsyncDisplayKit

class ViewController: ASViewController<ASDisplayNode> {

    init() {
        super.init(node: ASDisplayNode())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        let addedView = UIView(frame: CGRect(x: 0, y:0, width: view.bounds.width, height: view.bounds.height / 2))
        addedView.backgroundColor = .red
        view.addSubview(addedView)
        
        
        
        let viewWithNode = Subview(frame: CGRect(x: 0, y:view.bounds.height / 2, width: view.bounds.width, height: view.bounds.height / 2))
        viewWithNode.backgroundColor = .orange
        view.addSubview(viewWithNode)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class Subview: UIView {
    let _asDisplayNode: ASDisplayNode
    
    override init(frame: CGRect) {
        _asDisplayNode = ASDisplayNode()
        super.init(frame: frame)
        addSubnode(_asDisplayNode)
        _asDisplayNode.backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        _asDisplayNode.frame = CGRect(x:100, y:0, width: frame.width, height: frame.height)
        super.layoutSubviews()
    }
}

