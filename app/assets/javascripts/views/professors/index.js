RateMyPurrfessors.Views.ProfessorsIndex = Backbone.CompositeView.extend({
	template: JST["professors/index"],
	
	events: {
		"keyup #match": "search"
	},
	
	render: function () {
		var renderedContent = this.template({
			professors: this.collection
		});
		
		this.$el.html(renderedContent);
		
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
					that.renderSearchResults(resp);
				}
			});
		}
	},
	
	renderSearchResults: function (professors) {
		var collection = new RateMyPurrfessors.Collections.Professors(professors);
		var resultsView = new RateMyPurrfessors.Views.SearchResults({
			type: "professors",
			collection: collection
		})
		
		this.$("section.professors_list > article.professors_list").empty();
		
		this.addSubview("section.professors_list > article.professors_list", resultsView);
	}
});