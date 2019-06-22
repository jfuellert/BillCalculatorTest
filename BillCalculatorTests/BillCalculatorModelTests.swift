//
//  BillCalculatorModelTests.swift
//  BillCalculatorModelTests
//
//  Created by Jeremy Fuellert on 2019-06-20.
//  Copyright © 2019 TouchBistro. All rights reserved.
//

import Quick
import Nimble
@testable import BillCalculator

class BillCalculatorModelTests: QuickSpec {
    
    override func spec() {
        
        // MARK: - Create items
        let model = Bill(locale: Locale(identifier: "en_GB"), totalTaxesApplied: 34.4375, totalDiscountsApplied: 11.53, totalPreDiscountPreTaxes: 54.1, total: 52.57)
        
        // MARK: - Model
        describe("BillModel") {
            context("data") {
                it("should not be nil") {
                    expect(model).toNot(beNil())
                }
                
                it("should contain the correct lcoale") {
                    expect(model.locale).to(equal(Locale(identifier: "en_GB")))
                }
                
                it("should contain the correct tax data") {
                    expect(model.totalTaxesApplied).to(equal(34.4375))
                }
                
                it("should contain the correct discount data") {
                    expect(model.totalDiscountsApplied).to(equal(11.53))
                }
                
                it("should contain the correct subtotal data") {
                    expect(model.totalPreDiscountPreTaxes).to(equal(54.10))
                }
                
                it("should contain the correct total cost data") {
                    expect(model.total).to(equal(52.57))
                }
            }
        }
        
        // MARK: - View Model
        describe("BillViewModel") {
            context("data") {
                
                let viewModel = BillViewModel(model)

                it("should not be nil") {
                    expect(viewModel).toNot(beNil())
                }
                
                it("should contain the correct tax data") {
                    expect(viewModel.displayTaxesApplied).to(equal("£34.44"))
                }
                
                it("should contain the correct discount data") {
                    expect(viewModel.displayDiscountsApplied).to(equal("£11.53"))
                }

                it("should contain the correct subtotal data") {
                    expect(viewModel.displayTotalBillPreDiscountPreTaxes).to(equal("£54.10"))
                }
                
                it("should contain the correct total cost data") {
                    expect(viewModel.displayTotalBill).to(equal("£52.57"))
                }
            }
        }
    }
}
