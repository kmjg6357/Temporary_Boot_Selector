# Temporary_Boot_Selector (임시 부팅 선택기)
 EFI기반 멀티부트로더나 멀티BCD 혹은 멀티부팅항목으로 구성된 시스템에서 임시로 원하는 부트로더/BCD로 부팅   
 설정후 재부팅하면 BIOS의 boot menu 수정 혹은 선택 없이 바로 설정한 OS로 부팅 가능
 bcdedit의 bootsequence를 이용한 간단한 원리의 script.

*****

# ScreenShot

![screenshot](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2F1wYAf%2FbtqThZVaryj%2FcgK48eHMghshEICeRjOEA0%2Fimg.png)

*****

# How to use
관리자 권한으로 실행(A) 必   
아래 시스템 예시를 참고하여 입력해야할 숫자와 값만 예시로 들어 표기 (**기울임볼드체**: 기본 부팅값)   
[] - 생략 / {} - 같이 넣어야함 / 입력항목중 띄어쓰기 필요시 ""로 묶을것. ~~(아마 그럴일은 없을거야..)~~   
작업중 표시되는 {GUID}를 드래그 후 <kbd>마우스 우클릭</kbd>하면 값이 복사됨. 이후 다시 <kbd>마우스 우클릭</kbd>해서 붙여넣기하면 편리함.   
작업중 오류 발생시 값입력 없이 혹은 n을 입력후 <kbd>Enter</kbd>를 눌러 이전단계에서 잘못 입력한 값 수정 후 진행할것.
* System example (**Default is italic&bold**)
  - **Disk0** - With serveral OSes (**Windows 10 Pro** / Windows 10 Home / Ubuntu Desktop 20.04)
  - Disk1 - With serveral Windows (Windows 10 Pro VHD / **Windows Server 2019 VHD** / Windows 7 Pro)
  - Disk2 - With single Ubuntu OS (**Ubuntu Server 20.04**)
* Disk0의 Windows 10 Home으로 부팅
  - 2 - 1 - {Windows 10 Home의 GUID} - y
* Disk0의 Ubuntu Desktop 20.04로 부팅
  - 1 - {Disk0에 있는 Ubuntu Desktop 20.04의 GUID} - y
* Disk1의 Windows 10 Pro VHD로 부팅
  - DiskPart로 작업 필요
  - 1 - {Disk1에 있는 Bootmgr의 GUID} - y
  - 2 - 2
    + diskpart 입력 - lis vol - sel vol [Disk1의 bootmgr이 들어있는 볼륨번호] - ass letter X
  - X:\EFI\MicroSoft\Boot\BCD - y - {Windows 10 Pro VHD의 GUID} - y
    + 작업 완료후 DiskPart 작업창으로 돌아가 remove 입력
* Disk1의 Windows Server 2019 VHD로 부팅
  - 1 - {Disk1에 있는 Bootmgr의 GUID} - y
* Disk1의 Windows 7 Pro로 부팅
  - DiskPart로 작업 필요
  - 1 - {Disk1에 있는 Bootmgr의 GUID} - y
  - 2 - 2
    + diskpart 입력 - lis vol - sel vol [Disk1의 bootmgr이 들어있는 볼륨번호] - ass letter X
  - X:\EFI\MicroSoft\Boot\BCD - y - {Windows 7 Pro의 GUID} - y
    + 작업 완료후 DiskPart 작업창으로 돌아가 remove 입력
* Disk2의 Ubuntu Server 20.04로 부팅
  - 1 - {Disk2에 있는 Ubuntu Server 20.04의 GUID} - y
* 임시부팅 해제
  - 현재 부팅된 bootmgr외 bootmgr나 부트로더를 선택한 경우
    + CMD 관리자 권한으로 실행 - bcdedit /deletevalue {fwbootmgr} bootsequence
  - 현재 부팅된 bootmgr내에서 다른 os를 선택한 경우
    + CMD 관리자 권한으로 실행 - bcdedit /deletevalue {bootmgr} bootsequence
  - 타 bootmgr(DiskN)내의 다른 os를 선택한 경우 (DiskN의 bootmgr선택 + DiskN의 bootmgr내 타 OS 선택)   
    + CMD 관리자 권한으로 실행 - diskpart 입력 - lis vol - sel vol [DiskN의 bootmgr이 들어있는 볼륨번호] - ass letter X
    + CMD 관리자 권한으로 실행 - bcdedit /deletevalue {fwbootmgr} bootsequence
    + bcdedit /store X:\EFI\MicroSoft\Boot\BCD /deletevalue {bootmgr} bootsequence
    + 작업 완료후 DiskPart 작업창으로 돌아가 remove 입력

위 예제가 이해 안갈경우 bat을 실행하면 이해못할 설명들이 반겨주니 그걸 읽으며 차근차근 진행하면됨.   
diskpart과정의 경우 설명하기 복잡하고 본인의 파티셔닝 상태에 따라 다르기에 더욱 더 설명할 수 없음. 보통 100MB짜리 파티션이 EFI파티션임.   
잘 선택한건지 확인하는 방법중 하나는 아무 100mb짜리 파티션 선택후 lis dis, lis vol을 하면 선택된 디스크, 파티션에 *표시가 있는것으로 확인하는것임.   
그리고 볼륨레터 지정후 cmd에서 dir X:\EFI\MicroSoft\Boot\BCD를 입력해 BCD파일이 존재하는지 확인하는것.   
그다음은 diskpart과정 다음에 나타나는 OS목록들을 확인해 제대로 선택한건가 확인하는것..   
diskpart에서 remove명령어는 디스크 삭제같은 명령어가 아니라 할당된 drive letter 제거 명령어임.

*****

# Download
https://github.com/kmjg6357/Temporary_Boot_Selector/releases

*****

# Changelog
  * v1.0 - 2019.11.20.
    - First Release

*****

# Additional plan
* 임시부팅 해제 자동화
* DiskPart 작업과정 자동화
* GUID 입력과정 목록선택으로 변경
* Linux용 스크립트 제작 (비슷한 원리를 가진 바이너리가 있다면..)
* ~~위 기능들 bat으로 구현 불가능하다면 코딩하지 뭐.~~