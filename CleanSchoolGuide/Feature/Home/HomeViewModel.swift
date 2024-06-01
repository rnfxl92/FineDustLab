//
//  HomeViewModel.swift
//  FineDustLab
//
//  Created by 박성민 on 3/31/24.
//

import Foundation
import Combine
import PDFKit

final class HomeViewModel: NSObject {
    struct Input {
        let postFineDust: AnyPublisher<(Int, Int), Never>
        let postUltraFineDust: AnyPublisher<(Int, Int), Never>
    }
    
    enum State {
        case fineDustPosted
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
    
    var dataSource: [CardCollectionViewCell.CardUIModel] {
        let dates = Date.get3days()
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
    
    func checkSurvey() -> Bool {
        if Preferences.surveyData != nil, let tempSurvey = Preferences.surveyTemp, tempSurvey.date.isToday {
           return true
        }
        
        Preferences.surveyTemp = nil
        return false
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
    
    private func postFineDust() {
        if !(Preferences.fineData?.time.isToday ?? false) {
            Preferences.fineData = nil
        }
        if !(Preferences.ultraFineData?.time.isToday ?? false) {
            Preferences.ultraFineData = nil
        }
        
        guard let fineData = Preferences.fineData, let ultraFineData = Preferences.ultraFineData, let userData = Preferences.userInfo else { return }
        state = .loading
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
    
    func checkPdf(_ searchWord: String) -> Bool {
        let fileName: String = Preferences.selectedUserType?.rawValue ?? ""
        
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "pdf"),  let document = PDFDocument(url: fileURL) else { return false }
            
        let searchSelections = document.findString(searchWord, withOptions: .caseInsensitive)
        
        return searchSelections.isNotEmpty
    }
}
