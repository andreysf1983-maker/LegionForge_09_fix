@echo off
setlocal EnableExtensions DisableDelayedExpansion
pushd "%~dp0" || exit /b 1
FOR %%P IN (proto\global_extensions\*.proto) DO (
  protoc.exe --plugin=protoc-gen-bnet=protoc-gen-bnet.exe --bnet_out=dllexport_decl=TC_SHARED_API:buildproto -Iproto "%%P"
  if errorlevel 1 goto :FAILED
)
FOR %%P IN (proto\*.proto) DO (
  protoc.exe --plugin=protoc-gen-bnet=protoc-gen-bnet.exe --bnet_out=dllexport_decl=TC_SHARED_API:buildproto -Iproto "%%P"
  if errorlevel 1 goto :FAILED
)
popd
exit /b 0

:FAILED
popd
exit /b 1
