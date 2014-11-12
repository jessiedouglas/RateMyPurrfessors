RateMyPurrfessors.Views.UsersNew = Backbone.View.extend({
	template: JST["users/new"],
	errorsTemplate: JST["shared/errors"],
	
	events: {
		"click button.create_user": "createUser"
	},
	
	render: function () {
		var renderedContent = this.template({
			colleges: RateMyPurrfessors.colleges
		});
		
		this.$el.html(renderedContent);
		
		return this;
	},
	
	createUser: function (event) {
		event.preventDefault();
		this.$("ul.errors").remove();
		
		var passwords = this.$("input.user_password");
		passwords[0] = $(passwords[0]).val();
		passwords[1] = $(passwords[1]).val();
		
		if (passwords[0] !== passwords[1]) {
			var renderedErrors = this.errorsTemplate({
				errors: ["Passwords do not match"]
			});
			
			this.$("form").prepend(renderedErrors);
		} else {
			var form_attrs = this.$("form").serializeJSON();

			$.ajax({
				url: "api/users",
				method: "POST",
				data: form_attrs,
				success: this.respondToCreate.bind(this)
			});
		}
	},
	
	respondToCreate: function (resp) {
		if (resp.id) {
			RateMyPurrfessors.currentUser.set(resp);
			Backbone.history.navigate("#/users/" + resp.id);
		} else if (Array.isArray(resp)) {
			var errorsContent = this.errorsTemplate({
				errors: resp
			});
			
			this.$("form").prepend(errorsContent);
		} else if (resp.get(0)){
			var iterating = true;
			var i = 0;
			var errors = []
			
			while (iterating) {
				if (resp.get(i)) {
					if (resp.get(i) === "Password digest can't be blank") {
						var error = "Password is too short (minimum 6 characters)";
					} else {
						var error = resp.get(i);
					}
					errors.push(error);
					i++
				} else {
					iterating = false;
				}
			}
			
			var errorsContent = this.errorsTemplate({
				errors: errors
			});
			
			this.$("form").prepend(errorsContent);
		} else {
			var errors = ["Something went wrong. Try again"];
			
			var errorsContent = this.errorsTemplate({
				errors: errors
			});
			
			this.$("form").prepend(errorsContent);
		}
	}
});