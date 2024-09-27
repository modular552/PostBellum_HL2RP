--[[
Server Name: PostBellum HL2 RP | Русский Half-Life 2 Roleplay
Server IP:   212.22.85.2:27015
File Path:   addons/common_weapons/lua/autorun/weapon_insurgency_sounds.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

-- shared
sound.Add({
	name = "Universal.PistolDraw",
	channel = CHAN_WEAPON,
	volume = 1.0,
	pitch = 80,
	soundlevel = SNDLVL_NORM,
	sound = {
		"weapons/universal/uni_pistol_draw_01.wav",
		"weapons/universal/uni_pistol_draw_02.wav",
		"weapons/universal/uni_pistol_draw_03.wav",
	}
})
sound.Add({
	name = "Universal.PistolHolster",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = SNDLVL_NORM,
	sound = "weapons/universal/uni_pistol_holster.wav",
})
sound.Add({
	name = "Universal.Draw",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = SNDLVL_NORM,
	sound = {
		"weapons/universal/uni_weapon_draw_01.wav",
		"weapons/universal/uni_weapon_draw_02.wav",
		"weapons/universal/uni_weapon_draw_03.wav",
	}
})
sound.Add({
	name = "Universal.Holster",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = SNDLVL_NORM,
	sound = "weapons/universal/uni_weapon_holster.wav",
})

-- akm
sound.Add({
    name = "Weapon_AK47.Empty",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ak47/handling/ak47_empty.wav",
})
sound.Add({
    name = "Weapon_AK47.MagRelease",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ak47/handling/ak47_magrelease.wav",
})
sound.Add({
    name = "Weapon_AK47.Magin",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ak47/handling/ak47_magin.wav",
})
sound.Add({
    name = "Weapon_AK47.Magout",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ak47/handling/ak47_magout.wav",
})
sound.Add({
    name = "Weapon_AK47.MagoutRattle",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ak47/handling/ak47_magout_rattle.wav",
})
sound.Add({
    name = "Weapon_AK47.Rattle",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ak47/handling/ak47_rattle.wav",
})
sound.Add({
    name = "Weapon_AK47.Boltback",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ak47/handling/ak47_boltback.wav",
})
sound.Add({
    name = "Weapon_AK47.Boltrelease",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ak47/handling/ak47_boltrelease.wav",
})
sound.Add({
    name = "Weapon_AK47.ROF",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = {
		"weapons/ak47/handling/ak47_fireselect_1.wav",
		"weapons/ak47/handling/ak47_fireselect_2.wav",
	}
})

-- aks74u
sound.Add({
    name = "Weapon_AKS74U.Empty",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/aks74u/handling/aks_empty.wav",
})
sound.Add({
    name = "Weapon_AKS74U.MagRelease",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/aks74u/handling/aks_magrelease.wav",
})
sound.Add({
    name = "Weapon_AKS74U.Magin",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/aks74u/handling/aks_magin.wav",
})
sound.Add({
    name = "Weapon_AKS74U.Magout",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/aks74u/handling/aks_magout.wav",
})
sound.Add({
    name = "Weapon_AKS74U.MagoutRattle",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/aks74u/handling/aks_magout_rattle.wav",
})
sound.Add({
    name = "Weapon_AKS74U.Rattle",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/aks74u/handling/aks_rattle.wav",
})
sound.Add({
    name = "Weapon_AKS74U.Boltback",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/aks74u/handling/aks_boltback.wav",
})
sound.Add({
    name = "Weapon_AKS74U.Boltrelease",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/aks74u/handling/aks_boltrelease.wav",
})
sound.Add({
    name = "Weapon_AKS74U.ROF",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = {
		"weapons/aks74u/handling/aks_fireselect_1.wav",
		"weapons/aks74u/handling/aks_fireselect_2.wav",
	}
})

-- m9
sound.Add({
    name = "Weapon_M9.Empty",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/m9/handling/m9_empty.wav",
})
sound.Add({
    name = "Weapon_M9.Magrelease",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/m9/handling/m9_safety.wav",
})
sound.Add({
    name = "Weapon_M9.Magin",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/m9/handling/m9_magin.wav",
})
sound.Add({
    name = "Weapon_M9.Magout",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/m9/handling/m9_magout.wav",
})
sound.Add({
    name = "Weapon_M9.MagHit",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/m9/handling/m9_maghit.wav",
})
sound.Add({
    name = "Weapon_M9.Boltback",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/m9/handling/m9_boltback.wav",
})
sound.Add({
    name = "Weapon_M9.Boltrelease",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/m9/handling/m9_boltrelease.wav",
})

-- m45
sound.Add({
    name = "Weapon_M45.Empty",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/m45/handling/m45_empty.wav",
})
sound.Add({
    name = "Weapon_M45.Magrelease",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/m45/handling/m45_safety.wav",
})
sound.Add({
    name = "Weapon_M45.Magin",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/m45/handling/m45_magin.wav",
})
sound.Add({
    name = "Weapon_M45.Magout",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/m45/handling/m45_magout.wav",
})
sound.Add({
    name = "Weapon_M45.MagHit",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/m45/handling/m45_maghit.wav",
})
sound.Add({
    name = "Weapon_M45.Boltback",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/m45/handling/m45_boltback.wav",
})
sound.Add({
    name = "Weapon_M45.Boltrelease",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/m45/handling/m45_boltrelease.wav",
})

-- m590
sound.Add({
    name = "Weapon_m590.Empty",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/m590/handling/m590_empty.wav",
})
sound.Add({
    name = "Weapon_m590.BoltBack",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/m590/handling/m590_pumpback.wav",
})
sound.Add({
    name = "Weapon_m590.BoltRelease",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/m590/handling/m590_pumpforward.wav",
})
sound.Add({
    name = "Weapon_m590.ShellInsert",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = {
		"weapons/m590/handling/m590_shell_insert_1.wav",
		"weapons/m590/handling/m590_shell_insert_2.wav",
		"weapons/m590/handling/m590_shell_insert_3.wav",
	}
})
sound.Add({
    name = "Weapon_m590.ShellInsertSingle",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = {
		"weapons/m590/handling/m590_single_shell_insert_1.wav",
		"weapons/m590/handling/m590_single_shell_insert_2.wav",
		"weapons/m590/handling/m590_single_shell_insert_3.wav",
	}
})

-- m1911
sound.Add({
    name = "Weapon_M1911.Empty",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/m1911/handling/m1911_empty.wav",
})
sound.Add({
    name = "Weapon_M1911.Magrelease",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/m1911/handling/m1911_safety.wav",
})
sound.Add({
    name = "Weapon_M1911.Magin",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/m1911/handling/m1911_magin.wav",
})
sound.Add({
    name = "Weapon_M1911.Magout",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/m1911/handling/m1911_magout.wav",
})
sound.Add({
    name = "Weapon_M1911.MagHit",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/m1911/handling/m1911_maghit.wav",
})
sound.Add({
    name = "Weapon_M1911.Boltback",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/m1911/handling/m1911_boltback.wav",
})
sound.Add({
    name = "Weapon_M1911.Boltrelease",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/m1911/handling/m1911_boltrelease.wav",
})

-- makarov
sound.Add({
    name = "Weapon_makarov.Empty",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/makarov/handling/makarov_empty.wav",
})
sound.Add({
    name = "Weapon_makarov.Magrelease",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/makarov/handling/makarov_safety.wav",
})
sound.Add({
    name = "Weapon_makarov.Magin",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/makarov/handling/makarov_magin.wav",
})
sound.Add({
    name = "Weapon_makarov.Magout",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/makarov/handling/makarov_magout.wav",
})
sound.Add({
    name = "Weapon_makarov.MagHit",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/makarov/handling/makarov_maghit.wav",
})
sound.Add({
    name = "Weapon_makarov.Boltback",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/makarov/handling/makarov_boltback.wav",
})
sound.Add({
    name = "Weapon_makarov.Boltrelease",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/makarov/handling/makarov_boltrelease.wav",
})

-- mini14
sound.Add({
    name = "Weapon_Mini14.Empty",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/mini14/handling/mini14_empty.wav",
})
sound.Add({
    name = "Weapon_Mini14.Magrelease",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/mini14/handling/mini14_magrelease.wav",
})
sound.Add({
    name = "Weapon_Mini14.Magin",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/mini14/handling/mini14_magin.wav",
})
sound.Add({
    name = "Weapon_Mini14.Magout",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/mini14/handling/mini14_magout.wav",
})
sound.Add({
    name = "Weapon_Mini14.Boltback",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/mini14/handling/mini14_boltback.wav",
})
sound.Add({
    name = "Weapon_Mini14.Boltrelease",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/mini14/handling/mini14_boltrelease.wav",
})

-- mosin
sound.Add({
    name = "Weapon_Mosin.Empty",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/mosin/handling/mosin_empty.wav",
})
sound.Add({
    name = "Weapon_Mosin.BoltRelease",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/mosin/handling/mosin_boltrelease.wav",
})
sound.Add({
    name = "Weapon_Mosin.BoltLatch",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/mosin/handling/mosin_boltlatch.wav",
})
sound.Add({
    name = "Weapon_Mosin.Boltback",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/mosin/handling/mosin_boltback.wav",
})
sound.Add({
    name = "Weapon_Mosin.Boltforward",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/mosin/handling/mosin_boltforward.wav",
})
sound.Add({
    name = "Weapon_Mosin.Roundin",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = {
		"weapons/mosin/handling/mosin_bulletin_1.wav",
		"weapons/mosin/handling/mosin_bulletin_2.wav",
		"weapons/mosin/handling/mosin_bulletin_3.wav",
		"weapons/mosin/handling/mosin_bulletin_4.wav",
	},
})

-- mp5
sound.Add({
    name = "Weapon_mp5k.Empty",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/mp5k/handling/mp5k_empty.wav",
})
sound.Add({
    name = "Weapon_mp5k.MagRelease",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/mp5k/handling/mp5k_magrelease.wav",
})
sound.Add({
    name = "Weapon_mp5k.Magin",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/mp5k/handling/mp5k_magin.wav",
})
sound.Add({
    name = "Weapon_mp5k.Magout",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/mp5k/handling/mp5k_magout.wav",
})
sound.Add({
    name = "Weapon_mp5k.Boltlock",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/mp5k/handling/mp5k_boltlock.wav",
})
sound.Add({
    name = "Weapon_mp5k.Boltback",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/mp5k/handling/mp5k_boltback.wav",
})
sound.Add({
    name = "Weapon_mp5k.Boltrelease",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/mp5k/handling/mp5k_boltrelease.wav",
})

-- rpk
sound.Add({
    name = "Weapon_RPK.Empty",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/rpk/handling/rpk_empty.wav",
})
sound.Add({
    name = "Weapon_RPK.FetchMag",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/rpk/handling/rpk_fetchmag.wav"
})
sound.Add({
    name = "Weapon_RPK.Magrelease",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/rpk/handling/rpk_magrelease.wav"
})
sound.Add({
    name = "Weapon_RPK.Magin",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/rpk/handling/rpk_magin.wav"
})
sound.Add({
    name = "Weapon_RPK.Magout",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/rpk/handling/rpk_magout.wav"
})
sound.Add({
    name = "Weapon_RPK.Boltback",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/rpk/handling/rpk_boltback.wav"
})
sound.Add({
    name = "Weapon_RPK.Boltrelease",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/rpk/handling/rpk_boltrelease.wav"
})
sound.Add({
    name = "Weapon_RPK.MagoutRattle",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/rpk/handling/rpk_magout_rattle.wav"
})
sound.Add({
    name = "Weapon_RPK.Rattle",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/rpk/handling/rpk_rattle.wav"
})
sound.Add({
    name = "Weapon_RPK.ROF",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/rpk/handling/rpk_fireselect_1.wav"
})

-- sks
sound.Add({
    name = "Weapon_SKS.Empty",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/sks/handling/sks_empty.wav",
})
sound.Add({
    name = "Weapon_SKS.Magrelease",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/sks/handling/sks_magrelease.wav",
})
sound.Add({
    name = "Weapon_SKS.Magin",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/sks/handling/sks_magin.wav",
})
sound.Add({
    name = "Weapon_SKS.Magout",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/sks/handling/sks_magout.wav",
})
sound.Add({
    name = "Weapon_SKS.Boltback",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/sks/handling/sks_boltback.wav",
})
sound.Add({
    name = "Weapon_SKS.Boltrelease",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/sks/handling/sks_boltrelease.wav",
})

-- toz
sound.Add({
    name = "Weapon_TOZ.Empty",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/toz_shotgun/handling/toz_empty.wav",
})
sound.Add({
    name = "Weapon_TOZ.BoltBack",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/toz_shotgun/handling/toz_pumpback.wav",
})
sound.Add({
    name = "Weapon_TOZ.BoltRelease",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/toz_shotgun/handling/toz_pumpforward.wav",
})
sound.Add({
    name = "Weapon_TOZ.ShellInsert",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = {
		"weapons/toz_shotgun/handling/toz_shell_insert_1.wav",
		"weapons/toz_shotgun/handling/toz_shell_insert_2.wav",
		"weapons/toz_shotgun/handling/toz_shell_insert_3.wav",
	}
})
sound.Add({
    name = "Weapon_TOZ.ShellInsertSingle",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = {
		"weapons/toz_shotgun/handling/toz_single_shell_insert_1.wav",
		"weapons/toz_shotgun/handling/toz_single_shell_insert_2.wav",
		"weapons/toz_shotgun/handling/toz_single_shell_insert_3.wav",
	}
})
