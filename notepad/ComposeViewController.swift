//
//  ComposeViewController.swift
//  notepad
//
//  Created by Allie Kim on 2020/11/20.
//

import UIKit

class ComposeViewController: UIViewController {
    // new memo
    @IBOutlet weak var memoTextView: UITextView!

    // cancel button
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    // save button
    @IBAction func save(_ sender: Any) {
        // 예외 처리 : 내용이 없을 경우, alert창이 나타난다.
        guard let memo = memoTextView.text, memo.count > 0 else {
            alert(message: "메모를 입력하세요")
            return
        }

        // 내용이 있는 경우, 메모를 리스트에 저장한다.
        let newMemo = Memo(content: memo)
        Memo.dummyMemoList.append(newMemo)
        //
        NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)


        // 작성 뷰를 dismiss 시킨다.
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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

// add notification
extension ComposeViewController {
    static let newMemoDidInsert = Notification.Name(rawValue: "newMemoDidInsert")


}
