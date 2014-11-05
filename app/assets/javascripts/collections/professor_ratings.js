RateMyPurrfessors.Collections.ProfessorRatings = Backbone.Collection.extend({
	url: "api/professor_ratings",
	model: RateMyPurrfessors.Models.ProfessorRating,
	
	initialize: function (options) {
		this.professor = options.professor;
	},
	
	comparator: function (rating) {
		return -Date.parse(rating.get("updated_at"));
	},
})