RateMyPurrfessors.Views.ProfessorShow = Backbone.CompositeView.extend({
	initialize: function () {
		this.listenTo(this.model, "sync", this.render);
		this.page = 0;
	},
	
	template: JST["professors/show"],
	
	events: {
		"click a.next": "nextPage",
		"click a.previous": "previousPage"
	},
	
	render: function () {
		if ( this.model.get("avg_professor_ratings") ) {
			var ratings = this.model.professorRatings();
			
			if (!this.allPages) {
				this.ratingsPages(ratings.models);
			}
		
			var renderedContent = this.template({
				professor: this.model,
				ratings: this.allPages[this.page]
			});
		
			this.$el.html(renderedContent);
			
			var that = this;
			
			if ( ratings.length > 0 ) {
				that.renderAverages(ratings)
			
				this.allPages[this.page].each(function (rating) {
					var ratingSubview = new RateMyPurrfessors.Views.ProfessorRatingShow({
						model: rating
					});

					that.addSubview("ul.all_ratings", ratingSubview)
				});
				
				this.paginate();
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
	},
	
	ratingsPages: function (ratings) {
		this.allPages = [];
		var arrayPages = [];
		
		while (ratings.length > 10) {
			arrayPages.push(ratings.slice(0, 10));
			ratings = ratings.slice(10);
		}
		
		arrayPages.push(ratings);
		var that = this
		
		arrayPages.forEach(function (page) {
			var newCollection = new RateMyPurrfessors.Collections.ProfessorRatings();
			newCollection.set(page);
			that.allPages.push(newCollection);
		});
	},
	
	paginate: function () {
		if (this.page !== this.allPages.length - 1) {
			this.$("div.paginate").prepend('<a class="next" href="">Next')
		}
		
		if (this.page !== 0) {
			this.$("div.paginate").prepend('<a class="previous" href="">Prev')
		}
	},
	
	nextPage: function (event) {
		event.preventDefault();
		
		this.page += 1;
		this.render();
	},
	
	previousPage: function (event) {
		event.preventDefault();
		
		this.page -= 1;
		this.render();
	} 
});