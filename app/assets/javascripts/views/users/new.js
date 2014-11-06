RateMyPurrfessors.Views.UsersNew = Backbone.View.extend({
	template: JST["users/new"],
	
	events: {
		// "click a.create_user": "createUser"
	},
	
	render: function () {
		var renderedContent = this.template({
			colleges: RateMyPurrfessors.colleges
		});
		
		this.$el.html(renderedContent);
		
		return this;
	},
		//
	// createUser: function (event) {
	// 	event.preventDefault();
	//
	// 	var password_inputs = this.$("input#user_password");
	//
	// 	if ($(password_inputs[0]).val() !== $(password_inputs[1]).val()) {
	// 		this.$("ul.errors").empty();
	// 		this.$("ul.errors").append('<li class="errors">Passwords do not match</li>');
	// 	} else {
	// 		var attrs = this.$("form.new_user").serializeJSON();
	// 		console.log(attrs);
	// 		var that = this;
	//
	// 		this.model.save(attrs, {
	// 			success: function () {
	// 				console.log(that.model);
	// 				// Backbone.history.navigate("#/users/" + that.model.id);
	// 			},
	// 			errors: this.renderErrors
	// 		})
	// 	}
	// },
	//
	// renderErrors: function (errors) {
	// 	console.log(errors);
	// }
});