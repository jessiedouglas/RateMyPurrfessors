RateMyPurrfessors.Views.CollegeRatingShow = Backbone.CompositeView.extend({
	template: JST["college_ratings/show"],
	tagname: "li",
	
	render: function () {
		var renderedContent = this.template({
			rating: this.model
		});
		this.$el.html(renderedContent);
		
		var upDownVotes = this.model.upDownVotes();
		var upvotes = this.model.vote_stats.upvotes
		var downvotes = this.model.vote_stats.downvotes
		
		var voteView = new RateMyPurrfessors.Views.UpDownVotes({
			collection: upDownVotes,
			upvotes: upvotes,
			downvotes: downvotes
		});
		this.$(".up_down_votes").empty();
		this.addSubview(".up_down_votes", voteView);
		
		return this;
	}
});