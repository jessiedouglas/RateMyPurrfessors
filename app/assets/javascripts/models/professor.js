RateMyPurrfessors.Models.Professor = Backbone.Model.extend({
	urlRoot: "api/professors",
	
	parse: function (response) {
		if (response.professor_ratings) {
			this.professorRatings().set(response.professor_ratings, { parse: true });
			delete response.professor_ratings;
		}
		
		return response;
	},
	
	professorRatings: function () {
		if (!this._professorRatings) {
			this._professorRatings = new Backbone.Collections.ProfessorRatings( [], {
				professor: this
			});
		}
		
		return this._professorRatings;
	}
});