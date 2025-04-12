[Setting category="Display Settings" name="Window visible"
description="To adjust the position of the window, click and drag while the Openplanet overlay is visible."]
bool windowVisible = true;

[Setting category="Display Settings" name="Window visibility hotkey"]
VirtualKey windowVisibleKey = VirtualKey(0);

[Setting category="Display Settings" name="Hide when the game interface is hidden"]
bool hideWithIFace = false;

[Setting category="Display Settings" name="Hide when the Openplanet overlay is hidden"]
bool hideWithOverlay = false;

[Setting category="Display Settings" name="Window position"]
vec2 anchor = vec2(0, 170);

[Setting category="Display Settings" name="Lock window position"]
bool lockPosition = false;

[Setting category="Display Settings" name="Font face"]
string fontFace = "";

[Setting category="Display Settings" name="Font size" min=8 max=48]
int fontSize = 16;
