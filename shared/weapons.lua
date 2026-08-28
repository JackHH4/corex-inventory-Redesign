--[[
    COREX Inventory - Weapons Definition
]]

Weapons = {
    -- =====================
    -- MELEE
    -- =====================
    ['WEAPON_KNIFE'] = {
        label = 'Knife',
        weight = 0.6,
        size = {w = 1, h = 2},
        image = 'WEAPON_KNIFE.png',
        ammoType = nil,
        prop = 'prop_w_me_knife_01',
        rarity = 'common',
        category = 'melee'
    },
    ['WEAPON_KNUCKLE'] = {
        label = 'Brass Knuckles',
        weight = 0.5,
        size = {w = 1, h = 1},
        image = 'WEAPON_KNUCKLE.png',
        ammoType = nil,
        prop = 'w_me_knuckle',
        rarity = 'uncommon',
        category = 'melee'
    },
    ['WEAPON_HAMMER'] = {
        label = 'Hammer',
        weight = 1.4,
        size = {w = 1, h = 2},
        image = 'WEAPON_HAMMER.png',
        ammoType = nil,
        prop = 'w_me_hammer',
        rarity = 'common',
        category = 'melee'
    },
    ['WEAPON_SWITCHBLADE'] = {
        label = 'Switchblade',
        weight = 0.5,
        size = {w = 1, h = 2},
        image = 'WEAPON_SWITCHBLADE.png',
        ammoType = nil,
        prop = 'w_me_switchblade',
        rarity = 'uncommon',
        category = 'melee'
    },

    -- Extra melee (existing assets)
    ['WEAPON_BAT'] = {
        label = 'Bat',
        weight = 2.2,
        size = {w = 1, h = 4},
        image = 'WEAPON_BAT.png',
        ammoType = nil,
        prop = 'w_me_bat',
        rarity = 'common',
        category = 'melee'
    },
    ['WEAPON_CROWBAR'] = {
        label = 'Crowbar',
        weight = 2.0,
        size = {w = 1, h = 3},
        image = 'WEAPON_CROWBAR.png',
        ammoType = nil,
        prop = 'w_me_crowbar',
        rarity = 'common',
        category = 'melee'
    },
    ['WEAPON_DAGGER'] = {
        label = 'Dagger',
        weight = 1.1,
        size = {w = 1, h = 2},
        image = 'WEAPON_DAGGER.png',
        ammoType = nil,
        prop = 'w_me_dagger',
        rarity = 'uncommon',
        category = 'melee'
    },
    ['WEAPON_HATCHET'] = {
        label = 'Hatchet',
        weight = 1.7,
        size = {w = 1, h = 3},
        image = 'WEAPON_HATCHET.png',
        ammoType = nil,
        prop = 'w_me_hatchet',
        rarity = 'common',
        category = 'melee'
    },

    -- =====================
    -- PISTOLS
    -- =====================
    ['WEAPON_PISTOL'] = {
        label = 'Pistol',
        weight = 1.2,
        size = {w = 2, h = 1},
        image = 'weapon_pistol.png',
        ammoType = 'pistol_ammo',
        clipSize = 12,
        prop = 'w_pi_pistol',
        rarity = 'common',
        category = 'pistol'
    },
    ['WEAPON_COMBATPISTOL'] = {
        label = 'Combat Pistol',
        weight = 1.3,
        size = {w = 2, h = 1},
        image = 'weapon_combatpistol.png',
        ammoType = 'pistol_ammo',
        clipSize = 12,
        prop = 'w_pi_combatpistol',
        rarity = 'uncommon',
        category = 'pistol'
    },
    ['WEAPON_PISTOL50'] = {
        label = 'Pistol .50',
        weight = 1.8,
        size = {w = 2, h = 1},
        image = 'weapon_pistol50.png',
        ammoType = 'pistol_ammo',
        clipSize = 9,
        prop = 'w_pi_pistol50',
        rarity = 'rare',
        category = 'pistol'
    },
    ['WEAPON_PISTOL_MK2'] = {
        label = 'Pistol Mk II',
        weight = 1.3,
        size = {w = 2, h = 1},
        image = 'pistol_mk2.png',
        ammoType = 'pistol_ammo',
        clipSize = 12,
        prop = 'w_pi_pistolmk2',
        rarity = 'uncommon',
        category = 'pistol'
    },
    ['WEAPON_HEAVYPISTOL'] = {
        label = 'Heavy Pistol',
        weight = 1.6,
        size = {w = 2, h = 1},
        image = 'weapon_heavypistol.png',
        ammoType = 'pistol_ammo',
        clipSize = 18,
        prop = 'w_pi_heavypistol',
        rarity = 'rare',
        category = 'pistol'
    },
    ['WEAPON_REVOLVER'] = {
        label = 'Heavy Revolver',
        weight = 2.0,
        size = {w = 2, h = 1},
        image = 'revolver_7.png',
        ammoType = 'pistol_ammo',
        clipSize = 6,
        prop = 'w_pi_revolver',
        rarity = 'epic',
        category = 'pistol'
    },

    -- =====================
    -- SMG
    -- =====================
    ['WEAPON_MACHINEPISTOL'] = {
        label = 'Machine Pistol',
        weight = 1.5,
        size = {w = 2, h = 1},
        image = 'weapon_machinepistol.png',
        ammoType = 'smg_ammo',
        clipSize = 12,
        prop = 'w_sb_compactsmg',
        rarity = 'uncommon',
        category = 'smg'
    },
    ['WEAPON_MICROSMG'] = {
        label = 'Micro SMG',
        weight = 2.0,
        size = {w = 2, h = 1},
        image = 'weapon_microsmg.png',
        ammoType = 'smg_ammo',
        clipSize = 16,
        prop = 'w_sb_microsmg',
        rarity = 'uncommon',
        category = 'smg'
    },
    ['WEAPON_GUSENBERG'] = {
        label = 'Gusenberg Sweeper',
        weight = 4.5,
        size = {w = 3, h = 2},
        image = 'weapon_gusenberg.png',
        ammoType = 'smg_ammo',
        clipSize = 30,
        prop = 'w_sb_gusenberg',
        rarity = 'epic',
        category = 'smg'
    },

    -- =====================
    -- RIFLES
    -- =====================
    ['WEAPON_ASSAULTRIFLE'] = {
        label = 'Assault Rifle',
        weight = 3.5,
        size = {w = 3, h = 2},
        image = 'weapon_assaultrifle.png',
        ammoType = 'rifle_ammo',
        clipSize = 30,
        prop = 'w_ar_assaultrifle',
        rarity = 'rare',
        category = 'rifle'
    },
    ['WEAPON_ASSAULTRIFLE_MK2'] = {
        label = 'Assault Rifle Mk II',
        weight = 3.6,
        size = {w = 3, h = 2},
        image = 'weapon_assaultrifle_mk2.png',
        ammoType = 'rifle_ammo',
        clipSize = 30,
        prop = 'w_ar_assaultriflemk2',
        rarity = 'epic',
        category = 'rifle'
    },
    ['WEAPON_CARBINERIFLE'] = {
        label = 'Carbine Rifle',
        weight = 3.4,
        size = {w = 3, h = 2},
        image = 'weapon_carbinerifle.png',
        ammoType = 'rifle_ammo',
        clipSize = 30,
        prop = 'w_ar_carbinerifle',
        rarity = 'rare',
        category = 'rifle'
    },
    ['WEAPON_CARBINERIFLE_MK2'] = {
        label = 'Carbine Rifle Mk II',
        weight = 3.5,
        size = {w = 3, h = 2},
        image = 'weapon_carbinerifle_mk2.png',
        ammoType = 'rifle_ammo',
        clipSize = 30,
        prop = 'w_ar_carbineriflemk2',
        rarity = 'epic',
        category = 'rifle'
    },
    ['WEAPON_SPECIALCARBINE_MK2'] = {
        label = 'Special Carbine Mk II',
        weight = 3.7,
        size = {w = 3, h = 2},
        image = 'weapon_specialcarbine_mk2.png',
        ammoType = 'rifle_ammo',
        clipSize = 30,
        prop = 'w_ar_specialcarbinemk2',
        rarity = 'legendary',
        category = 'rifle'
    },
    ['WEAPON_TACTICALRIFLE'] = {
        label = 'Tactical Rifle',
        weight = 3.6,
        size = {w = 3, h = 2},
        image = 'weapon_tacticalrifle.png',
        ammoType = 'rifle_ammo',
        clipSize = 30,
        prop = 'w_ar_carbinerifle_reh',
        rarity = 'epic',
        category = 'rifle'
    },
    ['WEAPON_BULLPUPRIFLE_MK2'] = {
        label = 'Bullpup Rifle Mk II',
        weight = 3.3,
        size = {w = 3, h = 2},
        image = 'weapon_bullpuprifle_mk2.png',
        ammoType = 'rifle_ammo',
        clipSize = 30,
        prop = 'w_ar_bullpupriflemk2',
        rarity = 'epic',
        category = 'rifle'
    },
    ['WEAPON_COMPACTRIFLE'] = {
        label = 'Compact Rifle',
        weight = 2.8,
        size = {w = 2, h = 2},
        image = 'weapon_compactrifle.png',
        ammoType = 'rifle_ammo',
        clipSize = 30,
        prop = 'w_ar_assaultrifle_smg',
        rarity = 'rare',
        category = 'rifle'
    },
}

Ammo = {
    ['pistol_ammo'] = {
        label = 'Pistol Ammo',
        weight = 0.1,
        size = {w = 1, h = 1},
        stackable = true,
        maxStack = 250,
        image = 'pistol_ammopack.png',
        prop = 'prop_box_ammo07a',
        rarity = 'common'
    },
    ['smg_ammo'] = {
        label = 'SMG Ammo',
        weight = 0.1,
        size = {w = 1, h = 1},
        stackable = true,
        maxStack = 300,
        image = 'smg_ammopack.png',
        prop = 'prop_box_ammo07b',
        rarity = 'common'
    },
    ['rifle_ammo'] = {
        label = 'Rifle Ammo',
        weight = 0.12,
        size = {w = 1, h = 1},
        stackable = true,
        maxStack = 250,
        image = 'rifle_ammo.png',
        prop = 'prop_box_ammo07b',
        rarity = 'uncommon'
    },
    ['shotgun_ammo'] = {
        label = 'Shotgun Ammo',
        weight = 0.15,
        size = {w = 1, h = 1},
        stackable = true,
        maxStack = 80,
        image = 'shotgun_ammo.png',
        prop = 'prop_box_ammo07b',
        rarity = 'common'
    },
}

AttachmentItems = {
    ['at_flashlight'] = {
        label = 'Flashlight', weight = 0.3, size = {w = 1, h = 1},
        stackable = false, usable = true, image = 'at_flashlight.png', rarity = 'uncommon',
        componentType = 'flashlight',
        components = { 'COMPONENT_AT_PI_FLSH', 'COMPONENT_AT_PI_FLSH_02', 'COMPONENT_AT_AR_FLSH', 'COMPONENT_AT_AR_FLSH_REH' }
    },
    ['at_suppressor'] = {
        label = 'Suppressor', weight = 0.4, size = {w = 1, h = 1},
        stackable = false, usable = true, image = 'at_suppressor.png', rarity = 'rare',
        componentType = 'muzzle',
        components = { 'COMPONENT_AT_PI_SUPP', 'COMPONENT_AT_PI_SUPP_02', 'COMPONENT_AT_AR_SUPP', 'COMPONENT_AT_AR_SUPP_02' }
    },
    ['at_grip'] = {
        label = 'Grip', weight = 0.35, size = {w = 1, h = 1},
        stackable = false, usable = true, image = 'at_grip.png', rarity = 'uncommon',
        componentType = 'grip',
        components = { 'COMPONENT_AT_AR_AFGRIP', 'COMPONENT_AT_AR_AFGRIP_02' }
    },
    ['at_scope_macro'] = {
        label = 'Macro Scope', weight = 0.4, size = {w = 1, h = 1},
        stackable = false, usable = true, image = 'at_scope.png', rarity = 'rare',
        componentType = 'scope',
        components = { 'COMPONENT_AT_SCOPE_MACRO', 'COMPONENT_AT_SCOPE_MACRO_MK2', 'COMPONENT_AT_SCOPE_SMALL_MK2', 'COMPONENT_AT_PI_RAIL' }
    },
    ['at_scope_medium'] = {
        label = 'Medium Scope', weight = 0.5, size = {w = 1, h = 1},
        stackable = false, usable = true, image = 'at_scope_medium.png', rarity = 'epic',
        componentType = 'scope',
        components = { 'COMPONENT_AT_SCOPE_MEDIUM', 'COMPONENT_AT_SCOPE_MEDIUM_MK2' }
    },
    ['at_clip_extended'] = {
        label = 'Extended Clip', weight = 0.45, size = {w = 1, h = 1},
        stackable = false, usable = true, image = 'at_clip_extended.png', rarity = 'rare',
        componentType = 'magazine',
        components = {
            'COMPONENT_PISTOL_CLIP_02', 'COMPONENT_PISTOL50_CLIP_02', 'COMPONENT_COMBATPISTOL_CLIP_02',
            'COMPONENT_HEAVYPISTOL_CLIP_02', 'COMPONENT_PISTOL_MK2_CLIP_02',
            'COMPONENT_MACHINEPISTOL_CLIP_02', 'COMPONENT_MICROSMG_CLIP_02', 'COMPONENT_GUSENBERG_CLIP_02',
            'COMPONENT_ASSAULTRIFLE_CLIP_02', 'COMPONENT_ASSAULTRIFLE_MK2_CLIP_02',
            'COMPONENT_CARBINERIFLE_CLIP_02', 'COMPONENT_CARBINERIFLE_MK2_CLIP_02',
            'COMPONENT_SPECIALCARBINE_MK2_CLIP_02', 'COMPONENT_TACTICALRIFLE_CLIP_02',
            'COMPONENT_BULLPUPRIFLE_MK2_CLIP_02', 'COMPONENT_COMPACTRIFLE_CLIP_02'
        }
    }
}

if type(Items) == 'table' then
    for name, def in pairs(AttachmentItems) do
        if Items[name] == nil then Items[name] = def end
    end
    for name, def in pairs(Ammo) do
        if Items[name] == nil then Items[name] = def end
    end
end
