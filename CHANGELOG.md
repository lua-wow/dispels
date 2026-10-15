# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.2.0] - 2026-10-14

### Changed

-   Interface for Classic Era, TBC, WotLK and MoP only (the combat log can't be read on Retail)
-   `C_ChatInfo.SendChatMessage` instead of the deprecated global
-   Aura data split into `data/<expansion>.lua`, loaded only on clients that have the expansion
-   Removed client flags, Mythic+ affix auras and other dead code; added `.luacheckrc` and `make check`

## [1.1.3] - 2024-10-14

### Changed

-   Added new debuffs from `The War Within` patch 11.0.2

## [1.1.2] - 2024-08-15

### Changed

-   Patch 11.0.0, new api namespace `C_Spell`
-   Added some Dragonflight spells
-   Fix flags filter, the addon was annoucing dispels from other party members.

## [1.1.1] - 2024-07-27

### Added

-   `Brackenhide Hollow` and `Halls of Infusion` enrage spells.

### Changed

-   We check for `extraSpellID` not the `spellID`.

## [1.1.0] - 2024-07-22

### Changed

-   Update `.toc` file.
-   Update spells table.
-   Fix `SPELL_STOLEN` event bug which was not triggering.

## [1.0.0] - 2024-01-02

### Added

-   `CHANGELOG.md' initialized.
