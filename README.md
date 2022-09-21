## HeyBunny
뉴스앱!

## 설계
- MVVM
<img width="1278" alt="스크린샷 2022-09-21 오후 7 20 33" src="https://user-images.githubusercontent.com/62687919/191480152-499e2ba0-68ad-4c1b-b4a7-dbe6c591d94d.png">

주황화살표는 의존성을 표현합니다.
검정화살표는 추상타입의 소유 관계를 표현합니다.

## 시나리오
1. View에서 ViewModel에 앱이 실행됨을 알림.
2. ViewModel은 이를 확인하고 Usecase에게 View에서 보여줄 정보를 요청.
3. Usecase는 repository에게 데이터를 요청.
4. Repository는 Service에게 데이터를 요청.
5. Service는 서버와 통신하여 response를 가져오고 Repository로 반환.
6. Repository는 이를 또 Usecase에 반환.
7. Usecase에서 반환받은 데이터를 앱에서 사용하기 위한 Entity로 변환.
8. 해당 Entity를 ViewModel에 저장.
9. ViewModel의 상태변화를 감지하고 View가 업데이트 됨.

## 테스트
이미지를 가져오는 과정 외 모든 로직을 테스트완료.
이미지는 디스크, 메모리 캐시됨.
