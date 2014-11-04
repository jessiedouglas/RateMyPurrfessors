RateMyPurrfessors.Collections.UpDownVotes = Backbone.Collection.extend({
	url: "api/up_down_votes",
	model: RateMyPurrfessors.Models.UpDownVote,
		//
	// initialize: function (options) {
	// 	this.rating = options.rating;
	// }
})