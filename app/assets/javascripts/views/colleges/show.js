RateMyPurrfessors.Views.CollegeShow = Backbone.CompositeView.extend({
	initialize: function () {
		this.page = 0;
	},
	
	template: JST["colleges/show"],
	
	events: {
		"click a.next": "nextPage",
		"click a.previous": "previousPage",
		"click a.new_college_rating": "checkUser"
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
			ratings: this.allPages[this.page],
			hasAlreadyRated: this.hasAlreadyRated()
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
		
		while (ratings.length > 5) {
			arrayPages.push(ratings.slice(0, 5));
			ratings = ratings.slice(5);
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
			this.$("div.paginate").prepend('<a class="next" href="">Next &#9654;')
		}
		
		if (this.page !== 0) {
			this.$("div.paginate").prepend('<a class="previous" href="">&#9664; Prev')
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
	},
	
	checkUser: function (event) {
		event.preventDefault();
		
		if (RateMyPurrfessors.currentUser.get("id")) {
			Backbone.history.navigate("#/colleges/" + this.model.get("id") + "/college_ratings/new", {trigger: true});
		} else {
			this.$("a.new_college_rating").html("Please log in");
			this.$("a.new_college_rating").css("background", "#ff0000");
		}
	},
	
	hasAlreadyRated: function () {
		var ratings = this.model.collegeRatings();
		var raterIds = [];
		
		ratings.each(function (rating) {
			raterIds.push(rating.get("rater_id"));
		});
		
		var currentId = RateMyPurrfessors.currentUser.get("id");
		
		if (currentId) {
			if (raterIds.indexOf(currentId) === -1) {
				return false;
			} else {
				var rating = ratings.at(raterIds.indexOf(currentId));
				return rating.get("id");
			}
		} else {
			return false;
		}
	}
});