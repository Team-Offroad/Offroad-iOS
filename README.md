![banner](https://github.com/user-attachments/assets/0ef4c08b-f43d-4c5d-927c-a3bfb398941d)


![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)
![Swift](https://img.shields.io/badge/swift-F54A2A?style=for-the-badge&logo=swift&logoColor=white)
![Xcode](https://img.shields.io/badge/Xcode-007ACC?style=for-the-badge&logo=Xcode&logoColor=white)

# 🪧 ORB-iOS

<div/>

**🌟 34th NOW SOPT APPJAM, 팀 '오브' iOS Repository입니다 🌟**

<br/>

## 🙆🏻‍♀️🙅🏻‍♂️ 프로젝트 설명 
- 서비스 명: **ORB**(오브)
- 서비스 한줄 소개: 초개인화 맞춤 AI 친구 서비스

<br/>

## 🍎 역할 분담 및 주요 기능
| [김민성](https://github.com/nolanMinsung) | [정지원](https://github.com/codeJiwon) | [조혜린](https://github.com/Johyerin) |
| :--------: | :--------: | :--------: | 
| <img src="https://github.com/user-attachments/assets/23df8b97-9a85-48c4-936f-d9d21f5523ff" width="250px"/> | <img src="https://github.com/user-attachments/assets/a7b3963c-2b27-4592-bcdc-e2c0b01a388b" width="250px" /> | <img src="https://github.com/user-attachments/assets/59567720-4f80-4cd3-b8ec-cadaf3569eff" width="250px"/> | 
| <p align = "center">`지도`<br/>`장소/퀘스트 목록 뷰`<br/>`QR`<br/>`공용 컴포넌트(탭바 등)`<br/>`개발환경 세팅` | <p align = "center">`프로필 생성 뷰`<br/>`마이 페이지`<br/>`캐릭터 조회` | <p align = "center">`스플래시/로그인 뷰`<br/>`홈뷰`<br/>`캐릭터 선택`<br/>`획득 칭호` | 

<br/>

## 🗂️ Libraries
| Library | 사용 목적 |
| :-----: | :-----: |
| <img src="https://img.shields.io/badge/3.0.0-green?label=Then"> | 클로저를 통해 깔끔하고 직관적으로 인스턴스 생성 가능 |
| <img src="https://img.shields.io/badge/15.0.3-pink?label=Moya"> | 네트워크 통신을 위해 사용 |
| <img src="https://img.shields.io/badge/5.7.1-orange?label=SnapKit"> | UI AutoLayout을 위해 사용 |
| <img src="https://img.shields.io/badge/3.0.0-blue?label=SVGKit"> | svg 파일의 이미지 데이터 처리를 위해 사용 |
| <img src="https://img.shields.io/badge/7.12.0-blue?label=Kingfisher"> | 이미지 데이터 처리를 위해 사용 |
| <img src="https://img.shields.io/badge/2.22.3-yellow?label=KakaoOpenSDK"> | 카카오 소셜 로그인을 위해 사용 |


<br/>

## 🍎앱스토어 출시
[앱스토어 링크](https://apps.apple.com/kr/app/%EC%98%A4%EB%B8%8C-%EB%82%98%EB%A7%8C%EC%9D%98-ai-%EC%B9%9C%EA%B5%AC%EC%99%80-%EB%96%A0%EB%82%98%EB%8A%94-%EC%9D%BC%EC%83%81-%ED%83%90%ED%97%98/id6541756824)

## 📲 동작 화면
| 캐릭터 채팅 - 홈 화면 | 캐릭터 채팅 - 채팅 화면 | 탐험 | 쿠폰 사용 |
| :---: | :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/4b261ccb-e3bd-45d3-9c3b-38174f0979d6" width=200> |  <img src="https://github.com/user-attachments/assets/223e5ef1-2833-4dc7-ad5c-beff891219c4" width=200> |  |  |



## 📌 Project Design
[🚧 오브 아요의 프로젝트 설계 ⚒️](https://www.figma.com/board/aWwBlShO7oJEij835d9Vnx/%EC%98%A4%ED%91%B8-%EC%95%84%EC%9A%94-2%EC%B0%A8-%EA%B3%BC%EC%A0%9C-%EC%8A%A4%EA%BB%84..?node-id=0-1&t=Xgutg0NonZYH9TgK-1)

<br/>

## 📌 Coding Convention
[🚧 오브 아요의 코딩컨벤션 🧑🏻‍🏫](https://tan-antlion-a47.notion.site/Coding-Convention-020f744cfa9648f78e25d00e3c5aa90f?pvs=4)

<br/>

## 📌 Git Flow
[🚧 오브 아요의 깃 플로우 전략 😎](https://tan-antlion-a47.notion.site/Git-Flow-042edd696aa54793ba218b1bc0d5dfaf?pvs=4)

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
│   ├── Nickname
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
