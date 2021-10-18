//
//  SearchViewController.swift
//  HELP
//
//  Created by Moon on 2021/10/14.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController, UISearchResultsUpdating {

    @IBOutlet weak var tvCountries: UITableView!
    let searchController = UISearchController()
    let list = countries
    
    var listData: [Nation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: "CountryCell", bundle: nil)
        tvCountries.register(nibName, forCellReuseIdentifier: "CountryCell")
        tvCountries.delegate = self
        tvCountries.dataSource = self
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
    
        getList()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
    }
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    
    func getList() {
        let url = "https://6155639c93e3550017b08978.mockapi.io/countries"
        // AF.request().responseJSON으로 호출하면 JSON형식의 response를 받는다.
        AF.request(url, method: .get).responseJSON { response in
            // response의 데이터를 받을 [Nation] 타입의 리스트 변수
            var countries: [Nation]
            do {
                let decoder = JSONDecoder()
                switch (response.result) {
                // 성공/실패 구분
                case .success:
                    // response의 data를 [Nation]로 변환
                    countries = try decoder.decode([Nation].self, from: response.data!)
                    debugPrint("출력결과 : \(countries)")
                    print(type(of: countries))
                    self.listData = countries
                    // reload Data!
                    DispatchQueue.main.async {
                        self.tvCountries.reloadData()
                    }
                case .failure(let error):
                    print("에러코드: \(error._code)")
                    print("에러사유: \(error.errorDescription!)")
                }
            } catch let parsingError {
                print("에러:", parsingError)
            }
        }.resume()
    }
    
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nationName = self.listData[indexPath.row].nationName
        let nationCode = self.listData[indexPath.row].nationCode
        UserDefaults.standard.set(nationName, forKey: "nationName")
        UserDefaults.standard.set(nationCode, forKey: "nationCode")
        dismiss(animated: true, completion: nil)
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as? CountryCell else { return UITableViewCell() }
        cell.lblCountry.text = "\(listData[indexPath.row].nationName)"
        cell.imgFlag.image = UIImage(named: "\(listData[indexPath.row].nationCode.lowercased()).png")
        return cell
    }
}
