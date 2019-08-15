//
//  MovieTouchUITests.swift
//  MovieTouchUITests
//
//  Created by Willian Rafael Perez Rodrigues on 07/07/19.
//  Copyright © 2019 Will Rodrigues. All rights reserved.
//

import XCTest

class MovieTouchUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    func testUpcomingMoviesScrollPagination() {
        let app = XCUIApplication()
        let collectionView = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .collectionView).element
        collectionView.swipeUp()
        
        app.collectionViews.cells.element(boundBy: 0).otherElements.element(boundBy: 0).tap()
        app.navigationBars["Movie Details"].buttons["Upcoming"].tap()
        
        collectionView.swipeUp()
        collectionView.swipeUp()
        collectionView.swipeUp()
        collectionView.swipeUp()
        collectionView.swipeUp()
        
        collectionView.swipeDown()
        collectionView.swipeDown()
    }

    func testSearchMovies() {
        let app = XCUIApplication()

        let findYouMovieSearchField = app/*@START_MENU_TOKEN@*/.searchFields["Find you movie 🕵🏼‍♂️"]/*[[".otherElements[\"findMovie\"].searchFields[\"Find you movie 🕵🏼‍♂️\"]",".searchFields[\"Find you movie 🕵🏼‍♂️\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        findYouMovieSearchField.tap()
        findYouMovieSearchField.tap()
        
        let mKey = app/*@START_MENU_TOKEN@*/.keys["M"]/*[[".keyboards.keys[\"M\"]",".keys[\"M\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        mKey.tap()
        
        let aKey = app/*@START_MENU_TOKEN@*/.keys["a"]/*[[".keyboards.keys[\"a\"]",".keys[\"a\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        aKey.tap()
        
        let tKey = app/*@START_MENU_TOKEN@*/.keys["t"]/*[[".keyboards.keys[\"t\"]",".keys[\"t\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        tKey.tap()
        
        let rKey = app/*@START_MENU_TOKEN@*/.keys["r"]/*[[".keyboards.keys[\"r\"]",".keys[\"r\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        rKey.tap()
        
        let iKey = app/*@START_MENU_TOKEN@*/.keys["i"]/*[[".keyboards.keys[\"i\"]",".keys[\"i\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        iKey.tap()
        
        let xKey = app.keys["x"]
        xKey.tap()
        
        app.keyboards.buttons["Search"].tap()
        app.collectionViews.cells.element(boundBy: 0).otherElements.element(boundBy: 0).tap()
        app.navigationBars["Movie Details"].buttons["Upcoming"].tap()
    }
    
}
