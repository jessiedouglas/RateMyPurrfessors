RateMyPurrfessors.Views.ProfessorsNew = Backbone.View.extend({
	template: JST["professors/new"],
	errorsTemplate: JST["shared/errors"],
	
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
		
		professor.save({}, {
			success: this.respondToSave.bind(this)
		});
	},
	
	respondToSave: function (resp) {
		if (resp.id) {
			RateMyPurrfessors.router.navigate("#/professors/" + resp.id, true);
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
			this.$("div.modal_background").remove();
			this.$("div.confirm_modal").remove();
		} else {
			alert("Something has gone terribly wrong :(")
		}
	}
});