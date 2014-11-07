RateMyPurrfessors.Views.ProfessorRatingShow = Backbone.CompositeView.extend({
	template: JST["professor_ratings/show"],
	tagName: "li",
	className: "rating",
	
	render: function () {
		var renderedContent = this.template({
			rating: this.model
		});
		
		this.$el.html(renderedContent);
		
		var upvotes = this.model.get("vote_stats").upvotes;
		var downvotes = this.model.get("vote_stats").downvotes;
		var has_already_voted_on = this.model.get("vote_stats").has_already_voted_on;
		
		var voteView = new RateMyPurrfessors.Views.UpDownVotes({
			upvotes: upvotes,
			downvotes: downvotes,
			has_already_voted_on: has_already_voted_on,
			rating_id: this.model.get("id"),
			rating_type: "professor_rating"
		});
		this.$(".up_down_votes").empty();
		this.addSubview(".up_down_votes", voteView);
		
		return this;
	}
});