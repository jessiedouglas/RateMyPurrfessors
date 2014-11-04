RateMyPurrfessors.Views.ProfessorShow = Backbone.CompositeView.extend({
	template: JST["professors/show"],
	
	initialize: function () {
		this.listenTo(this.model, "sync", this.render);
	},
	
	render: function () {
		if ( this.model.get("avg_professor_ratings") ) {
			var ratings = this.model.professorRatings();
		
			var renderedContent = this.template({
				professor: this.model,
				ratings: ratings
			});
		
			this.$el.html(renderedContent);
			
			var that = this;
			
			if ( ratings.length > 0 ) {
				that.renderAverages(ratings)
			
				ratings.each(function (rating) {
					var ratingSubview = new RateMyPurrfessors.Views.ProfessorRatingShow({
						model: rating
					});

					that.addSubview("ul.all_ratings", ratingSubview)
				});
			}
		}
		
		return this;
	},
	
	renderAverages: function (ratings) {
		var avg_ratings = this.model.get("avg_professor_ratings");
	
		var avgSubview = new RateMyPurrfessors.Views.ProfessorAverages({
			collection: ratings,
			avg_ratings: avg_ratings
		});
		this.$("section.professor_averages").empty();
		this.addSubview("section.professor_averages", avgSubview);
	}
});