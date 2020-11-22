//
//  ComposeViewController.swift
//  notepad
//
//  Created by Allie Kim on 2020/11/20.
//

import UIKit

class ComposeViewController: UIViewController {
    // 편집 icon을 터치 했을 때 내용을 받는다.
    var editTarget: Memo?
    // 편집 이전의 내용을 담는다.
    var originalMemoContent: String?

    // new memo
    @IBOutlet weak var memoTextView: UITextView!

    // cancel button
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    // save button
    @IBAction func save(_ sender: Any) {
        // guard let 예외 처리 : 내용이 없을 경우, alert창이 나타난다.
        // 조건(BOOL): (memoTextView.text > 0) && (memo.count > 0)
        guard let memo = memoTextView.text, memo.count > 0 else {
            alert(message: "메모를 입력하세요")
            return
        }
        // 내용이 있는 경우, 메모를 리스트에 저장한다.
//        let newMemo = Memo(content: memo)
//        Memo.dummyMemoList.append(newMemo)

        // model의 변화를 notificationCenter에 postNotification으로 observer에 등록하기 위한 단계이다.
        // notificationCenter으로 notification이 오면, center는 등록된 observer list를 모두 스캔한다.
        // 이는 앱 성능을 저하시킬 가능성이 있다.
        // 따라서, 적절히 하나 이상의 notificationCenter를 만들어 사용해야 한다.
        // class var `default` : NotificationCenter { get }
        // 작성 뷰를 dismiss 시킨다.(ViewController method 이다.)

        // 편집된 메모일 경우 실행된다.
        if let target = editTarget {
            target.content = memo
            target.insertDate = Date()
            DataManager.shared.saveContext()
            // 편집된 메모는 memoDidchange notification을 observer에 등록한다.
            NotificationCenter.default.post(name: ComposeViewController.memoDidChange, object: nil)
        } else {
            // 새로운 메모일 경우 실행된다.
            DataManager.shared.addNewMemo(memo)
            // 새로운 메모는 newMemoDidInsert notification을 observer에 등록한다.
            NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)

        }
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // 편집 화면 일 경우 실행된다.
        if let memo = editTarget {
            navigationItem.title = "Edit Notes"
            memoTextView.text = memo.content
            originalMemoContent = memo.content
        } else {
            // 새로운 메모 일 경우 실행된다.
            navigationItem.title = "Add Notes"
            memoTextView.text = ""
        }
        memoTextView.delegate = self

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentationController?.delegate = self
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.presentationController?.delegate = nil
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

// MARK: Extension

extension ComposeViewController: UITextViewDelegate {
    // textview에서 편집할때 항상 호출된다.
    func textViewDidChange(_ textView: UITextView) {
        if let original = originalMemoContent, let edited = textView.text {
            if #available(iOS 13.0, *) {
                // pull down event
                // 편집 된 메모가 원본과 다르다면 true가 isModalInPresentation에 저장된다.
                // 그리고 아래의 presentationControllerDidAttemptToDismiss를 호출한다.
                isModalInPresentation = original != edited
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

extension ComposeViewController: UIAdaptivePresentationControllerDelegate {
    // pull down event를 막는다.
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        // ==alertDialog
        let alert = UIAlertController(title: "알림", message: "편집한 내용을 저장할까요?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: { [weak self] (action) in self?.save(action) })
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: { [weak self] (action) in self?.close(action) })
        alert.addAction(cancelAction)
        // ==showDialog
        present(alert, animated: true, completion: nil)
    }
}



// create notification
extension ComposeViewController {
    static let newMemoDidInsert = Notification.Name(rawValue: "newMemoDidInsert")
    static let memoDidChange = Notification.Name("memoDidChange")
}
