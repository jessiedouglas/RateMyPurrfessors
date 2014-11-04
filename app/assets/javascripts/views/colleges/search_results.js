RateMyPurrfessors.Views.SearchResults = Backbone.View.extend({
	template: JST["colleges/search_results"],
	tagname: "ul",
	
	render: function () {
		var renderedContent = this.template({ colleges: this.collection });
		this.$el.html(renderedContent);
		
		return this;
	}
});