//
//  MemoListTableViewController.swift
//  notepad
//
//  Created by Allie Kim on 2020/11/19.
//
/*
테이블 뷰 구현 이론
1. 테이블 뷰 배치
2. prototype cell design, add cell identifier
3. 데이터 소스, 델리게이트 연결
4. 데이터 소스 구현
5. 델리게이트 구현
*/

import UIKit

class MemoListTableViewController: UITableViewController {

    // date format 을 설정한다.
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long // .long(ENUM) == DateFormatter.Style.long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr") // 언어를 한글로 설정한다.
        return f
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        tableView.reloadData()
        //        print(#function)
        DataManager.shared.fetchMemo() // 배열을 데이터로 채운다.
        tableView.reloadData() // 저장된 데이터를 기반으로 테이블 뷰가 업데이트 된다.
    }

    var token: NSObjectProtocol?

    // 소멸자를 사용하여 observer를 제거한다.
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }

    // ****알아보기
    // segue가 연결된 화면을 생성하고, 화면을 전환하기 직전에 호출한다.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            if let vc = segue.destination as? DetailViewController {
                vc.memo = DataManager.shared.memoList[indexPath.row]
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // tableView를 reload하는 observer를 NotificationCenter에 등록한다.
        // observer는 NSObjectProtocol(a.k.a token)을 return 한다.
        // NotificationCenter.default.addObserver(forName: Name?, object: Any?, queue: OperationQueue?, using: @escaping (Notification) -> Void)
        // @escaping closure : 비동기 실행 또는 completionHandler로 사용되는 클로저의 경우
        // 하나의 함수가 마무리 된 상태에서만 다른 함수가 실행되도록 함수를 작성할 수 있다. 실행 순서를 정할 수 있다.
        // 어노테이션 또는 self를 사용해야 한다.
        // [weak self] param in : self를 사용하기 때문에 발생 할 수 있는 strong reference cycle을 피하기 위해서 설정한다.
        token = NotificationCenter.default.addObserver(forName: ComposeViewController.newMemoDidInsert, object: nil, queue: OperationQueue.main) { [weak self] (noti) in

            self?.tableView.reloadData()
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // == getItemCount(), 초기 테이블 뷰의 셀 갯수이다.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return DataManager.shared.memoList.count
    }

    // onBindViewHolder() 와 같은 기능이다. cell을 하나씩 출력하기 때문에 반복 수행한다.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // id "cell"인 tableView의 prototype(==recycler item)을 설정한다.
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // indexPath.row로 데이터에 접근한다.
        let target = DataManager.shared.memoList[indexPath.row]
        // cell에 데이터를 추가한다.
        cell.textLabel?.text = target.content
//        cell.detailTextLabel?.text = target.insertDate.description
        cell.detailTextLabel?.text = formatter.string(for: target.insertDate)
        
        // 모드에 따른 label text 색을 변경한다.
        // ***스토리보드에서 label color 를 Default(Label Color)로 설정해야 적용된다.***
        if #available(iOS 11.0, *) {
            // assets에 만든 MyLableColor를 사용한다.
            cell.detailTextLabel?.textColor = UIColor(named: "MyLabelColor")
        } else {
            // ios 11 이하의 경우, 다크모드를 지원하지 않기 때문에 lightGray로 고정한다.
            cell.detailTextLabel?.textColor = UIColor.lightGray
        }
        return cell
    }

    // 아래 3개의 func은 왼쪽 스와이프 시 삭제 기능을 위한 func이다.
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    // 스와이프 시 delete style로 만든다.
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let target = DataManager.shared.memoList[indexPath.row]
            DataManager.shared.deleteMemo(target)
            DataManager.shared.memoList.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
