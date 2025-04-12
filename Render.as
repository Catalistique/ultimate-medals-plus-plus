void Render() {
	auto app = cast<CTrackMania>(GetApp());

	auto map = app.RootMap;

	if(hideWithIFace && !UI::IsGameUIVisible()) {
		return;
	}

	if(hideWithOverlay && !UI::IsOverlayShown()) {
		return;
	}

	if(windowVisible && map !is null && map.MapInfo.MapUid != "" && app.Editor is null) {
		if(lockPosition) {
			UI::SetNextWindowPos(int(anchor.x), int(anchor.y), UI::Cond::Always);
		} else {
			UI::SetNextWindowPos(int(anchor.x), int(anchor.y), UI::Cond::FirstUseEver);
		}

		int windowFlags = UI::WindowFlags::NoTitleBar | UI::WindowFlags::NoCollapse | UI::WindowFlags::AlwaysAutoResize | UI::WindowFlags::NoDocking;
		if (!UI::IsOverlayShown()) {
				windowFlags |= UI::WindowFlags::NoInputs;
		}

		UI::PushFont(font);

		UI::Begin("Medals++", windowFlags);

		if(!lockPosition) {
			anchor = UI::GetWindowPos();
		}

		bool hasComment = string(map.MapInfo.Comments).Length > 0;

		UI::BeginGroup();
		if((showMapName || showAuthorName) && UI::BeginTable("header", 1, UI::TableFlags::SizingFixedFit)) {
			if(showMapName) {
				UI::TableNextRow();
				UI::TableNextColumn();
				string mapNameText = "";
				mapNameText += StripFormatCodes(map.MapInfo.Name);
				if (hasComment && !showAuthorName) {
					mapNameText += " \\$68f" + Icons::InfoCircle;
				}
				if (limitMapNameLength) {
					vec2 size = Draw::MeasureString(mapNameText);

					const uint64 timeOffsetStart = 1000;
					const uint64 timeOffsetEnd = 2000;
					const int scrollSpeed = 20; // Lower is faster

					if (size.x > limitMapNameLengthWidth) {
						auto dl = UI::GetWindowDrawList();
						vec2 cursorPos = UI::GetWindowPos() + UI::GetCursorPos();

						// Create a dummy for the text
						UI::Dummy(vec2(limitMapNameLengthWidth, size.y));

						// If the text is hovered, reset now
						if (UI::IsItemHovered()) {
							limitMapNameLengthTime = Time::Now;
							limitMapNameLengthTimeEnd = 0;
						}

						vec2 textPos = vec2(0, 0);

						// Move the text forwards after the start time has passed
						uint64 timeOffset = Time::Now - limitMapNameLengthTime;
						if (timeOffset > timeOffsetStart) {
							uint64 moveTimeOffset = timeOffset - timeOffsetStart;
							textPos.x = -(moveTimeOffset / scrollSpeed);
						}

						// Stop moving when we've reached the end
						if (textPos.x < -(size.x - limitMapNameLengthWidth)) {
							textPos.x = -(size.x - limitMapNameLengthWidth);

							// Begin waiting for the end time
							if (limitMapNameLengthTimeEnd == 0) {
								limitMapNameLengthTimeEnd = Time::Now;
							}
						}

						// Go back to the starting position after the end time has passed
						if (limitMapNameLengthTimeEnd > 0) {
							uint64 endTimeOffset = Time::Now - limitMapNameLengthTimeEnd;
							if (endTimeOffset > timeOffsetEnd) {
								limitMapNameLengthTime = Time::Now;
								limitMapNameLengthTimeEnd = 0;
							}
						}

						// Draw the map name
						vec4 rectBox = vec4(cursorPos.x, cursorPos.y, limitMapNameLengthWidth, size.y);
						dl.PushClipRect(rectBox, true);
						dl.AddText(cursorPos + textPos, vec4(1, 1, 1, 1), mapNameText);
						dl.PopClipRect();
					} else {
						// It fits, so we can render it normally
						UI::Text(mapNameText);
					}
				} else {
					// We don't care about the max length, so we render it normally
					UI::Text(mapNameText);
				}
			}
			if(showAuthorName) {
				UI::TableNextRow();
				UI::TableNextColumn();
				string authorNameText = "\\$888by " + StripFormatCodes(map.MapInfo.AuthorNickName);
				if (hasComment) {
					authorNameText += " \\$68f" + Icons::InfoCircle;
				}
				UI::Text(authorNameText);
			}
			UI::EndTable();
		}

		int numCols = 2; // name and time columns are always shown
		if(showMedalIcons) numCols++;
		if(showPbestDelta) numCols++;

		if(UI::BeginTable("table", numCols, UI::TableFlags::SizingFixedFit)) {
			if(showHeader) {
				UI::TableNextRow();

				if (showMedalIcons) {
					UI::TableNextColumn();
				}

				UI::TableNextColumn();
				setMinWidth(0);
				UI::Text("Medal");

				UI::TableNextColumn();
				setMinWidth(timeWidth);
				UI::Text("Time");

				if (showPbestDelta) {
					UI::TableNextColumn();
					setMinWidth(deltaWidth);
					UI::Text("Delta");
				}
			}

			for(uint i = 0; i < times.Length; i++) {
				if(times[i].medalName == "Champion" && !championActualVisibility) {
					continue;
				}
				if(times[i].medalName == "Warrior" && !warriorActualVisibility) {
					continue;
				}
				if(times[i].hidden) {
					continue;
				}
				UI::TableNextRow();

				if(showMedalIcons) {
					UI::TableNextColumn();
					times[i].DrawIcon();
				}

				UI::TableNextColumn();
				times[i].DrawName();

				UI::TableNextColumn();
				times[i].DrawTime();

				if (showPbestDelta) {
					UI::TableNextColumn();
					times[i].DrawDelta(pbest);
				}
			}

			UI::EndTable();
		}
		UI::EndGroup();

		if(hasComment && showComment && UI::IsItemHovered()) {
			UI::BeginTooltip();
			UI::PushTextWrapPos(200);
			UI::TextWrapped(map.MapInfo.Comments);
			UI::PopTextWrapPos();
			UI::EndTooltip();
		}

		UI::End();

		UI::PopFont();
	}
}

void setMinWidth(int width) {
	UI::PushStyleVar(UI::StyleVar::ItemSpacing, vec2(0, 0));
	UI::Dummy(vec2(width, 0));
	UI::PopStyleVar();
}

void LoadFont() {
	string fontFaceToLoad = "DroidSans.ttf";
	if(fontFaceToLoad != loadedFontFace || fontSize != loadedFontSize) {
		@font = UI::LoadFont(fontFaceToLoad, fontSize, -1, -1, true, true, true);
		if(font !is null) {
			loadedFontFace = fontFaceToLoad;
			loadedFontSize = fontSize;
		}
	}
}
