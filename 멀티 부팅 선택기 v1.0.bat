@echo off
setlocal enableextensions enabledelayedexpansion

:level1
cls
echo ******************************************************************************************
echo *                                 EFI기반 임시부팅설정기                       by. k_mjg *
echo ******************************************************************************************
echo.
bcdedit > nul || (echo 관리자 권한으로 실행하세요. & echo. & pause & exit)
echo * 1. fwbootmgr의 bootmgr 부트시퀀스 설정	(타 bootmgr사용)
echo * 2. bootmgr의 OS 부트시퀀스 설정		(bootmgr내 타 OS사용)
echo * 3. 종료
echo.
set a=none
set /p a=* 원하는 작업을 선택하세요 : 

:level2
if %a%==1 (
goto fwbootmgr
) else if %a%==2 (
goto bcdedit
) else if %a%==3 (
exit
) else (
goto level1
)

:fwbootmgr
cls
echo ******************************************************************************************
echo *                                 EFI기반 임시부팅설정기                       by. k_mjg *
echo ******************************************************************************************
echo *                           fwbootmgr의 bootmgr 부트시퀀스 설정                          *
echo ******************************************************************************************
echo.
echo * 아래는 부팅가능한 bootmgr의 목록입니다. displayorder의 항목중 하나를 선택하세요.
bcdedit /enum {fwbootmgr}
echo.
echo * 부팅할 bootmgr의 GUID를 복사하여 붙여넣으세요.
echo * 예) {bootmgr} 혹은 {12345678-1234-1234-1234-123456789012}, 괄호까지 입력
set GUID=none
set /p GUID=* (Enter=뒤로가기) : 
if "%GUID%"=="none" goto level1
bcdedit /enum %GUID%
echo.
:confirmguid1
set confirm=none
set /p confirm=* 입력하신 GUID는 %GUID%입니다. 확실합니까? (y/n): 
if /i %confirm%==y (
bcdedit /set {fwbootmgr} bootsequence %GUID%
echo.
goto continue
) else if /i %confirm%==n (
goto fwbootmgr
) else (
goto confirmguid1
)

:bcdedit
cls
echo ******************************************************************************************
echo *                                 EFI기반 임시부팅설정기                       by. k_mjg *
echo ******************************************************************************************
echo *                              bootmgr의 OS 부트시퀀스 설정                              *
echo ******************************************************************************************
echo.
echo * 1. 현재 부팅된 bootmgr의 OS 부트시퀀스 설정
echo * 2. 다른 bootmgr의 OS 부트시퀀스 설정
echo.
set b=none
set /p b=* 원하는 작업을 선택하세요(Enter=뒤로가기) : 
if %b%==1 (
goto OSSelector1
) else if %b%==2 (
goto bcdeditstore
) else if "%b%"=="none" (
goto level1
) else (
goto level2
)

:bcdeditstore
cls
echo ******************************************************************************************
echo *                                 EFI기반 임시부팅설정기                       by. k_mjg *
echo ******************************************************************************************
echo *                              bootmgr의 OS 부트시퀀스 설정                              *
echo ******************************************************************************************
echo *                            다른 bootmgr의 OS 부트시퀀스 설정                           *
echo ******************************************************************************************
echo.
echo * 시작전 BCD파일이 저장되어있는 드라이브가 연결, 문자할당이 되어있는지 확인하세요.
echo * 디스크 관리자[GUI]로는 BCD파일이 저장된 볼륨을 문자할당을 할 수 없습니다.
echo.
echo * BCD파일이 저장된 경로를 입력하세요. (Diskpart를 입력하면 Diskpart를 실행합니다.)
set path=none
set /p path=* (Enter=뒤로가기) : 
echo.
if "%path%"=="none" goto level2
if /i "%path%"=="diskpart" (
echo * %path%를 입력하셨습니다.
echo.
echo ******************************************************************************************
echo *                                           tip                                          *
echo ******************************************************************************************
echo *                                                                                        *
echo * Diskpart에서 lis vol 명령으로 부트영역 볼륨을 확인후                                   *
echo * sel vol 명령으로 해당 볼륨 선택, ass letter * 명령으로 문자를 할당하세요.              *
echo *                                                                                        *
echo * 모든 작업 완료후 diskpart에서 remove 명령으로 문자할당을 제거하세요.                   *
echo *                                                                                        *
echo ******************************************************************************************
start diskpart.exe
echo.
pause
goto bcdeditstore
)
:confirmpath
set confirmpath=none
set /p confirmpath=* 입력된 경로는 %path%입니다. 확실합니까? (y/n): 
if /i %confirmpath%==y (
goto OSSelector2
) else if /i %confirmpath%==n (
goto bcdeditstore
) else (
goto confirmpath
)

:OSSelector1
cls
echo ******************************************************************************************
echo *                                 EFI기반 임시부팅설정기                       by. k_mjg *
echo ******************************************************************************************
echo *                              bootmgr의 OS 부트시퀀스 설정                              *
echo ******************************************************************************************
echo *                        현재 부팅된 bootmgr의 OS 부트시퀀스 설정                        *
echo ******************************************************************************************
echo.
echo * 아래는 bootmgr와 OS목록입니다. Windows 부팅 로더의 identifier항목중 하나를 선택하세요.
bcdedit
echo.
echo * 부팅할 OS의 GUID를 복사하여 붙여넣으세요.
echo * 예 : {default}, {current} 혹은 {12345678-1234-1234-1234-123456789012}, 괄호까지 입력
set GUID=none
set /p GUID=* (Enter=뒤로가기) : 
if "%GUID%"=="none" goto level2
bcdedit /enum %GUID%
echo.
:confirmguid2
set confirm=none
set /p confirm=* 입력하신 GUID는 %GUID%입니다. 확실합니까? (y/n): 
if /i %confirm%==y (
bcdedit /set {bootmgr} bootsequence %GUID%
echo.
goto continue
) else if /i %confirm%==n (
goto OSSelector1
) else (
goto confirmguid2
)

:OSSelector2
cls
echo ******************************************************************************************
echo *                                 EFI기반 임시부팅설정기                       by. k_mjg *
echo ******************************************************************************************
echo *                              bootmgr의 OS 부트시퀀스 설정                              *
echo ******************************************************************************************
echo *                            다른 bootmgr의 OS 부트시퀀스 설정                           *
echo ******************************************************************************************
echo.
echo * 아래는 bootmgr와 OS목록입니다. Windows 부팅 로더의 identifier항목중 하나를 선택하세요.
bcdedit /store %path%
echo.
echo * 부팅할 OS의 GUID를 복사하여 붙여넣으세요.
echo * 예 : {default}, {current} 혹은 {12345678-1234-1234-1234-123456789012}, 괄호까지 입력
set GUID=none
set /p GUID=* (Enter=뒤로가기) : 
if "%GUID%"=="none" goto bcdeditstore
bcdedit /store %path% /enum %GUID%
echo.
:confirmguid3
set confirm=none
set /p confirm=* 입력하신 GUID는 %GUID%입니다. 확실합니까? (y/n): 
if /i %confirm%==y (
bcdedit /store %path% /set {bootmgr} bootsequence %GUID%
echo.
goto continue
) else if /i %confirm%==n (
goto OSSelector2
) else (
goto confirmguid3
)

:continue
set continue=n
set /p continue=* 작업을 다시 진행하시겠습니까? (y/n): 
if /i %continue%==y goto level1

endlocal