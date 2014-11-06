RateMyPurrfessors.Views.Search = Backbone.CompositeView.extend({
	template: JST["root/search"],
	
	events: {
		"keyup input#match": "search",
		"click a.next": "nextPage",
		"click a.previous": "previousPage"
	},
	
	render: function () {
		var renderedContent = this.template();
		this.$el.html(renderedContent);
		
		var match = window.location.search.slice(7);
		var that = this;
		
		$.ajax({
			url: "api/search",
			dataType: "json",
			method: "GET",
			data: { match: match },
			success: function (resp) {
				that.$("section.matches_list > h1").text("Colleges and Professors matching " + match + ":");
				that.renderSearchResults(resp, true);
			}
		});
		
		return this;
	},
	
	search: function (event) {
		event.preventDefault();
		var $currentTarget = $(event.currentTarget);
		
		var match = $currentTarget.val();
		console.log(match);
		var that = this;
		
		if (match.length > 2) {
			$.ajax({
				url: "api/search",
				dataType: "json",
				method: "GET",
				data: { match: match },
				success: function (resp) {
					that.$("section.matches_list > h1").text("Colleges and Professors matching " + match + ":");
					that.renderSearchResults(resp, true);
				}
			});
		}
	},
	
	renderSearchResults: function (search_results, is_first_time) {
		if (is_first_time) {
			this.page = 0;
			this.allPages = this.pagesList(search_results);
		}
		
		var resultsView = new RateMyPurrfessors.Views.SearchResults({
			type: "mixed",
			collection: this.allPages[this.page]
		})
		
		this.$("section.matches_list > article.matches_list").empty();
		
		this.addSubview("section.matches_list > article.matches_list", resultsView);
		
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
			var newCollection = new RateMyPurrfessors.Collections.SearchResults();
			newCollection.set(page);
			collectionPages.push(newCollection);
		});
		
		return collectionPages;
	},
	
	paginate: function () {
		this.$("div.paginate").empty();
		
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
		this.renderSearchResults(null, false);
	},
	
	previousPage: function (event) {
		event.preventDefault();
		
		this.page -= 1;
		this.renderSearchResults(null, false);
	} 
});