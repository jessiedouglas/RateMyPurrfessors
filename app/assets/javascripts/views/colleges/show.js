RateMyPurrfessors.Views.CollegeShow = Backbone.CompositeView.extend({
	template: JST["colleges/show"],
	
	render: function () {
		var professors = this.model.professors();
		
		var ratings = this.model.collegeRatings();
		
		var renderedContent = this.template({
			college: this.model,
			professors: professors,
			ratings: ratings
		});
		this.$el.html(renderedContent);
		
		if ( ratings.length > 0 ) {
			this.renderAverages(ratings);
			
			ratings.each(function (rating) {
				var ratingSubview = new RateMyPurrfessors.Views.CollegeRatingShow({
					model: rating
				});
			
				this.addSubview("ul.all_ratings", ratingSubview);
			}.bind(this));
		}
		
		return this;
	},
	
	renderAverages: function (ratings) {
		var avg_ratings = this.model.get("avg_college_ratings");
	
		var avgSubview = new RateMyPurrfessors.Views.CollegeAverages({
			collection: ratings,
			avg_ratings: avg_ratings
		});
		this.$("section.college_averages").empty();
		this.addSubview("section.college_averages", avgSubview);
	}
});