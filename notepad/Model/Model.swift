//
// Created by ishift on 2020/11/19.
//

import Foundation

class Memo {
    var content: String
    var insertDate: Date

    init(content: String) {
        self.content = content
        insertDate = Date()
    }

    static var dummyMemoList = [
        Memo(content: "hi 1"),
        Memo(content: "hi 2")
    ]

}