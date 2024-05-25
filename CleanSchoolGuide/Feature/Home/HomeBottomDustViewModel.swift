//
//  HomeBottomDustViewModel.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 5/19/24.
//

import Foundation
import Combine

final class HomeBottomDustViewModel {
    
    struct Input {
        let fetchWeather: AnyPublisher<(lat: Double?, lng: Double?), Never>
        let fetchInternal: AnyPublisher<Void, Never>
        let fetchExternal: AnyPublisher<Void, Never>
    }
    
    enum State {
        case wetherUpdated(humidity: String, temperature: String, date: String)
        case externalFineUpdate(dustState: FineStatusModel.Status, fineDustState: FineStatusModel.Status)
        case internalFineUpdate(state: InternalFineStatusModel.Status)
        case loading
        case none
        
        var isLoading: Bool {
            switch self {
            case .loading: return true
            default: return false
            }
        }
    }
    
    @Published var state: State = .none
    var isChecked: Bool = false
    private var cancellable = Set<AnyCancellable>()
    
    func bind(_ input: Input) {
        input
            .fetchWeather
            .debounce(for: 1, scheduler: RunLoop.main)
            .flatMap { [weak self] (lat, lng) -> AnyPublisher<WeatherModel?, Never> in
                guard let self else { return Empty().eraseToAnyPublisher() }
                if let lat, let lng {
                    return self.getWeather(lat: lat, lng: lng)
                } else {
                    return self.getWeather()
                }
            }
            .sink { [weak self] weather in
                guard
                    let self,
                    let weather,
                    let humidity = weather.humidity,
                    let temperature = weather.temperature,
                    let date = weather.date
                else { return }
                self.state = .wetherUpdated(humidity: humidity, temperature:temperature, date: date)
            }
            .store(in: &cancellable)
        
        input
            .fetchExternal
            .flatMap { [weak self] _ -> AnyPublisher<FineStatusModel?, Never> in
                guard let self, let sdSchulCode = Preferences.userInfo?.school.sdSchulCode, let schoolCode = Int(sdSchulCode) else { return Empty().eraseToAnyPublisher() }

                return self.getExternalFineStatus(schoolCode: schoolCode)
            }
            .sink { [weak self] fineStatusModel in
//                
//                if let fineState = fineStatusModel?.status {
//                    self?.state = .externalFineUpdate(state: fineState)
//                }
            }
            .store(in: &cancellable)
        
        input
            .fetchInternal
            .flatMap { [weak self] _ -> AnyPublisher<InternalFineStatusModel?, Never> in
                guard
                    let self,
                    let userInfo = Preferences.userInfo,
                    let schoolCode = Int(userInfo.school.sdSchulCode)
                else { return Empty().eraseToAnyPublisher() }
                
                return self.getInternalFineStatus(schoolCode: schoolCode, grade: userInfo.grade, classNum: userInfo.classNum)
            }
            .sink { [weak self] fineStatusModel in
                guard let fineStatusModel else { return }
                
                self?.state = .internalFineUpdate(state: fineStatusModel.finedustFactor > 60 ? .bad : .good)
            }
            .store(in: &cancellable)
    }
    
    private func getWeather(
        lat: Double = 37.582425,
        lng: Double = 127.582425
    ) -> AnyPublisher<WeatherModel?, Never> {
        state = .loading
        let endPoint = APIEndpoints.getWeaher(with: .init(lat: lat, lng: lng))
        
        return NetworkService
            .shared
            .request(endPoint)
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
    private func getExternalFineStatus(
        schoolCode: Int
    ) -> AnyPublisher<FineStatusModel?, Never> {
        state = .loading
        let endPoint = APIEndpoints.getExternalFineStatus(with: .init(location: schoolCode))
        
        return NetworkService
            .shared
            .request(endPoint)
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
    private func getInternalFineStatus(
        schoolCode: Int, grade: Int, classNum: Int
    ) -> AnyPublisher<InternalFineStatusModel?, Never> {
        state = .loading
        let endPoint = APIEndpoints.getIntertalFineStatus(with: .init(schoolCode: schoolCode, grade: grade, classNum: classNum))
        
        return NetworkService
            .shared
            .request(endPoint)
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}
