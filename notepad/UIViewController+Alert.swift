//
// Created by Allie Kim on 2020/11/20.
//

import UIKit

extension UIViewController {
    func alert(title: String = "알림", message: String) {
        // alert 객체를 생성한다.
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // alert 액션을 생성한다.
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        // alert에 액션을 연결한다.
        alert.addAction(okAction)
        // 실행한다.
        present(alert, animated: true, completion: nil)
    }
}