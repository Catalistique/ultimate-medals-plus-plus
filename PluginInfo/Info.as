void RenderMenu() {
	if(UI::MenuItem("\\$00f" + Icons::Circle + "\\$7f7 Medals++ Window", "", windowVisible)) {
		windowVisible = !windowVisible;
	}
}
