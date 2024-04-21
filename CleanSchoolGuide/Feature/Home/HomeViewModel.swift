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
        let postFineDust: AnyPublisher<(Int, Int), Never>
        let postUltraFineDust: AnyPublisher<(Int, Int), Never>
    }
    
    enum State {
        case wetherUpdated(humidity: String, temperature: String, date: String)
        case externalFineUpdate(state: FineStatusModel.Status)
        case internalFineUpdate(state: InternalFineStatusModel.Status)
        case fineDustPosted
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
        
        input
            .fetchFineDust
            .flatMap { [weak self] _ -> AnyPublisher<FineStatusModel?, Never> in
                guard let self else { return Empty().eraseToAnyPublisher() }
                var schoolCode: Int?
                if let sdSchulCode = Preferences.userInfo?.school.sdSchulCode {
                    schoolCode = Int(sdSchulCode)
                }
                return self.getExternalFineStatus(schoolCode: schoolCode)
            }
            .sink { [weak self] fineStatusModel in
                
                if let fineState = fineStatusModel?.status {
                    self?.state = .externalFineUpdate(state: fineState)
                }
            }
            .store(in: &cancellable)
        
        input
            .fetchFineDust
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
        
        input.postFineDust
            .sink { [weak self] value, selectedIndex in
                Preferences.fineData = .init(value: value, selectedIndex: selectedIndex, time: Date())
                self?.postFineDust()
            }
            .store(in: &cancellable)
        
        input.postUltraFineDust
            .sink { [weak self] value, selectedIndex in
                Preferences.ultraFineData = .init(value: value, selectedIndex: selectedIndex, time: Date())
                self?.postFineDust()
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
    
    private func getExternalFineStatus(
        schoolCode: Int?
    ) -> AnyPublisher<FineStatusModel?, Never> {
        
        let endPoint = APIEndpoints.getExternalFineStatus(with: .init(location: schoolCode ?? 7201099))
        
        return NetworkService
            .shared
            .request(endPoint)
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
    private func getInternalFineStatus(
        schoolCode: Int, grade: Int, classNum: Int
    ) -> AnyPublisher<InternalFineStatusModel?, Never> {
        
        let endPoint = APIEndpoints.getIntertalFineStatus(with: .init(schoolCode: schoolCode, grade: grade, classNum: classNum))
        
        return NetworkService
            .shared
            .request(endPoint)
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
    private func postFineDust() {
        if !(Preferences.fineData?.time.isToday ?? false) {
            Preferences.fineData = nil
        }
        if !(Preferences.ultraFineData?.time.isToday ?? false) {
            Preferences.ultraFineData = nil
        }
        
        guard let fineData = Preferences.fineData, let ultraFineData = Preferences.ultraFineData, let userData = Preferences.userInfo else { return }
    
        let endPoint = APIEndpoints
            .postClassroomFineData(
                with: .init(
                    classroom: .init(finedustFactor: fineData.value, ultrafineFactor: ultraFineData.value),
                    userProfile: .init(
                        schoolCode: userData.school.sdSchulCode,
                        grade: userData.grade,
                        classNum: userData.classNum,
                        studentNum: userData.studentNum ?? 0,
                        name: userData.name,
                        userType: .teacher)
                )
            )
        NetworkService
            .shared
            .request(endPoint)
            .replaceError(with: nil)
            .sink { [weak self] _ in
                self?.state = .fineDustPosted
            }
            .store(in: &cancellable)
    }
}
