RateMyPurrfessors.Views.CollegeRatingsForm = Backbone.View.extend({
	initialize: function (options) {
		this.action = options.action;
		this.method = options.method;
		this.college = options.college;
	},
	
	template: JST["college_ratings/form"],	
	errorsTemplate: JST["shared/errors"],
	
	events: {
		"click button": "saveRating"
	},
	
	render: function () {
		var renderedContent = this.template({
			college: this.college,
			action: this.action,
			method: this.method,
			gradYears: RateMyPurrfessors.gradYears
		});
		
		this.$el.html(renderedContent);
		
		return this;
	},
	
	saveRating: function (event) {
		event.preventDefault();
		
		this.$("ul.errors").remove();
		
		var form = this.$("form").serializeJSON();
		if (this.model) {
			var rating = this.model;
			rating.set(form.college_rating);
			rating.save({}, {
				success: this.respondToSave.bind(this)
			});
		} else {
			var rating = new RateMyPurrfessors.Models.CollegeRating();
			$.ajax({
				url: "api/colleges/" + this.college.get("id") + "/college_ratings",
				data: form,
				method: "POST",
				success: this.respondToSave.bind(this)
			})
		}
	},
	
	respondToSave: function (resp) {
		if (resp.id) {
			if (resp.college_id) {
				RateMyPurrfessors.router.navigate("#/colleges/" + resp.college_id, true);
			} else {
				RateMyPurrfessors.router.navigate("#/colleges/" + resp.get("college_id"), true);
			}
		} else if (Array.isArray(resp)) {
			var errorContent = this.errorsTemplate({
				errors: resp
			});
			
			this.$el.prepend(errorContent);
		} else if (resp.get(0)) {
			var iterating = true;
			var i = 0;
			var errors = [];
			
			while (iterating) {
				if (resp.get(i)) {
					errors.push(resp.get(i));
					i++;
				} else {
					iterating = false
				}
			}
			
			var errorContent = this.errorsTemplate({
				errors: errors
			});
			
			this.$el.prepend(errorContent);
		} else {
			alert("Something has gone terribly wrong :(")
		}
	}
});