RateMyPurrfessors.Views.CollegeAverages = Backbone.View.extend({
	initialize: function (options) {
		this.avg_ratings = options.avg_ratings
	},
	
	template: JST["colleges/averages"],
	
	render: function () {
		debugger
		var renderedContent = this.template({
				ratings: this.collection,
				avg_reputation: this.avg_ratings.avg_reputation,
				avg_location: this.avg_ratings.avg_location,
				avg_opportunities: this.avg_ratings.avg_opportunities,
				avg_library: this.avg_ratings.avg_library,
				avg_grounds_and_common_areas: this.avg_ratings.avg_grounds_and_common_areas,
				avg_internet: this.avg_ratings.avg_internet,
				avg_food: this.avg_ratings.avg_food,
				avg_clubs: this.avg_ratings.avg_clubs,
				avg_social: this.avg_ratings.avg_social,
				avg_happiness: this.avg_ratings.avg_happiness,
				avg_overall: this.avg_ratings.avg_overall,
			});
	
		this.$el.html(renderedContent);
		
		return this;
	}
});