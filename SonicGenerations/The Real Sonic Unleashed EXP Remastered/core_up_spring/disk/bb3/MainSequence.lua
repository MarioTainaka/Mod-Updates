-- SonicGMI Bootscript v1.0 by Dario ff
-- Configure the variables below

global("SONICGMI_STAGE_BOOT", 0);        -- 0: Regular game

                                         -- 1: Boot into Stage directly after first logos,
                                         -- then return to Title Screen

                                         -- 2: "Classic" level progression mode
                                         -- goes through the 9 main acts depending on the 
                                         -- character selected.

                                         -- 3: "Classic" level progression, but uses both Sonics


-- Used in Boot Mode and Classic Mode(not 3)
-- Irrelevant for the other modes
global("SONICGMI_SONIC", 0)              -- 0: Modern Sonic
                                         -- 1: Classic Sonic
                                         -- 2: Final Boss Super Sonic(crashes if not in last boss)

-- Only used in Boot mode
global("SONICGMI_STAGE_NAME", "euc200"); -- 6 character string of the stage to play.
                                         -- Missions need to be played by using the next variable

global("SONICGMI_STAGE_MISSION", 0);      -- 0: Regular stage
                                         -- 1-5: Missions

                                        
-- Regular game declarations

-- Global Variables
global("g_IsDebugSequence", 0);	-- Debug flag; does not work as of now (or debug mode isn't really anything)
-- Modes
global("MODULE_INIT",			"AppInit");
global("MODULE_LOGO",			"Logo");
global("MODULE_TITLE",			"Title");
global("MODULE_STORY",			"Story");
global("MODULE_MENU",			"Menu");
global("MODULE_DEBUGMENU",		"DebugMenu");
global("MODULE_PLAYABLEMENU",	"PlayableMenu");
global("MODULE_STAGE",			"Stage");
global("MODULE_EVENT",			"Event");
global("MODULE_STAGEEVENT",		"StageEvent");
global("MODULE_STAFFROLL",		"StaffRoll");
global("MODULE_EXIT",			"AppExit");
global("MODULE_GENESIS",		"Genesis");
global("MODULE_ONLINESTAGE",	"OnlineStage");
global("MODULE_SAVE",			"Save");
global("MODULE_NOTICEBOARD",	"NoticeBoard");
global("MODULE_NOTICE_SONICT",	"NoticeSonicT");	-- Sonic Team
global("MODULE_NOTICE_ESRB",	"NoticeEsrb");		-- ESRB warning display
global("MODULE_NOTICE_STEREO",	"NoticeStereo");	-- Stereoscopic warning (Is this even used?!)
global("MODULE_NOTICE_TEASER",	"NoticeTeaser");	-- CGI "teaser"
global("MODULE_STATUE",			"Statue");			-- Statue room
global("MODULE_DEBUGINIT",		"DebugInit");		-- Debug initilization sequence
global("MODULE_SUPERSONIC",		"SuperSonic");		-- スーパーソニック
global("MODULE_NOTICE_HAVOK",	"NoticeHavok");		-- Havok&Dolby
global("MODULE_NOTICE_CESA",	"NoticeCesa");		-- CESA警告

local s_Sequence = nil

-- シーケンス起動
function createSequenceActor()
	-- MainSequence作成
	s_Sequence = MainSequence:new()
end

-- シーケンス終了
function destroySequenceActor()
	if s_Sequence ~= nil then
		-- MainSequence削除
		g_Scheduler:delete_actor(s_Sequence)
	end
end

function getNextModule()
	local module = GetNextModule()

	if module == "Logo" then
		return MODULE_LOGO
	elseif module == "PlayableMenu" then
		return MODULE_PLAYABLEMENU
	elseif module == "Title" then
		return MODULE_TITLE
	elseif module == "Story" then
		return MODULE_STORY
	elseif module == "Menu" then
		return MODULE_MENU
	elseif module == "Stage" then
		return MODULE_STAGE
	elseif module == "Event" then
		return MODULE_EVENT
	elseif module == "StageEvent" then
		return MODULE_STAGEEVENT
	elseif module == "StaffRoll" then
		return MODULE_STAFFROLL
	elseif module == "Genesis" then
		return MODULE_GENESIS
	elseif module == "OnlineStage" then
		return MODULE_ONLINESTAGE
	elseif module == "NoticeSonicT" then
		return MODULE_NOTICE_SONICT
	elseif module == "NoticeEsrb" then
		return MODULE_NOTICE_ESRB
	elseif module == "NoticeStereo" then
		return MODULE_NOTICE_STEREO
	elseif module == "Statue" then
		return MODULE_STATUE
	elseif module == "DebugInit" then
		return MODULE_DEBUGINIT
	elseif module == "Save" then
		return MODULE_SAVE
	else
		return nil
	end
end

--[[
	MainSequence Class
]]
subclass ("MainSequence", Actor) {
	__tostring = function()
		return("MainSequence")
	end
}

function MainSequence:ctor(...)
	MainSequence.super.ctor(self, ...)

	-- シーケンステーブル作成
	self.sequence_table = {}
	local seqtbl = self.sequence_table

	-- シーケンス登録
	seqtbl[MODULE_INIT] = SequenceInit:new(self)
	seqtbl[MODULE_LOGO] = SequenceLogo:new(self)
	seqtbl[MODULE_TITLE] = SequenceTitle:new(self)
	seqtbl[MODULE_STORY] = SequenceStory:new(self)
	seqtbl[MODULE_MENU] = SequenceMenu:new(self)
	seqtbl[MODULE_DEBUGMENU] = SequenceDebugMenu:new(self)
	seqtbl[MODULE_PLAYABLEMENU] = SequencePlayableMenu:new(self)
	seqtbl[MODULE_STAGE] = SequenceStage:new(self)
	seqtbl[MODULE_EVENT] = SequenceEvent:new(self)
	seqtbl[MODULE_STAGEEVENT] = SequenceStageEvent:new(self)
	seqtbl[MODULE_STAFFROLL] = SequenceStaffRoll:new(self)
	seqtbl[MODULE_EXIT] = SequenceExit:new(self)
	seqtbl[MODULE_GENESIS] = SequenceGenesis:new(self)
	seqtbl[MODULE_ONLINESTAGE] = SequenceOnlineStage:new(self)
	seqtbl[MODULE_SAVE] = SequenceSave:new(self)
	seqtbl[MODULE_NOTICE_SONICT] = SequenceNoticeBoard:new(self, 3, true, false, false, false, "ui_nb_sonicteam", 2.0, MODULE_NOTICE_HAVOK, MODULE_NOTICE_HAVOK)
	seqtbl[MODULE_NOTICE_ESRB] = SequenceNoticeESRB:new(self)
	seqtbl[MODULE_NOTICE_STEREO] = SequenceNoticeStereo:new(self)
	seqtbl[MODULE_NOTICE_TEASER] = SequenceNoticeTeaser:new(self)
	seqtbl[MODULE_STATUE] = SequenceStatue:new(self)
	seqtbl[MODULE_DEBUGINIT] = SequenceDebugInit:new(self)
	seqtbl[MODULE_SUPERSONIC] = SequenceNoticeBoard:new(self, 3, true, true, false, false, "ui_nb_super_sonic", 5.0, MODULE_SAVE, MODULE_SAVE)
	seqtbl[MODULE_NOTICE_HAVOK] = SequenceNoticeHavok:new(self)
	seqtbl[MODULE_NOTICE_CESA] = SequenceNoticeCesa:new(self)

	-- モード設定
	self.module = MODULE_INIT
	self.prev_module = MODULE_INIT
	seqtbl[self.module]:initialize()
end

function MainSequence:update(act)
	local smodule = self.module
	local seqtbl = self.sequence_table

	local ret = seqtbl[smodule]:execute()

	-- ゲームをやめたとき(ソフトリセット？)
	local is_quit = IsQuitGame()
	if is_quit == 1 then
		self.module = MODULE_TITLE;	-- タイトルへ移行
		seqtbl[self.module]:initialize()
		return true
	end

	if ret == "Exit" then
		s_Sequence = nil
		return false	-- Actor exit
	elseif ret == nil then
		PringString("MainSequence: Don't set next module.")
	else
		-- 返り値のモードへ変更
		self.prev_module = self.module
		self.module = ret
		seqtbl[ret]:initialize()
	end

	return true	-- Actor continue
end

function MainSequence:getPrevModule()
	return self.prev_module
end


--[[
	SequenceBase Class
]]
class ("SequenceBase") {
	__tostring = function(self)
		return("Sequence Module "..self.module_name)
	end
}

function SequenceBase:ctor(...)
	local t = {...}

	self.manager = t[1]
end

function SequenceBase:initialize()
end

function SequenceBase:execute()
end


--[[
	SequenceInit Class
]]
subclass ("SequenceInit", SequenceBase) {
}

function SequenceInit:ctor(...)
	SequenceInit.super.ctor(self, ...)

	self.module_name = MODULE_INIT
end

function SequenceInit:initialize()
	StartModule( self.module_name );
end

function SequenceInit:execute()
	-- ストーリーシーケンススクリプトロード
	LoadScript("StorySequence");
	LoadScript("StorySequenceUtility");
	Actor:wait_step( WaitEndModule )

    return MODULE_DEBUGINIT
end


--[[
	SequenceLogo Class
]]
subclass ("SequenceLogo", SequenceBase) {
}

function SequenceLogo:ctor(...)
	SequenceLogo.super.ctor(self, ...)

	local t = {...};

	self.module_name = MODULE_LOGO
	self.notice_type = 2		-- 0:Logo20  1:Splash  2:Movie  3:NoticeBoard
	self.notice_flag = 0		
	self.data_name = nil
end

function SequenceLogo:initialize()
	StartModule( MODULE_NOTICEBOARD )
	SetNoticeBoardParam(self.notice_type, self.notice_flag, "up_sega_logo.sfd", 0.0, 0.0);
end

function SequenceLogo:execute()
	Actor:wait_step( WaitEndModule )

	return MODULE_NOTICE_HAVOK
end


--[[
	SequenceTitle Class
]]
subclass ("SequenceTitle", SequenceBase) {
}

function SequenceTitle:ctor(...)
	SequenceTitle.super.ctor(...)

	self.module_name = MODULE_TITLE
end

function SequenceTitle:initialize()
	StartModule( self.module_name )
	-- ファイルロードリクエスト
--	LoadArchive(self.data_name, self.arch_name)

	-- ストーリーシーケンス削除
	DestroyStory();
end

function SequenceTitle:execute()
--	Actor:wait_step( WaitLoading, {self.data_name} )
	Actor:wait_step( WaitEndModule )
--	UnloadArchive( self.data_name )

	local module = getNextModule();

	if module ~= nil then
		return module;
	else
		local ret = GetEndState()

		if ret == 2 then
			-- オンライン
			return MODULE_ONLINESTAGE;
		elseif ret == 1 then
			-- ムービー
			return MODULE_NOTICE_TEASER;
		else
			return MODULE_STORY;
		end
	end
end


--[[
	SequenceStory Class
]]
subclass ("SequenceStory", SequenceBase) {
}

function SequenceStory:ctor(...)
	SequenceStory.super.ctor(self, ...);

	self.module_name = MODULE_STORY;
	self.prev_module = nil;
end

function SequenceStory:initialize()
	PrintString("Sequence Story Start");
--	StartModule( self.module_name );	-- StartModuleしなければアプリケーション側にモードを用意する必要ない

	-- ストーリーシーケンス開始
	StartStory();
end

function SequenceStory:execute()
	Actor:wait_step( WaitSkipStory );

	PrintString("Sequence Story End");

	if SONICGMI_STAGE_BOOT >= 2 then
		return storyGetNextModuleFromTitle();
	else
		if g_IsDebugSequence == 0 then
			return storyGetNextModuleFromTitle();
		else
			return MODULE_MENU;
		end
	end
end


--[[
	SequenceMenu Class
]]
subclass ("SequenceMenu", SequenceBase) {
}

function SequenceMenu:ctor(...)
	SequenceMenu.super.ctor(self, ...);

	self.module_name = MODULE_MENU;
end

function SequenceMenu:initialize()
	PrintString("Sequence Menu Start");
--	StartModule( self.module_name )	-- StartModuleしなければアプリケーション側にモードを用意する必要ない
end

function SequenceMenu:execute()
	PrintString("Sequence Menu End");
	if g_IsDebugSequence == 0 then
		storySetNextPam();
		return MODULE_PLAYABLEMENU;
	else
		return MODULE_DEBUGMENU;
	end
end


--[[
	SequenceDebugMenu Class
]]
subclass ("SequenceDebugMenu", SequenceBase) {
}

function SequenceDebugMenu:ctor(...)
	SequenceDebugMenu.super.ctor(self, ...);

	self.module_name = MODULE_DEBUGMENU;
end

function SequenceDebugMenu:initialize()
	StartModule( self.module_name );
end

function SequenceDebugMenu:execute()
	Actor:wait_step( WaitEndModule );

	local ret = GetEndState();

	if ret == 0 then
		local module = getNextModule();
		if module == nil then
			return MODULE_STAGE;
		else
			return module;
		end
	else
		return MODULE_TITLE;
	end
end


--[[
	SequencePlayableMenu Class
]]
subclass ("SequencePlayableMenu", SequenceBase) {
}

function SequencePlayableMenu:ctor(...)
	SequencePlayableMenu.super.ctor(self, ...);

	self.module_name = MODULE_PLAYABLEMENU;
--	self.data_name = "pam000";
--	self.arch_name = "pam000.ar";
end

function SequencePlayableMenu:initialize()
	StartModule( self.module_name );
	-- ファイルロードリクエスト
--	LoadArchive(self.data_name, self.arch_name)
end

function SequencePlayableMenu:execute()
--	Actor:wait_step( WaitLoading, {self.data_name} )
	Actor:wait_step( WaitEndModule );
--	UnloadArchive( self.data_name )

	local ret = GetEndState();

	if ret == 0 then
		return storyGetNextModuleFromPam();
	else
		return MODULE_TITLE;
	end
end


--[[
	SequenceStage Class
]]
subclass ("SequenceStage", SequenceBase) {
}

function SequenceStage:ctor(...)
	SequenceStage.super.ctor(self, ...)

	self.module_name = MODULE_STAGE;
	self.stage_name = nil;
end

function SequenceStage:initialize()
	StartModule( self.module_name );
	-- ステージ名取得
	self.stage_name = GetStageName();
--	local arch_name = self.stage_name .. ".ar";
	-- ファイルロードリクエスト
--	LoadArchive(self.stage_name, arch_name)
end

function SequenceStage:execute()
--	Actor:wait_step( WaitLoading, {self.stage_name} )
	Actor:wait_step( WaitEndModule );
--	UnloadArchive( self.stage_name )

	if g_IsDebugSequence == 0 then
		local ret = GetEndState();

		if ret == 0 then
			return storyGetNextModuleFromStage();
		else
			return storyGetNextModuleFromStageAbort();
		end
	else
		return MODULE_MENU;
	end
end


--[[
	SequenceEvent Class
]]
subclass ("SequenceEvent", SequenceBase) {
}

function SequenceEvent:ctor(...)
	SequenceEvent.super.ctor(self, ...)

	self.module_name = MODULE_EVENT;
	self.event_name = nil;
end

function SequenceEvent:initialize()
	StartModule( self.module_name );
	-- イベント名取得
--	self.event_name = GetEventName()
	-- ファイルロードリクエスト
--	LoadArchive(self.stage_name, arch_name)
end

function SequenceEvent:execute()
--	Actor:wait_step( WaitLoading, {self.stage_name} )
	Actor:wait_step( WaitEndModule );
--	UnloadArchive( self.stage_name )

	local module = getNextModule();

	if module ~= nil then
		return module;
	end

	return storyGetNextModuleFromEvent();
end


--[[
	SequenceStageEvent Class
]]
subclass ("SequenceStageEvent", SequenceBase) {
}

function SequenceStageEvent:ctor(...)
	SequenceStageEvent.super.ctor(self, ...)

	self.module_name = MODULE_STAGEEVENT;
	self.stage_name = nil;

	self.from_event_module = false;
end

function SequenceStageEvent:initialize()
	StartModule( self.module_name );

	if s_Sequence.prev_module == MODULE_EVENT then
		self.from_event_module = true;
	end
	-- ステージ名取得
--	self.stage_name = GetStageName();
--	local arch_name = self.stage_name .. ".ar";
	-- ファイルロードリクエスト
--	LoadArchive(self.stage_name, arch_name)
end

function SequenceStageEvent:execute()
--	Actor:wait_step( WaitLoading, {self.stage_name} )
	Actor:wait_step( WaitEndModule );
--	UnloadArchive( self.stage_name )

	if self.from_event_module then
		return MODULE_EVENT;
	else
		return MODULE_MENU;
	end
end


--[[
	SequenceStaffRoll Class
]]
subclass ("SequenceStaffRoll", SequenceBase) {
}

function SequenceStaffRoll:ctor(...)
	SequenceStaffRoll.super.ctor(self, ...)

	self.module_name = MODULE_STAFFROLL;
end

function SequenceStaffRoll:initialize()
	StartModule( self.module_name );
end

function SequenceStaffRoll:execute()
	Actor:wait_step( WaitEndModule );

	local ret = GetEndState();

	if ret == 0 then
		return storyGetNextModuleFromStaffRoll();
	else
		-- Abort
		return MODULE_TITLE;
	end
end


--[[
	SequenceExit Class
]]
subclass ("SequenceExit", SequenceBase) {
}

function SequenceExit:ctor(...)
	SequenceExit.super.ctor(self, ...)

	self.module_name = MODULE_EXIT
end

function SequenceExit:initialize()
	StartModule( self.module_name )
end

function SequenceExit:execute()
	return 0;
end


--[[
	SequenceGenesis Class
]]
subclass ("SequenceGenesis", SequenceBase) {
}

function SequenceGenesis:ctor(...)
	SequenceGenesis.super.ctor(self, ...)

	self.module_name = MODULE_GENESIS
end

function SequenceGenesis:initialize()
	StartModule( self.module_name )
end

function SequenceGenesis:execute()
	Actor:wait_step( WaitEndModule )

	local ret = GetEndState();

	if ret == 0 then
		return MODULE_MENU;
	else
		-- Abort
		return MODULE_TITLE;
	end
end


--[[
	SequenceOnlineStage Class
]]
subclass ("SequenceOnlineStage", SequenceBase) {
}

function SequenceOnlineStage:ctor(...)
	SequenceOnlineStage.super.ctor(self, ...)

	self.module_name = MODULE_ONLINESTAGE
end

function SequenceOnlineStage:initialize()
	StartModule( self.module_name )
end

function SequenceOnlineStage:execute()
	Actor:wait_step( WaitEndModule )

	return MODULE_TITLE;
end


--[[
	SequenceSave Class
]]
subclass ("SequenceSave", SequenceBase) {
}

function SequenceSave:ctor(...)
	SequenceSave.super.ctor(self, ...)

	self.module_name = MODULE_SAVE
end

function SequenceSave:initialize()
	StartModule( self.module_name )
end

function SequenceSave:execute()
	Actor:wait_step( WaitEndModule )

	-- ストーリー終了時のセーブ後はタイトルへ
	return MODULE_TITLE;
end


--[[
	SequenceNoticeBoard Class
]]
subclass ("SequenceNoticeBoard", SequenceBase) {
}

function SequenceNoticeBoard:ctor(...)
	SequenceNoticeBoard.super.ctor(self, ...)

	local t = {...};	-- 要素1はマネージャなので2から使用する

	self.module_name = MODULE_NOTICEBOARD
	self.notice_type = t[2]		-- 0:Logo20  1:Splash  2:Movie  3:NoticeBoard
	self.notice_flag = 0
	if t[3] == true then	-- Enable Skip
		self.notice_flag = self.notice_flag + 1
	end
	if t[4] == true then	-- Show Guide Button
		self.notice_flag = self.notice_flag + 2
	end
	if t[5] == true then	-- Enter BG White
		self.notice_flag = self.notice_flag + 4
	end
	if t[6] == true then	-- Leave BG White
		self.notice_flag = self.notice_flag + 8
	end
	self.data_name = t[7]
	self.disp_time = t[8]

	self.next_module0 = t[9]
	self.next_module1 = t[10]

	self.force_time = 0.0
end

function SequenceNoticeBoard:initialize()
	StartModule( MODULE_NOTICEBOARD )

	SetNoticeBoardParam(self.notice_type, self.notice_flag, self.data_name, self.disp_time, self.force_time);
end

function SequenceNoticeBoard:execute()
	Actor:wait_step( WaitEndModule )

	local ret = GetEndState();

	if ret == 0 then
		return self.next_module0;
	else
		return self.next_module1;
	end
end


--[[
	SequenceNoticeESRB Class
]]
subclass ("SequenceNoticeESRB", SequenceBase) {
}

function SequenceNoticeESRB:ctor(...)
	SequenceNoticeESRB.super.ctor(self, ...)

	local t = {...};

	self.module_name = MODULE_NOTICE_ESRB
	self.notice_type = 3		-- 0:Logo20  1:Splash  2:Movie  3:NoticeESRB
	self.notice_flag = 0
	self.data_name = "ui_nb_esrb"
	self.disp_time = 4.0
	self.force_time = 0.0
	self.show = 0
end

function SequenceNoticeESRB:initialize()
	self.show = DoShowESRB()
	if self.show == 1 then
		StartModule( MODULE_NOTICEBOARD )

		SetNoticeBoardParam(self.notice_type, self.notice_flag, self.data_name, self.disp_time, self.force_time);
	end
end

function SequenceNoticeESRB:execute()
	if self.show == 1 then
		Actor:wait_step( WaitEndModule )
	end

	return MODULE_TITLE;
end


--[[
	SequenceNoticeStereo Class
]]
subclass ("SequenceNoticeStereo", SequenceBase) {
}

function SequenceNoticeStereo:ctor(...)
	SequenceNoticeStereo.super.ctor(self, ...)

	local t = {...};

	self.module_name = MODULE_NOTICE_STEREO
	self.notice_type = 3		-- 0:Logo20  1:Splash  2:Movie  3:NoticeStereo
	self.notice_flag = 1		-- Enable Skip
	self.data_name = "ui_nb_3DArart"
	self.disp_time = 4.0
	self.force_time = 0.0
	self.show = 0
end

function SequenceNoticeStereo:initialize()
	self.show = DoShowNotice3D()
	if self.show == 1 then
		StartModule( MODULE_NOTICEBOARD )

		SetNoticeBoardParam(self.notice_type, self.notice_flag, self.data_name, self.disp_time, self.force_time);
	end
end

function SequenceNoticeStereo:execute()
	if self.show == 1 then
		Actor:wait_step( WaitEndModule )
	end

	return MODULE_LOGO;
end


--[[
	SequenceNoticeTeaser Class
]]
subclass ("SequenceNoticeTeaser", SequenceBase) {
}

function SequenceNoticeTeaser:ctor(...)
	SequenceNoticeTeaser.super.ctor(self, ...)

	local t = {...};

	self.module_name = MODULE_NOTICE_TEASER
	self.notice_type = 2		-- 0:Logo20  1:Splash  2:Movie  3:NoticeBoard
	self.notice_flag = 9		-- Skip & Leave White
	self.data_name = nil
end

function SequenceNoticeTeaser:initialize()
	StartModule( MODULE_NOTICEBOARD )
	SetNoticeBoardParam(self.notice_type, self.notice_flag, "anniv_teaser.sfd", 0.0, 0.0);
end

function SequenceNoticeTeaser:execute()
	Actor:wait_step( WaitEndModule )

	return MODULE_TITLE;
end


--[[
	SequenceStatue Class
]]
subclass ("SequenceStatue", SequenceBase) {
}

function SequenceStatue:ctor(...)
	SequenceStatue.super.ctor(self, ...);

	self.module_name = MODULE_STATUE;
end

function SequenceStatue:initialize()
	StartModule( self.module_name );
end

function SequenceStatue:execute()
	Actor:wait_step( WaitEndModule );

	if g_IsDebugSequence == 0 then
		local ret = GetEndState();

		if ret == 0 then
			return MODULE_PLAYABLEMENU;
		else
			return MODULE_TITLE;
		end
	else
		return MODULE_DEBUGMENU;
	end
end


--[[
	SequenceDebugInit Class
]]
subclass ("SequenceDebugInit", SequenceBase) {
}

function SequenceDebugInit:ctor(...)
	SequenceDebugInit.super.ctor(self, ...);

	self.module_name = MODULE_DEBUGINIT;
end

function SequenceDebugInit:initialize()
	StartModule( self.module_name );
end

function SequenceDebugInit:execute()
	Actor:wait_step( WaitEndModule );

	return MODULE_NOTICE_CESA;
end


--[[
	SequenceNoticeHavok Class
]]
subclass ("SequenceNoticeHavok", SequenceBase) {
}

function SequenceNoticeHavok:ctor(...)
	SequenceNoticeHavok.super.ctor(self, ...)

	local t = {...};

	self.module_name = MODULE_NOTICE_HAVOK
	self.notice_type = 3		-- 0:Logo20  1:Splash  2:Movie  3:NoticeBoard
	self.notice_flag = 0
	self.data_name = "ui_nb_havok"
	self.disp_time = 2.0
	self.force_time = 0.0
	self.show = 0
end

function SequenceNoticeHavok:initialize()
	self.show = DoShowHavok()
	if self.show == 1 then
		StartModule( MODULE_NOTICEBOARD )

		SetNoticeBoardParam(self.notice_type, self.notice_flag, self.data_name, self.disp_time, self.force_time);
	end
end

function SequenceNoticeHavok:execute()
	if self.show == 1 then
		Actor:wait_step( WaitEndModule )
	end

	return MODULE_NOTICE_ESRB;
end


--[[
	SequenceNoticeCesa Class
]]
subclass ("SequenceNoticeCesa", SequenceBase) {
}

function SequenceNoticeCesa:ctor(...)
	SequenceNoticeCesa.super.ctor(self, ...)

	local t = {...};

	self.module_name = MODULE_NOTICE_CESA
	self.notice_type = 3		-- 0:Logo20  1:Splash  2:Movie  3:NoticeBoard
	self.notice_flag = 1		-- Enable Skip
	self.data_name = "ui_nb_cesa"
	self.disp_time = 5.0
	self.show = 0

	local ps3 = IsTargetPS3()
	if ps3 == 1 then
		self.force_time = 2.0
	else
		self.force_time = 0.0
	end
end

function SequenceNoticeCesa:initialize()
	self.show = DoShowCesa()
	if self.show == 1 then
		StartModule( MODULE_NOTICEBOARD )

		SetNoticeBoardParam(self.notice_type, self.notice_flag, self.data_name, self.disp_time, self.force_time);
	end
end

function SequenceNoticeCesa:execute()
	if self.show == 1 then
		Actor:wait_step( WaitEndModule )
	end

	return MODULE_NOTICE_STEREO;
end


