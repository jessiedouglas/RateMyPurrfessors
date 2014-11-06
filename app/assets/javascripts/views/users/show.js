RateMyPurrfessors.Views.UserShow = Backbone.View.extend({
	template: JST["users/show"],
	
	editTemplate: JST["users/edit"],
	
	initialize: function () {
		this.collection = new RateMyPurrfessors.Collections.MixedRatings(this.model.get("all_ratings"));
		this.listenTo(this.model, "sync change update", this.render);
		this.listenTo(this.collection, "delete remove", this.render);
		this.page = 0;
	},
	
	events: {
		"click a.edit_user": "userEdit",
		"click a.delete_rating": "ratingDestroy",
		"click a.update_user": "userUpdate",
		"click a.next": "nextPage",
		"click a.previous": "previousPage"
	},
	
	render: function () {
		if (!this.allPages) {
			this.ratingsPages(this.collection.models);
		}
		
		var renderedContent = this.template({
			user: this.model,
			all_ratings: this.allPages[this.page]
		});
		
		this.$el.html(renderedContent);
		
		this.paginate();
		
		return this;
	},
	
	userEdit: function (event) {
		event.preventDefault();
		
		var renderedContent = this.editTemplate({
			user: this.model,
			colleges: RateMyPurrfessors.colleges
		});
		this.$("section.info").html(renderedContent);
	},
	
	userUpdate: function (event) {
		event.preventDefault();
		
		var password_inputs = this.$("input#user_password");
		
		if ($(password_inputs[0]).val() !== $(password_inputs[1]).val()) {
			this.$("ul.errors").empty();
			this.$("ul.errors").append('<p class="errors">Passwords do not match</p>');
		} else {
			var attrs = {
				name: this.$("input#user_name").val(),
				password: $(password_inputs[0]).val()
			}
			
			if (!this.hasUpdateErrors(attrs)) {
				if (this.$("input#user_email").val()) {
					attrs.email = this.$("input#user_email").val()
				}
				
				if (this.$("select#user_college_id").val()) {
					attrs.college_id = this.$("select#user_college_id").val();
				}
				
				this.model.save(attrs);
			} else {
				var errors = this.hasUpdateErrors(attrs);
				this.$("ul.errors").empty();
				
				errors.forEach(function (error) {
					this.$("ul.errors").append('<li>' + error + '</li>');
				});
			}
		}
	},
	
	hasUpdateErrors: function (attrs) {
		var errors = [];
		
		for (var attr in attrs) {
			if (!attrs[attr]) {
				errors.push(attr + " is missing");
			}
		}
		
		if (errors.length === 0) {
			return false;
		}
		
		return errors;
	},
	
	ratingDestroy: function (event) {
		event.preventDefault();
		var $currentTarget = $(event.currentTarget);
		
		var id = $currentTarget.data("id");
		var type = $currentTarget.data("type");
		var rating;
		var that = this;
		
		if (type === "college_rating") {
			var collegeRatings = new RateMyPurrfessors.Collections.CollegeRatings();
			collegeRatings.fetch({
				success: function () {
					rating = collegeRatings.get(id);
					that.collection.remove(rating);
					rating.destroy();
				}
			});
		} else if (type === "professor_rating") {
			var professorRatings = new RateMyPurrfessors.Collections.ProfessorRatings();
			professorRatings.fetch({
				success: function () {
					rating = professorRatings.get(id);
					that.collection.remove(rating);
					rating.destroy();
				}
			});
		}	
	},
	
	ratingsPages: function (ratings) {
		this.allPages = [];
		var arrayPages = [];
		
		while (ratings.length > 20) {
			arrayPages.push(ratings.slice(0, 20));
			ratings = ratings.slice(20);
		}
		
		arrayPages.push(ratings);
		var that = this
		
		arrayPages.forEach(function (page) {
			var newCollection = new RateMyPurrfessors.Collections.MixedRatings();
			newCollection.set(page);
			that.allPages.push(newCollection);
		});
	},
	
	paginate: function () {
		if (this.page !== this.allPages.length - 1) {
			this.$("div.paginate").prepend('<a class="next" href="">Next')
		}
		
		if (this.page !== 0) {
			this.$("div.paginate").prepend('<a class="previous" href="">Prev')
		}
	},
	
	nextPage: function (event) {
		event.preventDefault();
		
		this.page += 1;
		this.render();
	},
	
	previousPage: function (event) {
		event.preventDefault();
		
		this.page -= 1;
		this.render();
	}
});