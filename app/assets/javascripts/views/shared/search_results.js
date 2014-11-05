RateMyPurrfessors.Views.SearchResults = Backbone.View.extend({
	initialize: function (options) {
		this.type = options.type;
	},
	
	template: function () {
		if (this.type === "colleges") {
			return JST["colleges/search_results"];
		} else if (this.type === "professors"){
			return JST["professors/search_results"];
		} else if (this.type === "mixed") {
			return JST["root/search_results"]
		} else {
			alert("OH NO");
		}
	},
	
	tagname: "ul",
	
	render: function () {
		var renderedContent = this.template()({ items: this.collection });
		this.$el.html(renderedContent);
		
		return this;
	}
});