//
//  Booking.swift
//  EasyStay
//
//

import Foundation

struct Booking: Identifiable {
    let id: String
    let userId: String
    let listingId: String
    let startDate: Date
    let endDate: Date
    let guests: Int
}
