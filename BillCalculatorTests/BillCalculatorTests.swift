//
//  BillCalculatorTests.swift
//  BillCalculator
//
//  Created by Jeremy Fuellert on 2019-06-21.
//  Copyright © 2019 TouchBistro. All rights reserved.
//

import Quick
import Nimble

class BillCalculatorModelTests: QuickSpec {

    override func spec() {
        
        // MARK: - Create items
        let alcoholTax = Tax.alcohol(0.2)
        let pstTax     = Tax.standard(0.10)
        let gstTax     = Tax.standard(0.05)
        let taxes      = [alcoholTax, pstTax, gstTax]
        
        func discounts() -> [Discount] {
            return [Discount.percentage(0.15), Discount.percentage(0.1), Discount.flatCurrency(10.00)]
        }
        
        func items() -> [BillItem] {
            return [BillItem(identifier: UUID(), price: NSDecimalNumber(floatLiteral: 23.01), taxType: .alcohol),
                    BillItem(identifier: UUID(), price: NSDecimalNumber(floatLiteral: 54.21), taxType: .standard),
                    BillItem(identifier: UUID(), price: NSDecimalNumber(floatLiteral: 11.36), taxType: .standard),
                    BillItem(identifier: UUID(), price: NSDecimalNumber(floatLiteral: 9.18), taxType: .exempt),
                    BillItem(identifier: UUID(), price: NSDecimalNumber(floatLiteral: 100.0), taxType: .alcohol)]
        }
    
        /* Tax breakdown for each item
         23.01 * 0.2  = 4.602
         54.21 * 0.15 = 8.1315
         11.36 * 0.15 = 1.704
         9.18 —       = 0.0
         100 * 0.2    = 20
         
         Total tax          = 34.4375 -> 34.44
         Total pre-discount = 197.76 + 34.4375 -> 232.1975
         Total discount     = 56.4736
         Total              = 175.7239
         */
        
        // MARK: - Calculator
        describe("BillCalculator") {
            context("data") {
                
                let calculator = BillCalculator(taxes, locale: Locale(identifier: "en_US"))

                it("should not be nil") {
                    expect(calculator).toNot(beNil())
                }
                
                it("should contain the correct lcoale") {
                    expect(calculator.locale).to(equal(Locale(identifier: "en_US")))
                }
                
                it("should contain the correct taxes") {
                    expect(calculator.taxes.count).to(equal(3))
                }
            }
            
            context("bill output with no tax and no discounts") {
                
                let calculator = BillCalculator([], locale: Locale(identifier: "en_US"))
                
                it("should contain the no taxes") {
                    expect(calculator.taxes.count).to(equal(0))
                }
                
                let bill = calculator.bill(items(), discounts: nil)
                
                it("should not be nil") {
                    expect(bill).toNot(beNil())
                }
                
                it("should contain the correct lcoale") {
                    expect(bill.locale).to(equal(Locale(identifier: "en_US")))
                }
                
                it("should contain the correct tax data") {
                    expect(bill.totalTaxesApplied).to(equal(0.0))
                }
                
                it("should contain the correct discount data") {
                    expect(bill.totalDiscountsApplied).to(equal(0))
                }

                it("should contain the correct subtotal data") {
                    expect(bill.totalPreDiscountPreTaxes).to(equal(197.76))
                }
                
                it("should contain the correct total cost data") {
                    expect(bill.total.floatValue).to(equal(197.76))
                }
            }
            
            context("bill output with only tax") {

                let calculator =  BillCalculator(taxes, locale: Locale(identifier: "en_US"))
                let bill       = calculator.bill(items(), discounts: nil)
                
                it("should not be nil") {
                    expect(bill).toNot(beNil())
                }
                
                it("should contain the correct lcoale") {
                    expect(bill.locale).to(equal(Locale(identifier: "en_US")))
                }
                
                it("should contain the correct tax data") {
                    expect(bill.totalTaxesApplied).to(equal(34.4375))
                }
                
                it("should contain the correct discount data") {
                    expect(bill.totalDiscountsApplied).to(equal(0))
                }
                
                it("should contain the correct subtotal data") {
                    expect(bill.totalPreDiscountPreTaxes).to(equal(197.76))
                }
                
                it("should contain the correct total cost data") {
                    expect(bill.total.floatValue).to(equal(232.1975))
                }
            }
            
            context("bill output with only discounts") {

                let calculator = BillCalculator([], locale: Locale(identifier: "en_US"))
                it("should contain the no taxes") {
                    expect(calculator.taxes.count).to(equal(0))
                }

                let bill = calculator.bill(items(), discounts: discounts())

                it("should not be nil") {
                    expect(bill).toNot(beNil())
                }

                it("should contain the correct lcoale") {
                    expect(bill.locale).to(equal(Locale(identifier: "en_US")))
                }

                it("should contain the correct tax data") {
                    expect(bill.totalTaxesApplied).to(equal(0.0))
                }

                it("should contain the correct discount data") {
                    expect(bill.totalDiscountsApplied).to(equal(56.4736))
                }

                it("should contain the correct subtotal data") {
                    expect(bill.totalPreDiscountPreTaxes).to(equal(197.76))
                }

                it("should contain the correct total cost data") {
                    expect(bill.total.floatValue).to(equal(141.2864))
                }
            }
            
            context("bill output with tax and discounts") {

                let calculator =  BillCalculator(taxes, locale: Locale(identifier: "en_US"))
                let bill       = calculator.bill(items(), discounts: discounts())

                it("should not be nil") {
                    expect(bill).toNot(beNil())
                }

                it("should contain the correct lcoale") {
                    expect(bill.locale).to(equal(Locale(identifier: "en_US")))
                }

                it("should contain the correct tax data") {
                    expect(bill.totalTaxesApplied).to(equal(34.4375))
                }

                it("should contain the correct discount data") {
                    expect(bill.totalDiscountsApplied).to(equal(64.56641249999998976))
                }

                it("should contain the correct subtotal data") {
                    expect(bill.totalPreDiscountPreTaxes).to(equal(197.76))
                }

                it("should contain the correct total cost data") {
                    expect(bill.total.floatValue).to(equal(167.63108750000001024))
                }
            }

            context("bill output with tax and re-ordered discounts") {

                let calculator =  BillCalculator(taxes, locale: Locale(identifier: "en_US"))
                let bill       = calculator.bill(items(), discounts: discounts().reversed())
                
                it("should not be nil") {
                    expect(bill).toNot(beNil())
                }
                
                it("should contain the correct lcoale") {
                    expect(bill.locale).to(equal(Locale(identifier: "en_US")))
                }
                
                it("should contain the correct tax data") {
                    expect(bill.totalTaxesApplied).to(equal(34.4375))
                }
                
                it("should contain the correct discount data") {
                    expect(bill.totalDiscountsApplied).to(equal(62.21641249999998976))
                }
                
                it("should contain the correct subtotal data") {
                    expect(bill.totalPreDiscountPreTaxes).to(equal(197.76))
                }
                
                it("should contain the correct total cost data") {
                    expect(bill.total.floatValue).to(equal(169.9811))
                }
            }
        }
    }
}
