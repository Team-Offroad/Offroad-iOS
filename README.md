![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)
![Swift](https://img.shields.io/badge/swift-F54A2A?style=for-the-badge&logo=swift&logoColor=white)
![Xcode](https://img.shields.io/badge/Xcode-007ACC?style=for-the-badge&logo=Xcode&logoColor=white)

# 🚧 Offroad-iOS

<div/>

**🌟 34th NOW SOPT APPJAM, 팀 '비포장도로' iOS Repository입니다 🌟**

<br/>

## 🙆🏻‍♀️🙅🏻‍♂️ 프로젝트 설명 
- 서비스 명: **Offroad**(오프로드)
- 서비스 소개: 오프라인에서 모험을 즐길 수 있는 게임형 서비스로, 유저들이 일상을 더 즐겁게 보낼 수 있도록 하며 자영업자들에게는 마케팅 효과를 제공하여 오프라인 상권을 부흥시킨다.

<br/>

## 🍎 역할 분담 및 주요 기능
| [김민성](https://github.com/nolanMinsung) | [정지원](https://github.com/codeJiwon) | [조혜린](https://github.com/Johyerin) |
| :--------: | :--------: | :--------: | 
| <img src="https://github.com/NOW-SOPT-APP1-YeogiEottae/YeogiEottae-iOS/assets/95562494/c48109e9-60f9-47ba-8e55-77fd277ea141" width="200px"/> | <img src="https://github.com/NOW-SOPT-APP1-YeogiEottae/YeogiEottae-iOS/assets/95562494/9340af4a-7c5f-4140-8836-2290b185c3a0" width="200px" /> | <img src="https://github.com/Team-Offroad/Offroad-iOS/assets/111677378/92124189-fc1b-45ef-af9d-a0578dd08177" width="200px"/> | 
| <p align = "center">`지도`<br/>`QR`<br/>`퀘스트 목록`<br/>`장소 목록` | <p align = "center">`프로필 생성 뷰`<br/>`마이 페이지`<br/>`획득 캐릭터`<br/>`획득 쿠폰` | <p align = "center">`스플래시/로그인 뷰`<br/>`홈뷰`<br/>`탭바`<br/>`획득 칭호`<br/>`설정` | 

<br/>

## 🗂️ Libraries
| Library | 사용 목적 |
| :-----: | :-----: |
| <img src="https://img.shields.io/badge/2.22.3-yellow?label=KakaoOpenSDK"> | 카카오 소셜 로그인을 위해 사용 |
| <img src="https://img.shields.io/badge/7.12.0-blue?label=Kingfisher"> | 이미지 데이터 처리를 위해 사용 |
| <img src="https://img.shields.io/badge/15.0.3-pink?label=Moya"> | 네트워크 통신을 위해 사용 |
| <img src="https://img.shields.io/badge/5.7.1-orange?label=SnapKit"> | UI AutoLayout을 위해 사용 |
| <img src="https://img.shields.io/badge/3.0.0-green?label=Then"> | 클로저를 통해 깔끔하고 직관적으로 인스턴스 생성 가능 |


<br/>

## 📌 Coding Convention
### 1️⃣ **타입 이름**

**UpperCamelCase**를 사용합니다.

- `ViewController`, `TableViewCell`, `CollectionViewCell` 줄이지 않고 사용
- 타입 이름(클래스, 프로토콜, 구조체, enum)만 Upper CamelCase
→ 그 외에는 모두 Lower CamelCase
- 기타 UpperCamelCase가 필요하다고 생각되는 경우는 팀원들과 논의

### 2️⃣ **Protocol 사용 시**

`extension`으로 모두 빼기 : 하나의 extension에 프로토콜 하나씩

- 프로토콜에서 정의하는 메서드는 확장(Extension)을 통해 구현

### 3️⃣ **변수 및 상수 이름**

- 알아볼 수 있는 네이밍을 사용해주세요!
- **lowerCamelCase**를 사용합니다.
- 약어인 경우 CamelCase라고 하더라도 모두 대문자로 씀
  <details>
    <summary>대문자로만 쓰는 용어 모음</summary>
    <div>
       - URL<br>
       - ID<br>
       - API<br>
       - QR<br>
       <!-- 필요시 여기에 추가 -->
    </div>
    </details>
- myContentCollectionViewCell (O)
    
    myContentCVCell (x)
    

### **4️⃣ 줄바꿈**

- 줄바꿈 **(Ctrl+M)** → 함수 매개변수 너무 많을 때(3개 이상)는 각 매개변수당 줄바꿈
- 함수와 함수 사이에 한 줄 공백
- 타입을 정의할 때나, 확장(Extension) 시에는 스코프 맨 위, 아래 한 줄씩 띄우기
- 상위 클래스의 메서드를 재정의(override)하는 경우에는, super 메서드를 호출하고, 한 줄을 띄어 쓴다.

### **5️⃣ 주석**

- 주석은 설명하려는 코드 윗 줄에 작성
- 한 줄에 끝나는 짧은 주석은 코드 오른쪽 끝에 작성
- 퀵헬프 주석 지향
- 코드만 봤을 때 이해하기 힘들 것 같은 경우 주석을 달아봅시다!
- 코드 레이아웃 및 마크다운 주석
    
    ```swift
    class ViewController: UIViewController {
        // MARK: - Properties
        // MARK: - UI Properties
        // MARK: - Life Cycle
    
    }
    extension ViewController {
        // MARK: - Layout
        // MARK: - @objc
        // MARK: - Private Func
        // MARK: - Func
    }
    
    // MARK: - UITableView Delegate
    // MARK: - 이외의 Delegate나 .. 그런거
    .
    .
    .
    ```
    
    - 마크다운 주석 위 아래 한 줄씩 줄바꿈 추가
    - Life Cycle은  init, Life Cycle, deinit 순서대로 적음
    - Layout 관련 함수는 다음과 같은 구조로 작성하는 것을 지향
        
        ```swift
        extension View: UIView {

            // MARK: - Layout

            private func setupStyle() {
                //backgroundColor 지정하는 코드
                //(UI property).do 를 통한 인스턴스 초기화 클로저(Then 라이브러리 사용 시) 등
                // +@
            }
            
            private func setupHierarchy() {
                //Hierarchy 잡는 코드
                //addSubview, addSubviews 등
                // +@
            }
            
            private func setupLayout() {
                //각 프로퍼티의 레이아웃 관련 코드
                //(UI property).snp.makeConstraints를 통해 오토 레이아웃을 잡는 코드
                // +@
            }
        }
        ```
        

### **6️⃣ Import**

모듈 임포트는 **알파벳 순으로 정렬**합니다. 

내장 프레임워크(예시: UIKit)를 먼저 임포트하고, 개행한 뒤 서드파티 프레임워크를 임포트합니다.

```swift
import UIKit

import SwiftyColor
import SwiftyImage
import Then
import URLNavigator
```

### **▶️ 기타사항**

- `self` , `강제 언래핑` 최대한 사용을 지양
- 약어 지양.. `VC`, `Config` 등등 금지! → `ViewController`, `Configuration` 와 같이 풀어서
- `viewDidLoad()`,`init()`에서는 되도록 함수 호출만
- delegate 지정, UI 관련 설정 등등 모두 함수와 역할에 따라서 extension 으로 빼기
    
    ⇒ 최대한 ViewController는 가볍게
    
- 필요없는 주석 및 Mark 구문들 제거

<br/>

## 📌 Issue Convention

이슈 제목 : `[종류] 작업 명` - 예시) `[Feat] Main View UI 구현`

- 작업 내용이 많다면 To-do 권장
- **Assignee, Labels** 꼭 추가하기!
- **Issue의 단위**는 다음을 참고하되, 코드 양에 따라 유동적으로 설정하기!
    1. 뷰의 UI를 만들고, 배치할 때
    2. 뷰의 UI 컴포넌트 데이터 연결할 때 (컬렉션 뷰 DataSource 연결 등)
    3. API 연결할 때 - 기능 별로 나누기
    예) 퀘스트 목록과 관련한 API, 장소와 관련한 API
- 이슈 하나당 브랜치 하나를 생성한다.

<br/>

## 📌 Branch Convention

브랜치 이름 : `커밋타입/#이슈번호` - 예시) `feat/#3`

- 브랜치 이름은 소문자로 한다.
- default branch : `develop`

<br/>

## 📌 Commit Convention
- [Feat] : 새로운 기능 구현
- [Fix] : 버그, 오류 해결
- [Chore] : 코드 수정, 내부 파일 수정, 애매한 것들이나 잡일은 이걸로!
- [Add] : 라이브러리 추가, 에셋 추가
- [Del] : 쓸모없는 코드 삭제
- [Docs] : README나 WIKI 등의 문서 개정
- [Refactor] : 전면 수정이 있을 때 사용합니다
- [Setting] : 프로젝트 설정관련이 있을 때 사용합니다.
- [Merge] - {#이슈번호} Pull Develop


### Message

커밋 메시지 : `[종류/#이슈번호]작업 이름` - 예시 `[Feat/#1] 메인 UI 구현`

Conflict 해결 시 : `[Conflict/#이슈] Conflict 해결`

PR을 develop에 merge 시 : `[Merge/#이슈] 작업 내용 간략히`

내 브랜치에 develop merge 시 (브랜치 최신화) : `[Merge/#이슈] Pull Develop` - `[Merge/#13] Pull Develop`

<br/>

## 📌 PR Convention

PR 제목 : `[브랜치 역할] #이슈 번호 - 이슈 제목과 동일` - 예시) `[Feat] #3 - HomeView UI 구현`

- PR Point, 스크린샷은 없다면 빼도 됨
- 최대한 상세히 작성하기!
- 스크린샷은 gif 형식으로 올리기

### 코드 리뷰
1. 코드에 **수정 사항 반영을 요청**할 때 아래와 같은 **태그**로 구분하여 **중요도**를 나눕니다
    - **P1: 꼭 반영해주세요 (Request changes)**
        
         리뷰어는 PR의 내용이 서비스에 중대한 오류를 발생할 수 있는 가능성을 잠재하고 있는 등 중대한 코드 수정이 반드시 필요하다고 판단되는 경우, P1 태그를 통해 리뷰 요청자에게 수정을 요청합니다. 리뷰 요청자는 P1 태그에 대해 리뷰어의 요청을 반영하거나, 반영할 수 없는 합리적인 의견을 통해 리뷰어를 설득할 수 있어야 합니다.
        
    - **P2: 적극적으로 고려해주세요 (Request changes)**
        
         작성자는 P2에 대해 수용하거나 만약 수용할 수 없는 상황이라면 적합한 의견을 들어 토론할 것을 권장합니다.
        
    - **P3: 웬만하면 반영해 주세요(Comment)**
        
         작성자는 P3에 대해 수용하거나 만약 수용할 수 없는 상황이라면 반영할 수 없는 이유를 들어 설명하거나 다음에 반영할 계획을 명시적으로(JIRA 티켓 등으로) 표현할 것을 권장합니다. Request changes 가 아닌 Comment 와 함께 사용됩니다.
        
    - **P4: 반영해도 좋고 넘어가도 좋습니다 (Approve)**
        
         작성자는 P4에 대해서는 아무런 의견을 달지 않고 무시해도 괜찮습니다. 해당 의견을 반영하는 게 좋을지 고민해 보는 정도면 충분합니다.
        
    - **P5: 그냥 사소한 의견입니다 (Approve)**
        
         작성자는 P5에 대해 아무런 의견을 달지 않고 무시해도 괜찮습니다.
        
    
    **예시:** `P1 ) 컨벤션에 따라 함수 네이밍을 ~~로 바꿔야 할 것 같아요!`
    
2. 이 외에 코드에 대한 이해를 돕기 위한 추가 설명 요청, 질문, 감탄사 등은 **마구마구 자유롭게** 달기~!

<br/>

## 📂 Foldering Convention
```bash
├── Application
│   ├── Appdelegate
│   ├── SceneDelegate
├── Global
│   ├── Extension
│   ├── Literals
│   │   ├── Literal
│   │   ├── String
│   ├── Protocols
│   ├── Resources
│   │   ├── Font
│   │   ├── Assets
│   │   ├── Info.plist
│   ├── SupportingFiles
│   │   ├── Base
├───├───├───── LaunchScreen
├── Network
│   ├── Base
│   ├── DataModel
│   ├── Service
├── Presentation 
│   ├── Common
│   │   ├── UIComponents 
│   ├── Login
│   │   ├── ViewControllers
│   │   ├── Views
├───├───├── Models
│   ├── Splash
│   │   ├── ViewControllers
│   │   ├── Views
├───├───├── Models
│   ├── NicknameSetting
│   │   ├── ViewControllers
│   │   ├── Views
├───├───├── Models
│   ├── Character
│   │   ├── ChoosingCharacter
│   │   ├── CompleteChoosingCharacter
│   ├── Home
│   │   ├── ViewControllers
│   │   ├── Views
├───├───├── Models
│   ├── QuestMap
│   │   ├── ViewControllers
│   │   ├── Views
├───├───├── Models
│   ├── QuestQR
│   │   ├── ViewControllers
│   │   ├── Views
├───├───├── Models
│   ├── QuestList
│   │   ├── ViewControllers
│   │   ├── Views
├───├───├── Models
│   ├── PlaceList
│   │   ├── ViewControllers
│   │   ├── Views
├───├───├── Models
│   ├── Mypage
│   │   ├── Character
│   │   ├── Coupon
│   │   ├── Title
├───├───├── Settings
``` 
