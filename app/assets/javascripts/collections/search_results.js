RateMyPurrfessors.Collections.SearchResults = Backbone.Collection.extend({
	url: "api/search",
	
	model: function (attrs) {
		var type = attrs.type;
		
		if (type === "college") {
			return new RateMyPurrfessors.Models.College(attrs);
		} else if (type === "professor") {
			return new RateMyPurrfessors.Models.Professor(attrs);
		} else {
			return new Backbone.Model(attrs);
		}
	}
});