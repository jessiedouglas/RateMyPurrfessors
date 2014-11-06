RateMyPurrfessors.Collections.MixedRatings = Backbone.Collection.extend({
	model: function (attrs) {
		var type = attrs.type;
		
		if (type === "college_rating") {
			return new RateMyPurrfessors.Models.CollegeRating(attrs);
		} else if (type === "professor_rating") {
			return new RateMyPurrfessors.Models.ProfessorRating(attrs);
		} else {
			return new Backbone.Model(attrs);
		}
	}, 
	
	comparator: function (rating) {
		return -Date.parse(rating.get("updated_at"));
	}
});