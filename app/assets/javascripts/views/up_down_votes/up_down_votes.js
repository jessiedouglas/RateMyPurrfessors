RateMyPurrfessors.Views.UpDownVotes = Backbone.View.extend({
	initialize: function (options) {
		this.upvotes = options.upvotes,
		this.downvotes = options.downvotes
	},
	
	template: JST["up_down_votes/up_down_votes"],
	
	render: function () {
		var renderedContent = this.template()({
			upDownVotes: this.collection,
			upvotes: this.upvotes,
			downvotes: this.downvotes
		});
		this.$el.html(renderedContent);
		
		return this;
	}
});