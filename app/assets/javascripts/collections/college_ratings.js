RateMyPurrfessors.Collections.CollegeRatings = Backbone.Collection.extend({
	url: "api/college_ratings",
	model: RateMyPurrfessors.Models.CollegeRating,
	
	initialize: function (options) {
		this.college = options.college
	}, 
	
	comparator: function (rating) {
		return -Date.parse(rating.get("updated_at"));
	}
});