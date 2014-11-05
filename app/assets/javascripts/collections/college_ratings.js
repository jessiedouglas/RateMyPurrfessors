RateMyPurrfessors.Collections.CollegeRatings = Backbone.Collection.extend({
	url: "api/college_ratings",
	model: RateMyPurrfessors.Models.CollegeRating,
	
	comparator: function (rating) {
		return -Date.parse(rating.get("updated_at"));
	},
	
	getOrFetch: function (id) {
		var college_rating = this.get(id);
		
		if (!college_rating) {
			college_rating = new RateMyPurrfessors.Models.CollegeRatings({ id: id });
			college_rating.fetch({
				success: function () {
					this.add(college_rating);
				}
			});
		} else {
			college_rating.fetch();
		}
		
		return college_rating;
	}
});