//
//  ViewModelTests.swift
//  ConnectFourTests
//
//  Created by Jahid Hassan on 10/16/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
@testable import ConnectFour

class ViewModelTests: XCTestCase {
    fileprivate var mockedVM : ViewModelProtocol!
    fileprivate var service: ServiceProtocol!
    fileprivate var scheduler: TestScheduler!
    fileprivate var disposeBag: DisposeBag!
    
    override func setUp() {
        service = FakeService()
        mockedVM = ViewModel(with: service)
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        service = nil
        mockedVM = nil
        scheduler = nil
        disposeBag = nil
    }

    func test_initialState() {
        mockedVM.error
            .subscribe(onNext: { error in
                XCTAssertNil(error)
            }).disposed(by: disposeBag)
        
        mockedVM.column
            .subscribe(onNext: { clmn in
                XCTAssertEqual(clmn, Game.width)
            }).disposed(by: disposeBag)
        
        let expect = expectation(description: #function)
        var onNextCalled = 0
        mockedVM.isLoading
            .subscribe(onNext: { n in
                    onNextCalled += 1
            }, onCompleted: {
                expect.fulfill()
            }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 6.0) { error in
//            guard error == nil else {
//                fatalError(error!.localizedDescription)
//            }
            
            XCTAssertEqual(onNextCalled, 2)
        }
        
        mockedVM.resetGame()
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
