RateMyPurrfessors.Views.CollegesIndex = Backbone.CompositeView.extend({
	template: JST["colleges/index"],
	
	initialize: function (options) {
		this.listenTo(this.collection, "sync", this.render)
	},
	
	events: {
		"keyup .college_search > input": "search"
	},
	
	render: function () {
		var renderedContent = this.template({
			colleges: this.collection,
			headerText: this.headerText
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
			console.log("aldsjflasdkj");
			$.ajax({
				url: "api/colleges/search",
				dataType: "json",
				method: "GET",
				data: { match: match },
				success: function (resp) {
					that.$("section.colleges_list > h1").text("Colleges matching " + match + ":");
					that.renderSearchResults(resp);
				}
			});
		}
	},
	
	renderSearchResults: function (colleges) {
		var collection = new RateMyPurrfessors.Collections.Colleges(colleges);
		var resultsView = new RateMyPurrfessors.Views.SearchResults({
			collection: collection
		})
		
		this.$("section.colleges_list > article.colleges_list").empty();
		
		this.addSubview("section.colleges_list > article.colleges_list", resultsView);
	}
});