[Setting category="Additional Info" name="Show Map Name"]
bool showMapName = false;

[Setting category="Additional Info" name="Show Author Name"]
bool showAuthorName = false;

[Setting category="Additional Info" name="Limit Map Name length"
description="If the map name is too long, it will automatically scroll to still make it readable."]
bool limitMapNameLength = true;

[Setting category="Additional Info" name="Limit Map Name length width"
description="Width in pixels to limit the map name length by. This requires \"Limit Map Name length\" to be enabled."
min="100" max="400"]
int limitMapNameLengthWidth = 275;

[Setting category="Additional Info" name="Show Map Comment on Hover"
description="An 'i' icon will appear next to the map name or author name, if a comment is available."]
bool showComment = false;

[Setting category="Additional Info" name="Show Medal Icons"]
bool showMedalIcons = true;

[Setting category="Additional Info" name="Show Personal Best Delta Time"]
bool showPbestDelta = false;

[Setting category="Additional Info" name="Show Personal Best Negative Delta Time"]
bool showPbestDeltaNegative = true;
