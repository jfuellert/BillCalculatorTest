//
//  POSTests.swift
//  POSTests
//
//  Created by Tayson Nguyen on 2019-04-23.
//  Copyright © 2019 TouchBistro. All rights reserved.
//

import Quick
import Nimble
@testable import POS

class POSTests: QuickSpec {

    override func spec() {

        // MARK: - View Model
        describe("TaxViewModel") {
            context("data") {
                
                let viewModel = TaxViewModel()
                
                it("should not be nil") {
                    expect(viewModel).toNot(beNil())
                }
                
                it("should return the correct title") {
                    expect(viewModel.title(for: 0)).to(equal("Taxes"))
                }
                
                it("should return the correct number of sections") {
                    expect(viewModel.numberOfSections()).to(equal(1))
                }
                
                it("should return the correct number of rows") {
                    expect(viewModel.numberOfRows(in: 0)).to(equal(3))
                }
                
                it("should return the correct label") {
                    expect(viewModel.labelForTax(at: IndexPath(row: 0, section: 0))).to(equal("Tax 1 (5%)"))
                    expect(viewModel.labelForTax(at: IndexPath(row: 1, section: 0))).to(equal("Tax 2 (8%)"))
                    expect(viewModel.labelForTax(at: IndexPath(row: 2, section: 0))).to(equal("Alcohol Tax (10%)"))
                }
                
                it("should return the correct accessory type") {
                    
                    let check = UITableViewCell.AccessoryType.checkmark
                    let none  = UITableViewCell.AccessoryType.none
                    let enabled1 = taxes[0].isEnabled ? check : none
                    let enabled2 = taxes[1].isEnabled ? check : none
                    let enabled3 = taxes[2].isEnabled ? check : none

                    expect(viewModel.accessoryType(at: IndexPath(row: 0, section: 0))).to(equal(enabled1))
                    expect(viewModel.accessoryType(at: IndexPath(row: 1, section: 0))).to(equal(enabled2))
                    expect(viewModel.accessoryType(at: IndexPath(row: 2, section: 0))).to(equal(enabled3))
                }
                
                it("should correctly the toggle tax items") {
                    let enabled1 = taxes[0].isEnabled
                    let enabled2 = taxes[1].isEnabled
                    let enabled3 = taxes[2].isEnabled
                    viewModel.toggleTax(at: IndexPath(row: 0, section: 0))
                    expect(taxes[0].isEnabled).to(equal(!enabled1))
                    expect(taxes[1].isEnabled).to(equal(enabled2))
                    expect(taxes[2].isEnabled).to(equal(enabled3))
                }
            }
        }
    }
}
