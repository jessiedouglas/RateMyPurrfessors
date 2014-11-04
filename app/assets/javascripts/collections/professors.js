RateMyPurrfessors.Collections.Professors = Backbone.Collection.extend({
	url: "api/professors",
	model: RateMyPurrfessors.Models.Professor,
	
	initialize: function (options) {
		if (options["college"]) {
			this.college = options.college;
		}
	},
	
	getOrFetch: function (id) {
		var professor = this.get(id);
		
		if (!professor) {
			professor.fetch();
		} else {
			professor = new RateMyPurrfessors.Models.Professor({ id: id });
			professor.fetch({
				success: function () {
					this.add(professor);
				}.bind(this)
			});
		}
		
		return professor;
	},
	
	comparator: function (professor1, professor2) {
		if (professor1.get("last_name") < professor2.get("last_name")) {
			return -1;
		} else if (professor1.get("last_name") > professor2.get("last_name")) {
			return 1;
		} else if (professor1.get("first_name") < professor2.get("first_name")) {
			return -1;
		} else if (professor1.get("first_name") > professor2.get("first_name")) {
			return 1;
		} else {
			return 0;
		}
	}
});