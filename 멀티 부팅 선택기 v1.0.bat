@echo off
setlocal enableextensions enabledelayedexpansion

:level1
cls
echo ******************************************************************************************
echo *                                 EFI��� �ӽú��ü�����                       by. k_mjg *
echo ******************************************************************************************
echo.
bcdedit > nul || (echo ������ �������� �����ϼ���. & echo. & pause & exit)
echo * 1. fwbootmgr�� bootmgr ��Ʈ������ ����	(Ÿ bootmgr���)
echo * 2. bootmgr�� OS ��Ʈ������ ����		(bootmgr�� Ÿ OS���)
echo * 3. ����
echo.
set a=none
set /p a=* ���ϴ� �۾��� �����ϼ��� : 

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
echo *                                 EFI��� �ӽú��ü�����                       by. k_mjg *
echo ******************************************************************************************
echo *                           fwbootmgr�� bootmgr ��Ʈ������ ����                          *
echo ******************************************************************************************
echo.
echo * �Ʒ��� ���ð����� bootmgr�� ����Դϴ�. displayorder�� �׸��� �ϳ��� �����ϼ���.
bcdedit /enum {fwbootmgr}
echo.
echo * ������ bootmgr�� GUID�� �����Ͽ� �ٿ���������.
echo * ��) {bootmgr} Ȥ�� {12345678-1234-1234-1234-123456789012}, ��ȣ���� �Է�
set GUID=none
set /p GUID=* (Enter=�ڷΰ���) : 
if "%GUID%"=="none" goto level1
bcdedit /enum %GUID%
echo.
:confirmguid1
set confirm=none
set /p confirm=* �Է��Ͻ� GUID�� %GUID%�Դϴ�. Ȯ���մϱ�? (y/n): 
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
echo *                                 EFI��� �ӽú��ü�����                       by. k_mjg *
echo ******************************************************************************************
echo *                              bootmgr�� OS ��Ʈ������ ����                              *
echo ******************************************************************************************
echo.
echo * 1. ���� ���õ� bootmgr�� OS ��Ʈ������ ����
echo * 2. �ٸ� bootmgr�� OS ��Ʈ������ ����
echo.
set b=none
set /p b=* ���ϴ� �۾��� �����ϼ���(Enter=�ڷΰ���) : 
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
echo *                                 EFI��� �ӽú��ü�����                       by. k_mjg *
echo ******************************************************************************************
echo *                              bootmgr�� OS ��Ʈ������ ����                              *
echo ******************************************************************************************
echo *                            �ٸ� bootmgr�� OS ��Ʈ������ ����                           *
echo ******************************************************************************************
echo.
echo * ������ BCD������ ����Ǿ��ִ� ����̺갡 ����, �����Ҵ��� �Ǿ��ִ��� Ȯ���ϼ���.
echo * ��ũ ������[GUI]�δ� BCD������ ����� ������ �����Ҵ��� �� �� �����ϴ�.
echo.
echo * BCD������ ����� ��θ� �Է��ϼ���. (Diskpart�� �Է��ϸ� Diskpart�� �����մϴ�.)
set path=none
set /p path=* (Enter=�ڷΰ���) : 
echo.
if "%path%"=="none" goto level2
if /i "%path%"=="diskpart" (
echo * %path%�� �Է��ϼ̽��ϴ�.
echo.
echo ******************************************************************************************
echo *                                           tip                                          *
echo ******************************************************************************************
echo *                                                                                        *
echo * Diskpart���� lis vol ������� ��Ʈ���� ������ Ȯ����                                   *
echo * sel vol ������� �ش� ���� ����, ass letter * ������� ���ڸ� �Ҵ��ϼ���.              *
echo *                                                                                        *
echo * ��� �۾� �Ϸ��� diskpart���� remove ������� �����Ҵ��� �����ϼ���.                   *
echo *                                                                                        *
echo ******************************************************************************************
start diskpart.exe
echo.
pause
goto bcdeditstore
)
:confirmpath
set confirmpath=none
set /p confirmpath=* �Էµ� ��δ� %path%�Դϴ�. Ȯ���մϱ�? (y/n): 
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
echo *                                 EFI��� �ӽú��ü�����                       by. k_mjg *
echo ******************************************************************************************
echo *                              bootmgr�� OS ��Ʈ������ ����                              *
echo ******************************************************************************************
echo *                        ���� ���õ� bootmgr�� OS ��Ʈ������ ����                        *
echo ******************************************************************************************
echo.
echo * �Ʒ��� bootmgr�� OS����Դϴ�. Windows ���� �δ��� identifier�׸��� �ϳ��� �����ϼ���.
bcdedit
echo.
echo * ������ OS�� GUID�� �����Ͽ� �ٿ���������.
echo * �� : {default}, {current} Ȥ�� {12345678-1234-1234-1234-123456789012}, ��ȣ���� �Է�
set GUID=none
set /p GUID=* (Enter=�ڷΰ���) : 
if "%GUID%"=="none" goto level2
bcdedit /enum %GUID%
echo.
:confirmguid2
set confirm=none
set /p confirm=* �Է��Ͻ� GUID�� %GUID%�Դϴ�. Ȯ���մϱ�? (y/n): 
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
echo *                                 EFI��� �ӽú��ü�����                       by. k_mjg *
echo ******************************************************************************************
echo *                              bootmgr�� OS ��Ʈ������ ����                              *
echo ******************************************************************************************
echo *                            �ٸ� bootmgr�� OS ��Ʈ������ ����                           *
echo ******************************************************************************************
echo.
echo * �Ʒ��� bootmgr�� OS����Դϴ�. Windows ���� �δ��� identifier�׸��� �ϳ��� �����ϼ���.
bcdedit /store %path%
echo.
echo * ������ OS�� GUID�� �����Ͽ� �ٿ���������.
echo * �� : {default}, {current} Ȥ�� {12345678-1234-1234-1234-123456789012}, ��ȣ���� �Է�
set GUID=none
set /p GUID=* (Enter=�ڷΰ���) : 
if "%GUID%"=="none" goto bcdeditstore
bcdedit /store %path% /enum %GUID%
echo.
:confirmguid3
set confirm=none
set /p confirm=* �Է��Ͻ� GUID�� %GUID%�Դϴ�. Ȯ���մϱ�? (y/n): 
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
set /p continue=* �۾��� �ٽ� �����Ͻðڽ��ϱ�? (y/n): 
if /i %continue%==y goto level1

endlocal