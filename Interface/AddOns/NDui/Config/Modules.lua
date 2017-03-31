-- Configure ����ҳ��
local _, C, _, _ = unpack(select(2, ...))

-- BUFF/DEBUFF���
C.Auras = {
	IconSize		= 32,											-- BUFFͼ���С
	IconsPerRow		= 14,											-- BUFFÿ�и���
	Spacing			= 6,											-- BUFFͼ����
	BuffPos			= {"TOPRIGHT", Minimap, "TOPLEFT", -10, -5},	-- BUFFλ��

	BHPos			= {"CENTER", UIParent, "CENTER", 0, -200},		-- ѪDK����Ĭ��λ��
	StaggerPos		= {"CENTER", UIParent, "CENTER", 0, -220},		-- ̹ɮ����Ĭ��λ��
	TotemsPos		= {"CENTER", UIParent, "CENTER", 0, -190},		-- ͼ������Ĭ��λ��
	MarksmanPos		= {"CENTER", UIParent, "CENTER", 0, -190},		-- ���������Ĭ��λ��
	FamiliarPos		= {"BOTTOMLEFT", UIParent, 480, 270},			-- �·�ħ��Ĭ��λ��
	StatuePos		= {"BOTTOMLEFT", UIParent, 480, 270},			-- ��ɮ����Ĭ��λ��
}

-- ͷ�����
C.UFs = {
	Playercb		= {"BOTTOM", UIParent, "BOTTOM", 16, 175},		-- ���ʩ����Ĭ��λ��
	PlayercbSize	= {300, 20},									-- ���ʩ�����ߴ�
	Targetcb		= {"BOTTOM", UIParent, "BOTTOM", 16, 335},		-- Ŀ��ʩ����Ĭ��λ��
	TargetcbSize	= {280, 20},									-- Ŀ��ʩ�����ߴ�
	Focuscb			= {"CENTER", UIParent, "CENTER", 10, 200},		-- ����ʩ����Ĭ��λ��
	FocuscbSize		= {320, 20},									-- ����ʩ�����ߴ�

	PlayerPos		= {"TOPRIGHT", UIParent, "BOTTOM", -200, 300},	-- ��ҿ���Ĭ��λ��
	TargetPos		= {"TOPLEFT", UIParent, "BOTTOM", 200, 300},	-- Ŀ�����Ĭ��λ��
	ToTPos			= {"BOTTOM", UIParent, "BOTTOM", 136, 241},		-- Ŀ���Ŀ�����Ĭ��λ��
	PetPos			= {"BOTTOM", UIParent, "BOTTOM", -136, 241},	-- �������Ĭ��λ��
	FocusPos		= {"LEFT", UIParent, "LEFT", 5, -150},			-- �������Ĭ��λ��
	FoTPos			= {"LEFT", UIParent, "LEFT", 210, -150},		-- ����Ŀ�����Ĭ��λ��

	BarPoint		= {"TOPLEFT", 12, 4},							-- ��Դ��λ�ã�������ͷ��Ϊ��׼��
	BarSize			= {150, 5},										-- ��Դ���ĳߴ磨������
	BarMargin		= 2,											-- ��Դ�����
}

-- С��ͼ
C.Minimap = {
	Pos				= {"TOPRIGHT", UIParent, "TOPRIGHT", -7, -7},	-- С��ͼλ��
}

-- ������Ƥ��
C.Skins = {
	MicroMenuPos 	= {"BOTTOM", UIParent, "BOTTOM", 0, 2.5},		-- ΢�Ͳ˵�����
	RMPos  			= {"TOP", UIParent, "TOP", 0, 0},				-- �Ŷӹ���Ĭ������
}

-- �����ʾ��
C.Tooltips = {
	TipPos 	= {"BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -55, 230},	-- �����ʾ��Ĭ��λ��
}