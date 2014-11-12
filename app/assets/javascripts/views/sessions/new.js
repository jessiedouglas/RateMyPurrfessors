RateMyPurrfessors.Views.SessionNew = Backbone.View.extend({
	template: JST["sessions/new"],
	errorsTemplate: JST["shared/errors"],
	
	events: {
		"click button.log_in": "logIn",
		"click button.demo": "loginDemo"
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
		var that = this;
		
		$.ajax({
			url: "api/session",
			method: "POST",
			data: form_attrs,
			success: function (resp) {
				RateMyPurrfessors.currentUser.set(resp);
				Backbone.history.navigate("#/users/" + resp.id, {trigger: true});
			},
			error: function () {
				var errorsContent = that.errorsTemplate({
					errors: ["Incorrect email/password combination"]
				});
				
				that.$("form.log_in").prepend(errorsContent);
			}
		});
	},
	
	loginDemo: function (event) {
		event.preventDefault();
		
		var form_attrs = { user: {
							email: "demo@demo.com",
							password: "demodemo"
						}}
		
		$.ajax({
			url: "api/session",
			method: "POST",
			data: form_attrs,
			success: function (resp) {
				RateMyPurrfessors.currentUser.set(resp);
				Backbone.history.navigate("#/users/" + resp.id, {trigger: true})
			}
		});
	}
});
