RateMyPurrfessors.Models.CollegeRating = Backbone.Model.extend({
	urlRoot: "api/college_ratings",
	
	// parse: function (response) {
// 		if (response.up_down_votes) {
// 			this.upDownVotes().set(response.up_down_votes);
// 			delete response.up_down_votes
// 		}
//
// 		return response;
// 	},
//
// 	upDownVotes: function () {
// 		if (!this._upDownVotes) {
// 			var rating = this;
// 			console.log(this);
// 			this._upDownVotes = new RateMyPurrfessors.Collections.UpDownVotes( [], {
// 				rating: rating
// 			});
// 		}
//
// 		return this._upDownVotes;
// 	}
});