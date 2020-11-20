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
4. 데이서 소스 구현
5. 델리게이트 구현
*/

import UIKit

class MemoListTableViewController: UITableViewController {

    // date format 설정
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long // .long(ENUM) == DateFormatter.Style.long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // ==getItemCount(), 초기 테이블 뷰의 셀 갯수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Memo.dummyMemoList.count
    }

    // onBindViewHolder() 와 같은 기능 >> cell 하나씩 출력하기 때문에 반복 수행
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // id "cell"인 tableView의 prototype(==recycler item)을 설정
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // indexPath.row로 데이터에 접근
        let target = Memo.dummyMemoList[indexPath.row]
        // cell에 데이터 추가
        cell.textLabel?.text = target.content
//        cell.detailTextLabel?.text = target.insertDate.description
        cell.detailTextLabel?.text = formatter.string(from: target.insertDate)
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

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
