RateMyPurrfessors.Views.Search = Backbone.CompositeView.extend({
	template: JST["root/search"],
	
	events: {
		"keyup input#match": "search"
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
				var searchResults = new RateMyPurrfessors.Collections.SearchResults(resp);
				that.$("section.matches_list > h1").text("Colleges and Professors matching " + match + ":");
				that.renderSearchResults(searchResults);
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
					var searchResults = new RateMyPurrfessors.Collections.SearchResults(resp);
					that.$("section.matches_list > h1").text("Colleges and Professors matching " + match + ":");
					that.renderSearchResults(searchResults);
				}
			});
		}
	},
	
	renderSearchResults: function (search_results) {
		var resultsView = new RateMyPurrfessors.Views.SearchResults({
			type: "mixed",
			collection: search_results
		})
		
		this.$("section.matches_list > article.matches_list").empty();
		
		this.addSubview("section.matches_list > article.matches_list", resultsView);
	}
});