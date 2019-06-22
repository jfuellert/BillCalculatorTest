//
//  Models.swift
//  BillCalculator
//
//  Created by Jeremy Fuellert on 2019-06-20.
//  Copyright © 2019 TouchBistro. All rights reserved.
//

import Foundation

/* An item used to describe a tax on a bill */
public enum Tax: Equatable {

    /* A percentage tax applied to an entire bill */
    case standard(Double)
    
    /* A percentage tax applied to only alcohol items */
    case alcohol(Double)
    
    public static func ==(lhs: Tax, rhs: Tax) -> Bool {
        switch (lhs, rhs) {
        case let (.standard(a), .standard(b)),
             let (.alcohol(a), .alcohol(b)):
            return a == b
        default:
            return false
        }
    }
}

/* An item used to determine bill discounts */
public enum Discount {

    /* A percentage discount used on a total bill (0.1) */
    case percentage(Double)
    
    /* A flat currency discount used on a total bill ($5.00) */
    case flatCurrency(NSDecimalNumber)
}

/* A bill item used as an input for bill calculations. This is used to calculate a final Bill model in a many (BillItem) to one (Bill) relationship */
public struct BillItem {
    
    /* Determines a type of tax to be used on an item */
    public enum TaxType {
    
        /* Exempt from taxation */
        case exempt
        
        /* Uses a standard tax */
        case standard
        
        /* Uses an alcohol tax */
        case alcohol
    }
    
    /* The unique identifier for the billable item */
    public let identifier: UUID
    
    /* The price of the item. This is a generic number value, untied to a locale */
    public let price: NSDecimalNumber
    
    /* Determines the item tax type */
    public let taxType: TaxType
    
    public init(identifier: UUID, price: NSDecimalNumber, taxType: TaxType) {
        self.identifier = identifier
        self.price      = price
        self.taxType    = taxType
    }
}

/* A bill model used to output calculated bill data */
public struct Bill {
    
    /* The local of the bill */
    let locale: Locale
    
    /* The total taxes applied */
    let totalTaxesApplied: NSDecimalNumber
    
    /* The total of all discounts applied. These discounts are applied after the total bill has been calculated with taxes */
    let totalDiscountsApplied: NSDecimalNumber
    
    /* The total bill cost pre-tax and pre-discounts */
    let totalPreDiscountPreTaxes: NSDecimalNumber
    
    /* The total bill cost post-tax and post-discounts */
    let total: NSDecimalNumber
}

/* A bill view model used to display bill data. This takes into consideration locale, inherited from a given Bill model, for currency conversion */
open class BillViewModel {
    
    // MARK: - Properties
    /* The bill model */
    public let model: Bill
    
    /* Returns a currency display string of taxes applied ("$4.00") */
    public var displayTaxesApplied: String? {
        return numberFormatter.string(from: model.totalTaxesApplied)
    }
    
    /* Returns a currency display string of discounts applied ("$5.00") */
    public var displayDiscountsApplied: String? {
        return numberFormatter.string(from: model.totalDiscountsApplied)
    }
    
    /* Returns a currency display string of the total bill pre-tax pre-discounts ("$50.00") */
    public var displayTotalBillPreDiscountPreTaxes: String? {
        return numberFormatter.string(from: model.totalPreDiscountPreTaxes)
    }
    
    /* Returns a currency display string of the total bill post-tax post-discounts ("$49.00") */
    public var displayTotalBill: String? {
        return numberFormatter.string(from: model.total)
    }
    
    /* The number formatter using a given locale */
    private lazy var numberFormatter: NumberFormatter = {
        
        let numberFormatter         = NumberFormatter()
        numberFormatter.locale      = model.locale
        numberFormatter.numberStyle = .currency
        
        return numberFormatter
    }()
    
    // MARK: - Init
    public init(_ model: Bill) {
        self.model = model
    }
}
