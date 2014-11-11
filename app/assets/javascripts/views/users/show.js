RateMyPurrfessors.Views.UserShow = Backbone.View.extend({
	template: JST["users/show"],
	
	editTemplate: JST["users/edit"],
	
	errorsTemplate: JST["shared/errors"],
	
	passwordTemplate: JST["users/password_edit"],
	
	initialize: function () {
		this.collection = new RateMyPurrfessors.Collections.MixedRatings(this.model.get("all_ratings"));
		this.listenTo(this.model, "sync", this.render);
		this.listenTo(this.collection, "delete remove", this.render);
		this.page = 0;
	},
	
	events: {
		"click a.edit_user": "userEdit",
		"click a.delete_rating": "ratingDestroy",
		"click a.update_user": "userUpdate",
		"click a.cancel_update": "cancelUpdate",
		"click a.password_change": "passwordForm",
		"click a.password_reset": "changePassword",
		"click a.password_cancel": "cancelPassword",
		"click a.next": "nextPage",
		"click a.previous": "previousPage",
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
		this.$("ul.errors").remove();
		
		var form_attrs = this.$("form.user_edit").serializeJSON();
		
		this.model.save(form_attrs.user, {
			patch: true,
			error: this.respondToSave.bind(this)
		});
	},
	
	respondToSave: function (resp, data) {
		var errorsContent = this.errorsTemplate({
			errors: data.responseJSON
		});
		
		this.$("form.user_edit").prepend(errorsContent);
	},
	
	cancelUpdate: function (event) {
		event.preventDefault();
		this.$("section.info").empty();
		this.$("section.info").append("<h1>" + this.model.escape("name"));
		
		if (this.model.get("email")) {
			this.$("section.info").append("<p>" + this.model.escape("email"));
		}
		
		if (this.model.get("college")) {
			this.$("section.info").append('<p><a href="#/colleges/' + this.model.get("college_id") + '"');
			this.$('section.info > p > a').text(RateMyPurrfessors.colleges.get(user.get("college_id")).get("name"))
		}
		
		this.$("section.info").append('<a href="" class="edit_user">Edit my info');
		
	},
	
	passwordForm: function (event) {
		event.preventDefault();
		this.$("a.password_change").addClass("hidden");
		
		var passwordContent = this.passwordTemplate({
			user: this.model
		});
		
		this.$("form.user_edit").append(passwordContent);
	},
	
	changePassword: function (event) {
		event.preventDefault();
		this.$("ul.error").remove();
		
		var passwords = this.$("input.user_password");
		
		if ($(passwords[0]).val() !== $(passwords[1]).val()) {
			var errorsContent = this.errorsTemplate({
				errors: ["Passwords don't match"]
			});
			
			this.$("form.user_edit").prepend(errorsContent);
		} else {
			var form_attrs = this.$("form.password_edit").serializeJSON();
			this.model.save(form_attrs, {
				patch: true,
				error: this.respondToSave.bind(this)
			})
		}
	},
	
	cancelPassword: function (event) {
		event.preventDefault();
		
		this.$("ul.errors").remove();
		this.$("form.password_edit").remove();
		
		this.$("a.password_change").removeClass("hidden");
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
			this.$("div.paginate").prepend('<a class="next" href="">Next &#9654;')
		}
		
		if (this.page !== 0) {
			this.$("div.paginate").prepend('<a class="previous" href="">&#9664; Prev')
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