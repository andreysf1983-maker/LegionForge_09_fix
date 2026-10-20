# LegionForge 7.3.5.26124 — список исправлений (LegionForge_6-fixed)

## 1. Критический креш при старте worldserver
`DB2Stores.cpp:2004  ASSERTION FAILED: false && "Need update MS::Battlegrounds::MaxBrackets by db2 data"`

* `BattlegroundDefines.h` — `MS::Battlegrounds::MaxBrackets` поднят с 12 до 24
  (данные клиента собраны из BfA/Shadowlands/Dragonflight, `PvpDifficulty.db2` содержит больше
  уровневых брекетов, чем классический Legion).
* `DB2Stores.cpp` — жёсткий ASSERT заменён на диагностическое сообщение в лог:
  записи с `RangeIndex >= MaxBrackets` просто игнорируются, сервер больше не падает.
* `DB2Manager::GetBattlegroundBracketByLevel()` / `GetBattlegroundBracketById()` — такие записи
  никогда не возвращаются, поэтому `RangeIndex` не может выйти за границы массивов очередей BG/арены.

## 2. Защита от следующих падений на смешанных db2 (BfA/SL/DF)
Жёсткие ASSERT в `DB2Manager::InitDB2CustomStores()` заменены на пропуск записи + запись в лог:

* `SpellEffect.db2` — неизвестные Effect / EffectAura / ImplicitTarget (эффекты новых аддонов);
  дополнительно устранено переполнение `_spellEffectDiff` / `_spellEffectMap` при `SpellID`,
  превышающем число строк таблицы (порча кучи → случайные креши).
* `ChrSpecialization.db2` — ClassID / OrderIndex вне диапазона ядра.
* `ChrClassesXPowerTypes.db2` — неизвестные типы ресурса.
* `CharBaseSection.db2` / `CharSections.db2` — неизвестные варианты секций внешности.
* `ItemChildEquipment.db2` — дубликаты ItemID.
* `ItemClass.db2` — дубликаты/неизвестные OldEnumValue.
* `NamesProfanity.db2` / `NamesReserved*.db2` — некорректный UTF-8 и Language вне MAX_LOCALES.
* `BattlePetSpecies.db2`, `PvpScalingEffectTypes.db2` — только предупреждение вместо ASSERT.

## 3. Выход за границу массива в очереди боёв
`BattlegroundQueue::RemovePlayerQueue()` — счётчик цикла был `uint8` и сравнивался с `>= 0`,
то есть при неудачном поиске уходил в 255 и читал память за пределами `_queuedGroups`
(редкие креши при выходе из очереди). Счётчик переведён в `int32`.

## 4. Логи пишутся в server\logs, а не рядом с worldserver.exe
* `Log.cpp` — значение по умолчанию `LogsDir` = `logs`; каталог создаётся автоматически при старте
  (раньше, если каталога не было, файловые аппендеры молча не создавали логи).
* `PacketLog.cpp` — тот же каталог по умолчанию для дампов пакетов.
* `worldserver.conf`, `bnetserver.conf` и оба `*.conf.dist` — `LogsDir = "logs"`.
* Добавлена папка `server/logs/`.
