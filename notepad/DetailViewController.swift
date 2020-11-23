//
//  DetailViewController.swift
//  notepad
//
//  Created by Allie Kim on 2020/11/20.
//

import UIKit

class DetailViewController: UIViewController {

    // reload
    @IBOutlet weak var memoTableView: UITableView!

    //이전 화면(MemoListTableView)에서 전달한 메모가 저장될 속성이다.
    var memo: Memo?

    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long // .long(ENUM) == DateFormatter.Style.long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr") // 언어를 한글로 설정한다.
        return f
    }()

    // share button
    @IBAction func share(_ sender: Any) {
        guard let memo = memo?.content else { return }
        let vc = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
        present(vc, animated: true, completion: nil)
    }

    // delete button
    @IBAction func deleteMemo(_ sender: Any) {
        let alert = UIAlertController(title: "삭제 확인", message: "메모를 삭제할까요?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "삭제", style: .destructive, handler: { [weak self] (action) in DataManager.shared.deleteMemo(self?.memo)
            // db의 메모 삭제 후 이전 화면을 pop한다.
            self?.navigationController?.popViewController(animated: true)
        })
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination.children.first as? ComposeViewController {
            vc.editTarget = memo
        }
    }

    var token: NSObjectProtocol?

    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // 편집한 내용을 reload하기 위한 observer이다.
        token = NotificationCenter.default.addObserver(forName: ComposeViewController.memoDidChange, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in self?.memoTableView.reloadData()
        })
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
// MARK: - Extension
extension DetailViewController: UITableViewDataSource {
    // 테이블 뷰가 표시할 셀 숫자를 return 한다.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    // 테이블 뷰가 어떤 셀을 호출할지 나타낸다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            // dequeueReusableCell(withIdentifier: String, for: indexPath)
            // identifier로 재사용할 객체(셀)를 선택, 그 셀의 위치가 저장된 indexPath로 셀의 위치를 찾아 cell 변수에 저장한다.
            let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell", for: indexPath)
            cell.textLabel?.text = memo?.content
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
            cell.textLabel?.text = formatter.string(for: memo?.insertDate)
            // 모드에 따른 label text 색을 변경한다.
            if #available(iOS 11.0, *) {
                // assets에 만든 MyLableColor를 사용한다.
                cell.textLabel?.textColor = UIColor(named: "MyLabelColor")
            } else {
                // ios 11 이하의 경우, 다크모드를 지원하지 않기 때문에 lightGray로 고정한다.
                cell.textLabel?.textColor = UIColor.lightGray
            }
            return cell
        default:
            fatalError()
        }
    }
}
