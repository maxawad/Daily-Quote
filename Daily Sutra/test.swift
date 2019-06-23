//
//  test.swift
//  Daily Quote
//
//  Created by Moustafa Awad on 6/17/19.
//  Copyright © 2019 Moustafa Awad. All rights reserved.
//

import UIKit

class test: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension test: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell") as! QuoteCell

        cell.Author.text = "Tet"
        cell.Quote.text = "LOL"
        cell.heightAnchor.constraint(equalToConstant: CGFloat(integerLiteral: 100))
        return cell
    }
    
    
}
