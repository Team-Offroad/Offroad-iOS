//
//  OFRAlertView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/12/24.
//

/// 팝업 뷰의 종류
enum OFRAlertType {
    
    /**
     제목, 설명, 버튼만 갖는 기본적인 형태/  345\*238
     */
    case normal
    
    /**
     텍스트 입력 창이 들어가는 형태
     text field의 위치는 button 바로 상단에 위치하며,
     text field의 위치를 다른 곳에 배치하고 싶을 경우,
     ''custom' case를 선택한 후, 직접 설정
     */
    case textField
    
    /**
     textField가 있으며 메시지 아래에 서브 텍스트가 있는 경우
     */
    case textFieldWithSubMessage
    
    /**
     팝업창 내 스크롤이 필요한 컨텐츠가 들어가는 형태/ 345\*544
     */
    case scrollableContent
    
    /**
     탐험 후 성패를 알려주는 팝업
     (피그마의 '성패 팝업')
     */
    case explorationResult
    
    /**
     홈 화면에서 칭호를 바꿀 시에 뜨는 팝업
     (피그마의 '내가 모은 칭호 팝업')
     */
    case acquiredEmblem
    
    /**
     메시지와 버튼 사이의 뷰를 커스텀 뷰로 채워넣는 경우.
     */
    case custom
    
}
