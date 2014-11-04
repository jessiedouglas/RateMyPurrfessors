RateMyPurrfessors.Views.ProfessorAverages = Backbone.View.extend({
	initialize: function (options) {
		this.avg_ratings = options.avg_ratings;
	},
	
	template: JST["professors/averages"],
	
	render: function () {
		var renderedContent = this.template({
			ratings: this.collection,
			avg_helpfulness: this.avg_ratings.avg_helpfulness,
			avg_clarity: this.avg_ratings.avg_clarity,
			avg_easiness: this.avg_ratings.avg_easiness,
			avg_hotness: this.avg_ratings.avg_hotness
		});
		
		this.$el.html(renderedContent);
		
		return this;
	}
});