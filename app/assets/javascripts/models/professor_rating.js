RateMyPurrfessors.Models.ProfessorRating = Backbone.Model.extend({
	urlRoot: "api/professor_ratings",
	
	parse: function (response) {
		if (response.up_down_votes) {
			this.upDownVotes().set(response.up_down_votes);
			delete response.up_down_votes;
		}
		
		return response;
	},
	
	upDownVotes: function () {
		if (!this._upDownVotes) {
			this._upDownVotes = new RateMyPurrfessors.Collections.UpDownVotes( [], {
				rating: this
			});
		}
		
		return this._upDownVotes;
	},
	
	comparator: function (rating) {
		return -Date.parse(rating.get("updated_at"));
	}
});