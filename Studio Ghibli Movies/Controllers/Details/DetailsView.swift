//
//  DetailsView.swift
//  Studio Ghibli Movies
//
//  Created by Dielson Sales on 19/07/21.
//

import Foundation

import Parse

protocol DetailsView: NSObject {
    func updateDetails(details: PFObject)
}
