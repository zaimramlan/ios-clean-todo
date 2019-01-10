//
//  ListTasksInteractorSpec.swift
//  CleanTodo
//
//  Created by Zaim Ramlan on 05/03/2018.
//  Copyright (c) 2018 zaimramlan. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import Quick
import Nimble
@testable import CleanTodo

class ListTasksInteractorSpec: QuickSpec {
    override func spec() {
        
        // MARK: - Subject Under Test (SUT)
        
        var sut: ListTasksInteractor!
        
        // MARK: - Test Doubles
        
        var workerSpy: ListTasksWorkerSpy!
        class ListTasksWorkerSpy: ListTasksWorker {
            var fetchFromDataStoreCalled = false
            override func fetchFromDataStore() -> [String] {
                fetchFromDataStoreCalled = true
                return []
            }
            
            var removeTaskCalled = false
            override func removeTask(_ task: String, from taskList: [String]) -> [String] {
                removeTaskCalled = true
                return []
            }
        }
        
        var presenterSpy: ListTasksPresentationLogicSpy!
        class ListTasksPresentationLogicSpy: ListTasksPresentationLogic {
            var presentFetchFromDataStoreResultCalled = false
            func presentFetchFromDataStoreResult(with response: ListTasksModels.FetchFromDataStore.Response) {
                presentFetchFromDataStoreResultCalled = true
            }
            
            var presentSelectTaskResultCalled = false
            func presentSelectTaskResult(with response: ListTasksModels.SelectTask.Response) {
                presentSelectTaskResultCalled = true
            }
        }

        // MARK: - Test Setup Helpers
        
        func setupListTasksInteractor() {
            sut = ListTasksInteractor()
        }
        
        func setupListTasksWorkerSpy() {
            workerSpy = ListTasksWorkerSpy()
            sut.worker = workerSpy
        }
        
        func setupListTasksPresenterSpy() {
            presenterSpy = ListTasksPresentationLogicSpy()
            sut.presenter = presenterSpy
        }
        
        // MARK: - Tests
        
        beforeEach {
            setupListTasksInteractor()
            setupListTasksWorkerSpy()
            setupListTasksPresenterSpy()
        }
        
        describe("fetchFromDataStore") {
            beforeEach {
                let request = ListTasksModels.FetchFromDataStore.Request()
                sut.fetchFromDataStore(with: request)
            }
            
            it("should ask worker to fetch from data store", closure: {
                expect(workerSpy.fetchFromDataStoreCalled).to(beTrue())
            })
            
            it("should ask presenter to format the data", closure: {
                expect(presenterSpy.presentFetchFromDataStoreResultCalled).to(beTrue())
            })
        }
        
        describe("selectTask") {
            context("with a selected task and tasks initialised", closure: {
                beforeEach {
                    sut.tasks = Seeds.tasks
                    let request = ListTasksModels.SelectTask.Request(task: Seeds.tasks.first!)
                    sut.selectTask(with: request)
                }
                
                it("should ask worker to remove the selected task", closure: {
                    expect(workerSpy.removeTaskCalled).to(beTrue())
                })
                
                it("should ask presenter to format the result", closure: {
                    expect(presenterSpy.presentSelectTaskResultCalled).to(beTrue())
                })
            })
            
            context("without a selected task and/or tasks not initialised", closure: {
                beforeEach {
                    sut.tasks = nil
                    let request = ListTasksModels.SelectTask.Request(task: nil)
                    sut.selectTask(with: request)
                }
                
                it("should return", closure: {
                    expect(workerSpy.removeTaskCalled).to(beFalse())
                    expect(presenterSpy.presentSelectTaskResultCalled).to(beFalse())
                })
            })
        }
    }
}
