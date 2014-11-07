RateMyPurrfessors.Views.ProfessorsNew = Backbone.View.extend({
	template: JST["professors/new"],
	
	events: {
		"click a#photo": "filepicker",
		"click button.add_professor": "confirmCreate",
		"click button.confirm": "createProfessor",
		"click button.cancel": "cancelCreate"
	},
	
	render: function () {
		var renderedContent = this.template({
			colleges: RateMyPurrfessors.colleges,
			departments: RateMyPurrfessors.departments
		});
		this.$el.html(renderedContent);
				
		return this;
	},
	
	filepicker: function (event) {
		event.preventDefault();
		var that = this;
		
		filepicker.pick(function (blob) {
			debugger
			this.$("div.filepicker").append("<p>" + blob.filename + "</p>");
			that.photo_url = blob.url;
		});
	}, 

	confirmCreate: function (event) {
		event.preventDefault();
		
		this.$el.prepend('<div class="modal_background">');
		this.$el.prepend('<div class="confirm_modal">');
		this.$("div.confirm_modal").append('<p> Are you sure you want to create this professor?</p> <p>Once created, it cannot be edited.');
		this.$("div.confirm_modal").append('<button class="cancel">Cancel');
		this.$("div.confirm_modal").append('<button class="cancel modal_close">&times;');
		this.$("div.confirm_modal").append('<button class="confirm">Yes, ' + "I'm sure!");
	},
	
	cancelCreate: function (event) {
		event.preventDefault();
		this.$("div.modal_background").remove();
		this.$("div.confirm_modal").remove();
	},

	createProfessor: function (event) {
		event.preventDefault();
		this.$("ul.errors").remove();
		
		var form_attrs = this.$("form").serializeJSON();
		if (this.photo_url) {
			form_attrs.filepicker_url = this.photo_url;
		}
		
		var professor = new RateMyPurrfessors.professors.model();
		var that = this;
		
		professor.set(form_attrs);
		if (professor.save()) {
			professor.fetch({
				success: function (resp) {
					that.$el.empty();
					that.$el.append("<p>Professor added!");
				}
			});
		} else {
			alert("OH NO")
		}
			// success: function () {
// 				console.log("we did it")
// 				RateMyPurrfessors.Routers.Router.navigate("/show/" + professor.get("id"));
// 			},
			// error: function (resp) {
// 				debugger
// 				that.$el.prepend('<ul class="errors">');
//
// 				if (!resp.attributes.first_name) {
// 					that.$("ul.errors").append("<li>First Name can't be blank.");
// 				}
//
// 				if (!resp.attributes.last_name) {
// 					that.$("ul.errors").append("<li>Last Name can't be blank.");
// 				}
//
// 				if (!resp.attributes.department) {
// 					that.$("ul.errors").append("<li>Please select a department.");
// 				}
//
// 				if (!resp.attributes.college_id) {
// 					that.$("ul.errors").append("<li>Please select a college.");
// 				}
		// );
	}
});