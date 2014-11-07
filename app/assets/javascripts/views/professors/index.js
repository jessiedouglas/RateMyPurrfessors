RateMyPurrfessors.Views.ProfessorsIndex = Backbone.CompositeView.extend({
	initialize: function () {
		this.page = 0;
	},
	
	template: JST["professors/index"],
	
	events: {
		"keyup #match": "search",
		"click a.next": "nextPage",
		"click a.previous": "previousPage",
		'click a[href="#/professors/new"]': "newProfessor",
		"click button.cancel_new": "cancelNew"
	},
	
	render: function () {
		if (!this.allPages) {
			this.allPages = this.pagesList(this.collection);
		}
		
		var renderedContent = this.template({
			professors: this.allPages[this.page]
		});
		
		this.$el.html(renderedContent);
		
		this.paginate();
		
		return this;
	},
	
	search: function (event) {
		event.preventDefault();
		var $currentTarget = $(event.currentTarget);
		
		var match = $currentTarget.val();
		var that = this;
		
		if (match.length > 2) {
			$.ajax({
				url: "api/professors/search",
				dataType: "json",
				method: "GET",
				data: { match: match },
				success: function (resp) {
					that.$("section.professors_list > h1").text("Professors matching " + match + ":");
					that.renderSearchResults(resp, true);
					that.searching = true;
				}
			});
		}
	},
	
	renderSearchResults: function (professors, is_first_time) {
		if (is_first_time) {
			this.page = 0;
			this.allPages = this.pagesList(professors);
		}
		
		// var collection = new RateMyPurrfessors.Collections.Professors(professors);
		var resultsView = new RateMyPurrfessors.Views.SearchResults({
			type: "professors",
			collection: this.allPages[this.page]
		});
		
		this.$("section.professors_list > article.professors_list").empty();
		
		this.addSubview("section.professors_list > article.professors_list", resultsView);
		
		this.paginate();
	},
	
	pagesList: function (ratings) {
		var collectionPages = [];
		var arrayPages = [];
		
		while (ratings.length > 20) {
			arrayPages.push(ratings.slice(0, 20));
			ratings = ratings.slice(20);
		}
		
		arrayPages.push(ratings);
		
		arrayPages.forEach(function (page) {
			var newCollection = new RateMyPurrfessors.Collections.Professors();
			newCollection.set(page);
			collectionPages.push(newCollection);
		});
		
		return collectionPages;
	},
	
	paginate: function () {
		this.$("div.paginate").empty();
		
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
		
		if (this.searching) {
			this.renderSearchResults(null, false);
		} else {
			this.render();
		}
	},
	
	previousPage: function (event) {
		event.preventDefault();
		
		this.page -= 1;
		
		if (this.searching) {
			this.renderSearchResults(null, false);
		} else {
			this.render();
		}
	}, 
	
	newProfessor: function (event) {
		event.preventDefault();
		
		this.newProfessorSubview = new RateMyPurrfessors.Views.ProfessorsNew();
		
		this.$("div.new_professor").empty();
		
		this.addSubview("div.new_professor", this.newProfessorSubview);
	},
	
	cancelNew: function (event) {
		event.preventDefault();
		
		this.newProfessorSubview.remove();
		
		this.$("div.new_professor").append("<p>Can't find your professor?");
		this.$("div.new_professor > p").append('<a href="#/professors/new">Add a new one!</a>');
	}
});