RateMyPurrfessors.Views.SessionNew = Backbone.View.extend({
	template: JST["sessions/new"],
	errorsTemplate: JST["shared/errors"],
	
	events: {
		"click button.log_in": "logIn"
	},
	
	render: function () {
		var renderedContent = this.template();
		this.$el.html(renderedContent);
		
		return this;
	},
	
	logIn: function (event) {
		event.preventDefault();
		this.$("ul.errors").remove();
		
		var form_attrs = this.$("form.log_in").serializeJSON();
		
		$.ajax({
			url: "api/session",
			method: "POST",
			data: form_attrs,
			success: this.respondToCreate.bind(this)
		});
	},
	
	respondToCreate: function (resp) {
		if (Array.isArray(resp)) {
			var errorsContent = this.errorsTemplate({
				errors: resp
			});
			
			this.$("form.log_in").prepend(errorsContent)
		} else if (resp.id) {
			RateMyPurrfessors.router.navigate("#/users/" + resp.id, true);
		} else {
			var errorsContent = this.errorsTemplate({
				errors: ["Something went wrong. Try again."]
			});
			
			this.$("form.log_in").prepend(errorsContent)
		}
	}
});
