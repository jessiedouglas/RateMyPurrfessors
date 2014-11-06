RateMyPurrfessors.Views.CollegeShow = Backbone.CompositeView.extend({
	initialize: function () {
		this.page = 0;
	},
	
	template: JST["colleges/show"],
	
	events: {
		"click a.next": "nextPage",
		"click a.previous": "previousPage"
	},
	
	render: function () {
		var professors = this.model.professors();
		var ratings = this.model.collegeRatings();
		
		if (!this.allPages) {
			this.ratingsPages(ratings.models);
		}
		
		var renderedContent = this.template({
			college: this.model,
			professors: professors,
			ratings: this.allPages[this.page]
		});
		this.$el.html(renderedContent);
		
		if ( ratings.length > 0 ) {
			this.renderAverages(ratings);
			
			this.allPages[this.page].each(function (rating) {
				var ratingSubview = new RateMyPurrfessors.Views.CollegeRatingShow({
					model: rating
				});
			
				this.addSubview("ul.all_ratings", ratingSubview);
			}.bind(this));
			
			this.paginate();
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
			var newCollection = new RateMyPurrfessors.Collections.CollegeRatings();
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