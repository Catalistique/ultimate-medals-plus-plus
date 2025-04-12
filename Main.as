Medal@ champion = Medal(championText, 6, -7, "\\$c13");
Medal@ warrior = Medal(warriorText, 5, -6, "\\$16a");
Medal@ author = Medal(authorText, 4, -5, "\\$071");
Medal@ gold = Medal(goldText, 3, -4, "\\$db4");
Medal@ silver = Medal(silverText, 2, -3, "\\$899");
Medal@ bronze = Medal(bronzeText, 1, -2, "\\$964");
Medal@ pbest = Medal(pbestText, 0, -1, "\\$444", "\\$0ff");

array<Medal@> times = {champion, warrior, author, gold, silver, bronze, pbest};

bool campaignMap = false;

int timeWidth = 53;
int deltaWidth = 60;

string loadedFontFace = "";
int loadedFontSize = 0;
UI::Font@ font = null;

uint64 limitMapNameLengthTime = 0;
uint64 limitMapNameLengthTimeEnd = 0;


bool held = false;
void OnKeyPress(bool down, VirtualKey key)
{
	if(key == windowVisibleKey && !held)
	{
		windowVisible = !windowVisible;
	}
	held = down;
}

void UpdateHidden() {
	champion.hidden = !showChampion;
	championActualVisibility = showChampion;

	warrior.hidden = !showWarrior;
	warriorActualVisibility = showWarrior;

	author.hidden = !showAuthor;
	gold.hidden = !showGold;
	silver.hidden = !showSilver;
	bronze.hidden = !showBronze;
	pbest.hidden = !showPbest;
}

void UpdateText() {
	champion.medalName = championText;
	warrior.medalName = warriorText;
	author.medalName = authorText;
	gold.medalName = goldText;
	silver.medalName = silverText;
	bronze.medalName = bronzeText;
	pbest.medalName = pbestText;
}

void OnSettingsChanged() {
	UpdateHidden();
	UpdateText();
}

void Main() {
	NadeoServices::AddAudience("NadeoLiveServices");

	while (!NadeoServices::IsAuthenticated("NadeoLiveServices")) {
	  	yield();
	}

	auto app = cast<CTrackMania>(GetApp());
	auto network = cast<CTrackManiaNetwork>(app.Network);


	LoadFont();
	UpdateHidden();
	UpdateText();

	string currentMapUid = "";

	while(true) {
		auto map = app.RootMap;

		if(windowVisible && map !is null && map.MapInfo.MapUid != "" && app.Editor is null) {
			if(currentMapUid != map.MapInfo.MapUid) {
				sleep(1000);

				author.time = map.TMObjective_AuthorTime;
				gold.time = map.TMObjective_GoldTime;
				silver.time = map.TMObjective_SilverTime;
				bronze.time = map.TMObjective_BronzeTime;

				// prevent 'leaking' a stale PB between maps
				pbest.time = -1;
				pbest.medalID = 0;

				currentMapUid = map.MapInfo.MapUid;

				limitMapNameLengthTime = Time::Now;
				limitMapNameLengthTimeEnd = 0;

				UpdateHidden();

#if DEPENDENCY_CHAMPIONMEDALS
	uint cm_time = ChampionMedals::GetCMTime();
	if (cm_time == 0) {
	    championActualVisibility = false;
	} else {
		champion.time = cm_time;
	}
#else
	championActualVisibility = false;
#endif

#if DEPENDENCY_WARRIORMEDALS
	uint wm_time = WarriorMedals::GetWMTime();
	if (wm_time == 0) {
	    warrior.hidden = false;
	} else {
	    warrior.time = wm_time;
	}
#else
	warriorActualVisibility = false;
#endif
			}

			if(network.ClientManiaAppPlayground !is null) {
				auto userMgr = network.ClientManiaAppPlayground.UserMgr;
				MwId userId;
				if (userMgr.Users.Length > 0) {
					userId = userMgr.Users[0].Id;
				} else {
					userId.Value = uint(-1);
				}

				auto scoreMgr = network.ClientManiaAppPlayground.ScoreMgr;
				// from: OpenplanetNext\Extract\Titles\Trackmania\Scripts\Libs\Nadeo\TMNext\TrackMania\Menu\Constants.Script.txt
				// ScopeType can be: "Season", "PersonalBest"
				// GameMode can be: "TimeAttack", "Follow", "ClashTime"
				pbest.time = scoreMgr.Map_GetRecord_v2(userId, map.MapInfo.MapUid, "PersonalBest", "", "TimeAttack", "");
				pbest.medalID = CalcMedal();
			}
			else {
				pbest.time = -1;
				pbest.medalID = 0;
			}

		} else if(map is null || map.MapInfo.MapUid == "") {
			champion.time = -7;
			warrior.time = -6;
			author.time = -5;
			gold.time = -4;
			silver.time = -3;
			bronze.time = -2;
			pbest.time = -1;
			pbest.medalID = 0;

			currentMapUid = "";
		}

		times.SortAsc();

		sleep(500); // Avoid too many updates
	}
}

uint CalcMedal() {
	if (pbest.time > 0) {
		if(pbest <= champion && champion.time > 0 && championActualVisibility) {
			pbest.medalColor = champion.medalColor;
			return 6;
		} else if(pbest <= warrior && warrior.time > 0 && warriorActualVisibility) {
			pbest.medalColor = warrior.medalColor;
			return 5;
		} else if(pbest <= author) {
			pbest.medalColor = author.medalColor;
			return 4;
		} else if(pbest <= gold) {
			pbest.medalColor = gold.medalColor;
			return 3;
		} else if(pbest <= silver) {
			pbest.medalColor = silver.medalColor;
			return 2;
		} else if(pbest <= bronze) {
			pbest.medalColor = bronze.medalColor;
			return 1;
		} else {
			pbest.medalColor = "\\$0ff";
			return 0;
		}
	} else {
		return 0;
	}
}
