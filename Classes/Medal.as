class Medal {
	string medalName; // The name of the medal
	uint medalID; // The medal id (Higher is harder to get)
	int time; // The time of the medal (in milliseconds)
	string medalColor; // The color of the medal
	string color; // The color prefix for the name
	bool hidden; // Whether the record is hidden or not
	string icon = Icons::Circle;

	// &in means if blank, use the default value
	Medal(const string &in name = "Unknown", uint medalID = 0, int time = -1,
			const string &in medalColor = "\\$fff", string &in color = "\\$fff") {
		this.medalName = name;
		this.medalID = medalID;
		this.time = time;
		this.medalColor = medalColor;
		this.color = color;
		this.hidden = false;
	}

	void DrawIcon() {
		UI::Text(this.medalColor + this.icon);
	}

	void DrawName() {
		UI::Text(this.color + this.medalName);
	}

	void DrawTime() {
		UI::Text(this.color + (this.time > 0 ? Time::Format(this.time) : "-:--.---"));
	}

	void DrawDelta(Medal@ other) {
		if (this is other || other.time <= 0) {
			return;
		}

		int delta = other.time - this.time;
		if (delta < 0 && showPbestDeltaNegative) {
			UI::Text("\\$" + negativeColor + "-" + Time::Format(delta * -1));
		} else if (delta > 0) {
			UI::Text("\\$" + positiveColor + "+" + Time::Format(delta));
		} else {
			UI::Text("\\$  " + neutralColor + "0:00.000");
		}
	}

	/**
	 * Compare this medal with another medal.
	 *
	 * @param other The other medal to compare with.
	 * @return -1 if this medal is faster, 0 if they are equal, 1 if the other medal is faster.
	 */
	int opCmp(Medal@ other) {
		// If one of them is negative, the other is considered faster
		if (this.time >= 0 && other.time < 0) return -1;
		if (this.time < 0 && other.time >= 0) return 1;

		// If both have the same sign, compare the times)
		int64 diff = int64(this.time) - int64(other.time);

		if (diff == 0) {
			return 0;
		} else if (diff > 0) {
			return 1;
		} else {
			return -1;
		}
	}
}