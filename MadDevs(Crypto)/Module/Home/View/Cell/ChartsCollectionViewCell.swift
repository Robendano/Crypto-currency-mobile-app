//
//  ChartsCollectionViewCell.swift
//  MadDevs(Crypto)
//
//  Created by Рамазан Юсупов on 30/7/21.
//

import UIKit
import Charts

class ChartsCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet var imageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var percentLabel: UILabel!
  @IBOutlet weak var currencyLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var convertedLabel: UILabel!
  @IBOutlet weak var graphView: LineChartView!
  
  private var lineChartEntry: [ChartDataEntry] = []
  
  var chartNums: [Double] = []
  
  private var line1 = LineChartDataSet()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    imageView.setCircleCorner(with: 16)
  }
  
  func chart(with color: UIColor, nums: [Double]) {
    lineChartEntry.removeAll()
    for i in 0..<(nums.count) {
      let value = ChartDataEntry(x: Double(i), y: nums[i])
      lineChartEntry.append(value)
    }
    line1 = LineChartDataSet(entries: lineChartEntry)
    line1.drawValuesEnabled = false
    line1.colors = [color]
    line1.circleRadius = 0
    line1.circleHoleRadius = 0
    
    let data = LineChartData()
    data.addDataSet(line1)
    graphView.data = data
    graphView.rightAxis.enabled = false
    graphView.leftAxis.enabled = false
    graphView.xAxis.enabled = false
    graphView.legend.enabled = false
    graphView.isUserInteractionEnabled = false
    
  }
  
  func configureCell(with model: SaveModel, balance: Double) {
    guard let currency = model.currencies.first else {return}
    chartNums = [
      currency.percent_change_1h,
      currency.percent_change_24h,
      currency.percent_change_7d,
      currency.percent_change_30d,
      currency.percent_change_60d
    ]
    chart(with: setColorFor(currency: model.symbol), nums: chartNums)
    
    imageView.image = UIImage(named: setImage(for: model.symbol))
    titleLabel.text = model.symbol
    percentLabel.text = String(format: "%.02f", (currency.percent_change_1h)) + " %"
    percentLabel.textColor = (currency.percent_change_1h) > 0.0 ? .green : .red
    currencyLabel.text = "$"
    amountLabel.text = String(format: "%.02f", (currency.price))
    convertedLabel.text = String(format: "%.02f", (balance / (currency.price))) + (" \(model.symbol)")
  }
  
  func configureCell(with model: data, balance: Double) {
    guard let usd = model.quote?.uSD else {return}
    chartNums = [
      usd.percent_change_1h ?? 0.0,
      usd.percent_change_24h ?? 0.0,
      usd.percent_change_7d ?? 0.0,
      usd.percent_change_30d ?? 0.0,
      usd.percent_change_60d ?? 0.0
    ]
    chart(with: setColorFor(currency: model.symbol ?? ""), nums: chartNums)
    
    imageView.image = UIImage(named: setImage(for: model.symbol ?? ""))
    titleLabel.text = model.symbol
    percentLabel.text = String(format: "%.02f", (usd.percent_change_1h ?? 0.0)) + " %"
    percentLabel.textColor = (usd.percent_change_1h ?? 0.0) > 0.0 ? .green : .red
    currencyLabel.text = "$"
    amountLabel.text = String(format: "%.02f", (usd.price ?? 0.0))
    convertedLabel.text =  String(format: "%.02f", (balance / (usd.price ?? 0.0))) + (" \(model.symbol ?? "")")
  }
  
  private func setImage(for currency: String) -> String {
    ["ETH", "BTC", "XRP", "LTC"].contains(currency) ? currency : "UNK"
  }
  
  private func setColorFor(currency: String) -> UIColor {
    switch currency {
    case "BTC":
      return .red
    case "ETH":
      return .purple
    case "XRP":
      return .blue
    case "LTC":
      return .green
    default:
      return .cyan
    }
  }
}
