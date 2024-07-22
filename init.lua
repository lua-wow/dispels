local addon, ns = ...

local Dispels = CreateFrame("Frame")
Dispels.debuffs = {}

-- https://wowpedia.fandom.com/wiki/WOW_PROJECT_ID
Dispels.isRetail = (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE)
Dispels.isClassic = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC)
Dispels.isTBC = (WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC)
Dispels.isWrath = (WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC)
Dispels.isCata = (WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC)

ns.Dispels = Dispels
