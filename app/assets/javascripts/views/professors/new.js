RateMyPurrfessors.Views.ProfessorsNew = Backbone.View.extend({
	template: JST["professors/new"],
	errorsTemplate: JST["shared/errors"],
	
	events: {
		"click a#photo": "filepicker",
		"click button.add_professor": "checkValidity",
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
			this.$("div.filepicker").append("<p>" + blob.filename + "</p>");
			that.photo_url = blob.url;
		});
	},
	
	checkValidity: function (event) {
		event.preventDefault();
		this.$("ul.errors").remove();
		
		this.form_attrs = this.$("form").serializeJSON();
		
		if (this.photo_url) {
			this.form_attrs.professor.filepicker_url = this.photo_url;
		}
		
		$.ajax({
			url: "/api/professors/is_valid",
			data: this.form_attrs,
			method: "GET",
			success: this.respondToCheck.bind(this)
		});
	},

	confirmCreate: function () {
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
		
		var professor = new RateMyPurrfessors.professors.model();
		var that = this;
		
		professor.set(this.form_attrs);
		
		professor.save({}, {
			success: function (resp) {
					RateMyPurrfessors.router.navigate("#/professors/" + resp.id, true);
			}
		});
	},
	
	respondToCheck: function (resp) {
		if (Array.isArray(resp)) {
			var errorContent = this.errorsTemplate({
								errors: resp
							});
							
			this.$el.prepend(errorContent);
		} else {
			this.confirmCreate();
		}
	}
});