# PostBellum_HL2RP
HL2RP framework for Garry's Mod based on Clockwork

Если Главные Администраторы (TIMON_Z1535 или dimidrol) не захотят видеть эту сборку на GitHub, то я ее удалю как и "rp_pb_industrial17_v1" в workshop'е.

## Гайд по запуску сборки
Для начала создайте сервер с помощью steamcmd.exe **В ОДИНОЧНОЙ ИГРЕ СБОРКА РАБОТАТЬ НЕ БУДЕТ!!!**
На эту тему много роликов вы разберетесь.

Далее libboost и прочее dll файлы закидываем в папку GarrysModDS, а остальные папки в папку garrysmod
Код для start.bat :
```
start "SRCDS" /B srcds.exe -game garrysmod -conlog -port 27015 -console -conclearlog -condebug -tvdisable -maxplayers 100 +gamemode postbellum +r_hunkalloclightmaps 0 +map rp_pb_industrial17_v2 -tickrate 33 +fps_max 33 +host_workshop_collection "414788549" +sv_lan 0
```

**Я не несу ответственности за внезапную поломку, а также другие последствия, связанные с сборкой. Если что-то не работает - все на ваш страх и риск.**

**Сборка не моя!!! Я лишь ее фиксил - и все, я ничего к себе не присваиваю, это все заслуги разработчиков PostBellum HL2 RP.**
