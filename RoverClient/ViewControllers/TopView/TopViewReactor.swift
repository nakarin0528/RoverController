//
//  TopViewReactor.swift
//  RoverClient
//
//  Created by yiheng on 2019/07/26.
//  Copyright © 2019 nakarin. All rights reserved.
//

import ReactorKit
import RxSwift

final class TopViewReactor: Reactor {

    enum Action {
        case start(String, String, String)
    }

    enum Mutation {
        case setLoading(Bool)
        case connect(Bool)
    }

    struct State {
        var isLoading: Bool
    }

    let initialState: State

    init() {
        initialState = State(
            isLoading: false
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .start:
            return Observable.concat(
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.connect(true)),
                Observable.just(Mutation.setLoading(false))
            )
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .connect(isSuccess):
            if isSuccess {
                print("接続成功！")
            }
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        }

        return state
    }
}

