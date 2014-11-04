RateMyPurrfessors.Views.UpDownVotes = Backbone.View.extend({
	initialize: function (options) {
		this.upvotes = options.upvotes;
		this.downvotes = options.downvotes;
		this.has_already_voted_on = options.has_already_voted_on;
		this.rating_id = options.rating_id;
		this.rating_type = options.rating_type;
	},
	
	template: JST["up_down_votes/up_down_votes"],
	
	events: {
		"click a.upvote": "upvote",
		"click a.downvote": "downvote",
		"click a.undo": "deleteVote"
	},
	
	render: function () {
		var renderedContent = this.template({
			upvotes: this.upvotes,
			downvotes: this.downvotes,
			has_already_voted_on: this.has_already_voted_on
		});
		this.$el.html(renderedContent);
		
		return this;
	},
	
	upvote: function (event) {
		event.preventDefault();
		
		var attrs = {
			votable_id: this.rating_id,
			votable_type: this.rating_type,
			vote_value: 1
		};
		
		this.saveVote(attrs);
	},
	
	downvote: function (event) {
		event.preventDefault();
		
		var attrs = {
			votable_id: this.rating_id,
			votable_type: this.rating_type,
			vote_value: -1
		};
		
		this.saveVote(attrs);
	},
	
	saveVote: function (attrs) {
		var vote = new RateMyPurrfessors.Models.UpDownVote();
		vote.set(attrs);
		var that = this
		
		vote.save( [], {
			success: function () {
				if (attrs.vote_value === 1) {
					that.upvotes += 1;
				} else {
					that.downvotes += 1;
				}
				that.has_already_voted_on = attrs.vote_value;
				that.vote_id = vote.get("id");
				that.render();
			},
			errors: function (resp) {
				console.log(resp.errors);
			}
		});
	},
	
	deleteVote: function (event) {
		event.preventDefault();
		
		attrs = {
			votable_id: this.rating_id,
			votable_type: this.rating_type
		}
		var that = this;
		
		if (!this.vote_id) {
			$.ajax({
				url: "api/up_down_votes/find_vote",
				type: "GET",
				data: { up_down_vote: attrs },
				success: function (resp) {
					that.vote_id = resp.id;
					that.ajaxDelete();
				}
			});
		} else {
			that.ajaxDelete();
		}
	},
	
	ajaxDelete: function () {
		var that = this;
		
		$.ajax({
			url: "api/up_down_votes/" + that.vote_id,
			type: "DELETE",
			data: { up_down_vote: attrs },
			success: function () {
				if (that.has_already_voted_on === 1) {
					that.upvotes -= 1;
				} else {
					that.downvotes -= 1;
				}

				that.has_already_voted_on = false;
				that.render();
			}
		});
	}
});