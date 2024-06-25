# 🚧 Offroad-iOS

<div/>

**🌟 34th SOPT APPJAM, 팀 '비포장도로' iOS Repository입니다 🌟**

<br/>

## 🙆🏻‍♀️🙅🏻‍♂️ 프로젝트 설명 
- 서비스 명: **Offroad**(오프로드)
- 서비스 소개: 오프라인에서 모험을 즐길 수 있는 게임형 서비스로, 유저들이 일상을 더 즐겁게 보낼 수 있도록 하며 자영업자들에게는 마케팅 효과를 제공하여 오프라인 상권을 부흥시킨다.

<br/>

## 🍎 역할 분담 및 주요 기능
| [김민성](https://github.com/nolanMinsung) | [정지원](https://github.com/codeJiwon) | [조혜린](https://github.com/Johyerin) |
| :--------: | :--------: | :--------: | 
| <img src="https://github.com/NOW-SOPT-APP1-YeogiEottae/YeogiEottae-iOS/assets/95562494/c48109e9-60f9-47ba-8e55-77fd277ea141" width="200px"/> | <img src="https://github.com/NOW-SOPT-APP1-YeogiEottae/YeogiEottae-iOS/assets/95562494/9340af4a-7c5f-4140-8836-2290b185c3a0" width="200px" /> | <img src="https://github.com/Team-Offroad/Offroad-iOS/assets/111677378/92124189-fc1b-45ef-af9d-a0578dd08177" width="200px"/> | 
| 역할 | 역할 | 역할 | 
| 역할 채우기 | 역할 채우기 | 역할 채우기 | 

<br/>

## 🗂️ 사용할 라이브러리
💡 **Snapkit**
- 편리해서
- 코드의 가독성 향상
    
💡 **Moya**
- Api 연결은 전부 Moya로 하기
- 세미나 때 배운 내용이라 팀원 모두가 잘 활용할 수 있음
    
💡 **Kingfisher**
- 이미지를 다운받아서 캐싱하는 데 유용
- 이미지를 관리해야 하는 뷰가 많으므로 편리하게 하기 위해서 사용
    
💡 **kakaoSDK**
- 소셜 로그인 구현을 위해 사용해야 함

<br/>

## 📌 Coding Convention (미정, 이전 템플릿 내용 가져오기만 한 상황)
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
    <br>
    - URL<br>
    - ID<br>
    - API<br>
    - 필요시 여기에 추가<br>
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
- 주석은 설명하려는 코드 윗 줄에 작성(자세한 위치는 추후 논의)
- 코드만 봤을 때 이해하기 힘들 것 같은 경우 주석을 달아봅시다!

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


### Message(추후 변경 가능성 있음)

커밋 메시지 : `[종류/#이슈번호]작업 이름` - 예시 `[Feat/#1] 메인 UI 구현`

Conflict 해결 시 : `[Conflict/ #이슈] Conflict 해결`

PR을 develop에 merge 시 : 기본 머지 메시지

내 브랜치에 develop merge 시 (브랜치 최신화) : `[Merge/#이슈] Pull Develop` - `[Merge/#13] Pull Develop`

<br/>

## 📌 Issue Convention

### Branch

브랜치명 시작은 소문자로 한다.

default branch : `develop`

작업 branch : `커밋타입/이슈번호` - 예시 `feat/#12`

### Issue

이슈 이름 : `[종류] 작업 명` - 예시 `[Feat] Main View UI 구현`

담당자, 라벨 추가 꼭 하기

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
