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

## 📌 Project Design
[🚧 비포장도로 아요의 프로젝트 설계 ⚒️](https://www.figma.com/board/aWwBlShO7oJEij835d9Vnx/%EC%98%A4%ED%91%B8-%EC%95%84%EC%9A%94-2%EC%B0%A8-%EA%B3%BC%EC%A0%9C-%EC%8A%A4%EA%BB%84..?node-id=0-1&t=Xgutg0NonZYH9TgK-1)

<br/>

## 📌 Coding Convention
[🚧 비포장도로 아요의 코딩컨벤션 🧑🏻‍🏫](https://tan-antlion-a47.notion.site/Coding-Convention-020f744cfa9648f78e25d00e3c5aa90f?pvs=4)

<br/>

## 📌 Git Flow
[🚧 비포장도로 아요의 깃 플로우 전략 😎](https://tan-antlion-a47.notion.site/Git-Flow-042edd696aa54793ba218b1bc0d5dfaf?pvs=4)

<br/>

## 📌 Foldering Convention
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
