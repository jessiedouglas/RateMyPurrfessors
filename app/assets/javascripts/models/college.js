RateMyPurrfessors.Models.College = Backbone.Model.extend({
	urlRoot: "api/colleges",
	
	parse: function (response) {
		if (response.college_ratings) {
			this.collegeRatings().set(response.college_ratings, { parse: true });
			delete response.college_ratings;
		}
		
		if (response.professors) {
			this.professors().set(response.professors, { parse: true });
			delete response.professors;
		}
		
		return response;
	},
	
	collegeRatings: function () {
		if (!this._collegeRatings) {
			this._collegeRatings = new RateMyPurrfessors.Collections.CollegeRatings( [], {
				college: this
			});
		}
		
		return this._collegeRatings;
	},
	
	professors: function () {
		if (!this._professors) {
			this._professors = new RateMyPurrfessors.Collections.Professors( [], {
				college: this
			});
		}
		
		return this._professors;
	}
});