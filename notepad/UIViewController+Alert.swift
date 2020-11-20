//
// Created by Allie Kim on 2020/11/20.
//

import UIKit

extension UIViewController {
    func alert(title: String = "알림", message: String) {
        // alert 창
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // alert 액션
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        // 액션 추가
        alert.addAction(okAction)
        // 실행
        present(alert, animated: true, completion: nil)
    }
}