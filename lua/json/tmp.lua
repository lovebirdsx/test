return {
	dialog = {
		{
			layout = {
				col = 2
			},
			type = "zz1",
			widget = {
				{
					key = "name",
					title = "Name",
					type = "text"
				},
				{
					choices = {
						{
							title = "enemy",
							value = "enemy"
						},
						{
							title = "neutral",
							value = "neutral"
						},
						{
							title = "ally",
							value = "ally"
						}
					},
					default = 1,
					key = "camp",
					title = "camp",
					type = "choice"
				},
				{
					choices = {
						{
							title = "SaleEllickMember",
							value = "SaleEllickMember"
						},
						{
							title = "SaleHenry",
							value = "SaleHenry"
						}
					},
					key = "type",
					title = "type",
					type = "choice"
				},
				{
					choices = {
						{
							title = "squad1",
							value = "squad1"
						}
					},
					key = "squad",
					title = "squad",
					type = "choice"
				},
				{
					default = false,
					key = "leader",
					title = "leader",
					type = "check box"
				},
				{
					choices = {
						{
							title = "North",
							value = "n"
						},
						{
							title = "NorthEast",
							value = "ne"
						},
						{
							title = "East",
							value = "e"
						},
						{
							title = "SouthEast",
							value = "se"
						},
						{
							title = "South",
							value = "s"
						},
						{
							title = "SouthWest",
							value = "sw"
						},
						{
							title = "West",
							value = "w"
						},
						{
							title = "NorthWest",
							value = "nw"
						}
					},
					key = "dir",
					title = "dir",
					type = "choice"
				},
				{
					default = false,
					key = "scene_ai",
					title = "SceneAI",
					type = "check box"
				},
				{
					default = false,
					key = "god_sight",
					title = "GodSight",
					type = "check box"
				}
			}
		},
		{
			layout = {
				col = 1
			},
			type = "zz2",
			widget = {
				{
					key = "name",
					title = "Name",
					type = "text"
				},
				{
					default = false,
					key = "god_sight",
					title = "GodSight",
					type = "check box"
				}
			}
		}
	}
}