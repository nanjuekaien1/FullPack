local _, ns = ...
local _, C = unpack(ns)

-- 法术白名单
C.WhiteList = {
	-- Buffs
	[642]		= true,		-- 圣盾术
	[1022]		= true,		-- 保护之手
	[23920]		= true,		-- 法术反射
	[45438]		= true,		-- 寒冰屏障
	[186265]	= true,		-- 灵龟守护
	-- Debuffs
	[2094]		= true,		-- 致盲
	[117405]	= true,		-- 束缚射击
	[127797]	= true,		-- 乌索尔旋风
	[20549] 	= true,		-- 战争践踏
	[107079] 	= true,		-- 震山掌
	[272295] 	= true,		-- 悬赏
	-- Mythic+
	[228318]	= true,		-- 激怒
	[226510]	= true,		-- 血池
	[343553]	= true,		-- 万噬之怨
	-- Dungeons
	[320293]	= true,		-- 伤逝剧场，融入死亡
	[336449]	= true,		-- 凋魂之殇，玛卓克萨斯之墓
	[333737]	= true,		-- 凋魂之殇，凝结之疾
	[328175]	= true,		-- 凋魂之殇，凝结之疾
	[228626]	= true,		-- 彼界，怨灵之瓮
	-- Raids
	[334695]	= true,		-- 动荡能量，猎手
	[345902]	= true,		-- 破裂的联结，猎手
	[346792]	= true,		-- 罪触之刃，猩红议会
}

-- 法术黑名单
C.BlackList = {
	[15407]		= true,		-- 精神鞭笞
	[51714]		= true,		-- 锋锐之霜
	[199721]	= true,		-- 腐烂光环
	[214968]	= true,		-- 死灵光环
	[214975]	= true,		-- 抑心光环
	[273977]	= true,		-- 亡者之握
	[276919]	= true,		-- 承受压力
	[206930]	= true,		-- 心脏打击
}

-- 取自地城手册的段落ID
-- 纯数字则为GUID，选择目标后输入/getnpc获取
local function GetSectionInfo(id)
	return C_EncounterJournal.GetSectionInfo(id).title
end

-- 特殊单位的染色列表
C.CustomUnits = {
	-- Nzoth vision
	[153401] = true, -- 克熙尔支配者
	[157610] = true, -- 克熙尔支配者
	[156795] = true, -- 军情七处线人
	-- Dungeons
	[120651] = true, -- 大米，爆炸物
	[174773] = true, -- 大米，怨毒影魔
	[GetSectionInfo(22161)] = true,	-- 凋魂之殇，魔药炸弹
	[170851] = true,	-- 凋魂之殇，易爆魔药炸弹
	[165556] = true,	-- 赤红深渊，瞬息具象
	[170234] = true,	-- 伤逝剧场，压制战旗
	[164464] = true,	-- 伤逝剧场，卑劣的席拉
	-- Raids
	[GetSectionInfo(21953)] = true,	-- 凯子，灵能灌注者
	[175992] = true,	-- 猩红议会，忠实的侍从
}

-- 显示能量值的单位
C.ShowPowerList = {
	[165556] = true,	-- 赤红深渊，瞬息具象
	[GetSectionInfo(22339)] = true,	-- 猎手阿尔迪莫，巴加斯特之影
}