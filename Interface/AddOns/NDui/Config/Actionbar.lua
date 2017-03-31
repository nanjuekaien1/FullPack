local _, C, _, _ = unpack(select(2, ...))

--[[
	˵����
	�����lua���˽⣬��رմ�ҳ�档
	����ս���������ᵼ����Ⱦ�Լ��޷���ս�������⣬������ֻ֧�������ͣ��
	nilΪ���ã�barFaderΪ���á��޸�ʱע���Сд��
]]

-- ������ϸ�ڵ���
local barFader = {						-- ��������������
	fadeInAlpha = 1,					-- ��ʾʱ��͸����
	fadeInDuration = .3,				-- ��ʾ��ʱ
	fadeOutAlpha = 0,					-- �������͸����
	fadeOutDuration = .8,				-- ������ʱ
	fadeOutDelay = .5,					-- �ӳٽ���
}

C.bars = {
	userplaced				= true,		-- ʹ���ͨ����Ϸ�������ƶ�

	-- BAR1 �����������£�
	bar1 = {
		scale           	= 1,		-- ��1Ϊ��׼����/����
		size				= 34,		-- ͼ���С
		fader				= nil,		-- �����ͣ����
    },
    -- BAR2 �����������ϣ�
    bar2 = {
		scale          		= 1,		-- ��1Ϊ��׼����/����
		size           		= 34,		-- ͼ���С
		fader				= nil,		-- �����ͣ����
    },
    -- BAR3 ������������
    bar3 = {
		scale           	= 1,		-- ��1Ϊ��׼����/����
		size        	    = 32,		-- ͼ���С
		fader				= nil,		-- �����ͣ����
    },
    -- BAR4 �ұ߶�����1
    bar4 = {
		scale           	= 1,		-- ��1Ϊ��׼����/����
		size           		= 32,		-- ͼ���С
		fader				= barFader,	-- �����ͣ����
    },
    -- BAR5 �ұ߶�����2
    bar5 = {
		scale          		= 1,		-- ��1Ϊ��׼����/����
		size				= 32,		-- ͼ���С
		fader				= barFader, -- �����ͣ����
    },
    -- PETBAR ���ﶯ����
    petbar = {
		scale           	= 1,		-- ��1Ϊ��׼����/����
		size	            = 26,		-- ͼ���С
		fader				= nil,		-- �����ͣ����
    },
    -- STANCE + POSSESSBAR ��̬��
    stancebar = {
		scale           	= 1,		-- ��1Ϊ��׼����/����
		size          		= 30,		-- ͼ���С
		fader				= nil,		-- �����ͣ����
    },
    -- EXTRABAR ���⶯����
    extrabar = {
		scale          		= 1,		-- ��1Ϊ��׼����/����
		size    	        = 56,		-- ͼ���С
		fader				= nil,		-- �����ͣ����
    },
    -- VEHICLE EXIT �뿪�ؾ߰�ť
    leave_vehicle 			= {
		scale           	= 1,		-- ��1Ϊ��׼����/����
		size          		= 32,		-- ͼ���С
		fader				= nil,		-- �����ͣ����
    },
}