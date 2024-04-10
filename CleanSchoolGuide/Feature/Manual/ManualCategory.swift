//
//  ManualCategory.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/11/24.
//

import Foundation

enum ManualCategory {
    enum Elementary: Int, CaseIterable {
        case chapter1_1
        case chapter1_2
        case chapter2_1
        case chapter2_2
        
        var title: String {
            switch self {
            case .chapter1_1:
                return "미세먼지란?"
            case .chapter1_2:
                return "학교 미세먼지 문제 이해하기"
            case .chapter2_1:
                return "학교 미세먼지 관리방법"
            case .chapter2_2:
                return "부록"
            }
        }
        
        var subChapters: [SubChapter] {
            switch self {
            case .chapter1_1:
                return [.one1, .one2, .one3, .one4]
            case .chapter1_2:
                return [.two1, .two2]
            case .chapter2_1:
                return [.three1, .three2]
            case .chapter2_2:
                return [.four1]
            }
        }
        
        enum SubChapter: Int, CaseIterable {
            case one1
            case one2
            case one3
            case one4
            case two1
            case two2
            case three1
            case three2
            case four1
            
            var title: String {
                switch self {
                case .one1:
                    return "미세먼지가 뭐지?"
                case .one2:
                    return "미세먼지는 왜 생기는 걸까?"
                case .one3:
                    return "우리나라 미세먼지 농도는 어느 정도일까?"
                case .one4:
                    return "미세먼지 때문에 건강이 나빠질 수 있다던데?"
                case .two1:
                    return "학생들이 더 위험할 수 있는 이유는 뭘까?"
                case .two2:
                    return "학교 근처에서 미세먼지가 생기는 이유는 뭘까?"
                case .three1:
                    return "미세먼지 예방을 위해 이렇게 행동해요"
                case .three2:
                    return "교실 안에서 미세먼지 줄이는 방법은 뭐가 있을까?"
                case .four1:
                    return "부록"
                }
            }
        }
    }
    
    enum Middle: Int, CaseIterable {
        case chapter1_1
        case chapter1_2
        case chapter2_1
        case chapter2_2
        case chapter2_3
        case chapter2_4
        
        var title: String {
            switch self {
            case .chapter1_1:
                return "미세먼지란?"
            case .chapter1_2:
                return "학교 미세먼지 문제 이해하기"
            case .chapter2_1:
                return "학교 미세먼지 관리방법"
            case .chapter2_2:
                return "관련기관 비상 연락망"
            case .chapter2_3:
                return "참고문헌"
            case .chapter2_4:
                return "부록"
            }
        }
        
        enum SubChapter: Int, CaseIterable {
            case one1
            case one2
            case one3
            case one4
            case one5
            case one6
            case one7
            case two1
            case two2
            case two3
            case two4
            case two5
            case three1
            case three2
            case three3
            case four1
            case four2
            case four3
            case four4
            case four5
            case five1
            case six1
            
            var title: String {
                switch self {
                case .one1:
                    return "미세먼지가 뭐지?"
                case .one2:
                    return "미세먼지는 어떻게 구성되어 있을까?"
                case .one3:
                    return "미세먼지는 왜 생기는 걸까?"
                case .one4:
                    return "우리나라와 외국의 미세먼지 환경기준은?"
                case .one5:
                    return "국내∙외 실내공기질 관리 기준"
                case .one6:
                    return "우리나라 미세먼지 농도는 어느 정도일까?"
                case .one7:
                    return "미세먼지 때문에 건강이 나빠질 수 있다던데?"
                case .two1:
                    return "학교 공간의 특수성"
                case .two2:
                    return "학생의 미세먼지 노출 특성"
                case .two3:
                    return "학교 내∙외부 미세먼지 발생원"
                case .two4:
                    return "학교 미세먼지 농도 현황"
                case .two5:
                    return "학교 입지에 따른 미세먼지 특성"
                case .three1:
                    return "미세먼지에 의한 건강영향 예방을 위한 평상시 건강 수칙"
                case .three2:
                    return "미세먼지 영향을 줄이기 위한 실내 미세먼지 관리 방법"
                case .three3:
                    return "학생의 학교 미세먼지 대응 방법"
                case .four1:
                    return "연락망 안내"
                case .four2:
                    return "중앙행정기관"
                case .four3:
                    return "시∙도교육청"
                case .four4:
                    return "지방자치단체"
                case .four5:
                    return "지역 보건소"
                case .five1:
                    return "참고문헌"
                case .six1:
                    return "부록"
                }
            }
        }
    }
}
