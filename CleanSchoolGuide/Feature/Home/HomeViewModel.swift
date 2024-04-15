//
//  HomeViewModel.swift
//  FineDustLab
//
//  Created by 박성민 on 3/31/24.
//

import Foundation
import Combine

final class HomeViewModel: NSObject {
    struct Input {
        let fetchWeather: AnyPublisher<(lat: Double?, lng: Double?), Never>
        let fetchFineDust: AnyPublisher<Void, Never>
    }
    
    enum State {
        case wetherUpdated(humidity: String, temperature: String, date: String)
        case fineDustUpdated
        case none
    }
    
    @Published var state: State = .none
    var isChecked: Bool = false
    
    var dataSource: [CardCollectionViewCell.CardUIModel] {
        let dates = Date.getWeekdaysAndNextMonday()
        var models: [CardCollectionViewCell.CardUIModel] = []
        let surveyedDates = Preferences.surveyCompletedDates
        
        dates.forEach { date in
            models.append(
                .init(
                    date: date,
                    isSuveyed: surveyedDates.first {
                        $0.isSameDay(from: date)
                    } != nil,
                    isHoliday: false)
            )
        }
        
        return models
    }
    
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
    }
    
    private func getWeather(
        lat: Double = 37.582425,
        lng: Double = 127.582425
    ) -> AnyPublisher<WeatherModel?, Never> {
        let endPoint = APIEndpoints.getWeaher(with: .init(lat: lat, lng: lng))
        
        return NetworkService
            .shared
            .request(endPoint)
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
}
