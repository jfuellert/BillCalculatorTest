//
//  BillCalculator.swift
//  BillCalculator
//
//  Created by Jeremy Fuellert on 2019-06-21.
//  Copyright © 2019 TouchBistro. All rights reserved.
//

import Foundation

public class BillCalculator {
    
    // MARK: - Properties
    let taxes: [Tax]
    let locale: Locale
    
    // MARK: - Init
    public init(_ taxes: [Tax], locale: Locale = .current) {
        self.taxes  = taxes
        self.locale = locale
    }
    
    // MARK: - Updates
    public func bill(_ items: [BillItem], discounts: [Discount]?) -> Bill {
        
        //Item cost sum
        let totalPreDiscountPreTaxes = items.map({$0.price}).reduce(0, {$0 + ($1 as Decimal)})
        
        //Total tax percentages
        var totalStandardTaxes = 0.0
        var totalAlcoholTaxes  = 0.0
        for tax in taxes {
            switch tax {
                case .standard(let value):
                    totalStandardTaxes += value
                case .alcohol(let value):
                    totalAlcoholTaxes += value
            }
        }
        
        //Total taxes applied
        let totalTaxesApplied = calculateTaxes(items, standardTax: totalStandardTaxes, alcoholTax: totalAlcoholTaxes)
        
        //Total bill with only taxes
        let totalBillWithTaxes = totalPreDiscountPreTaxes + totalTaxesApplied
        
        //Total discounts
        let totalDiscountsApplied = calculateDiscount(discounts, totalBillWithTaxes: totalBillWithTaxes)
        
        //Total bill with taxes and discount
        let total = totalBillWithTaxes - totalDiscountsApplied
        
        return Bill(locale: locale, totalTaxesApplied: NSDecimalNumber(decimal: totalTaxesApplied), totalDiscountsApplied: NSDecimalNumber(decimal: totalDiscountsApplied), totalPreDiscountPreTaxes: NSDecimalNumber(decimal: totalPreDiscountPreTaxes), total: NSDecimalNumber(decimal: total))
    }
}

// MARK: - Calculalions
extension BillCalculator {
    
    fileprivate func calculateTaxes(_ items: [BillItem], standardTax: Double, alcoholTax: Double) -> Decimal {
        
        var taxes = 0.0
        for item in items {
            switch item.taxType {
                case .exempt:
                    continue
                case .alcohol:
                    taxes += item.price.doubleValue * alcoholTax
                case .standard:
                    taxes += item.price.doubleValue * standardTax
            }
        }
        
        return Decimal(taxes)
    }
    
    func calculateDiscount(_ discounts: [Discount]?, totalBillWithTaxes: Decimal) -> Decimal {
        
        guard let discounts = discounts else {
            return 0
        }
        
        var newBill = NSDecimalNumber(decimal: totalBillWithTaxes).doubleValue
        
        for discount in discounts {
            switch discount {
                case .percentage(let value):
                    newBill -= newBill * value
                case .flatCurrency(let value):
                    newBill -= value.doubleValue
            }
        }
        
        return totalBillWithTaxes - Decimal(newBill)
    }
}
