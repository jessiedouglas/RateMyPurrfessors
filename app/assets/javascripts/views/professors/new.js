RateMyPurrfessors.Views.ProfessorsNew = Backbone.View.extend({
	template: JST["professors/new"],
	
	events: {
		"click a#photo": "filepicker",
		"click form > button": "createProfessor"
	},
	
	render: function () {
		var renderedContent = this.template({
			professor: this.model,
			colleges: RateMyPurrfessors.colleges,
			departments: RateMyPurrfessors.departments
		});
		this.$el.html(renderedContent);
		
		// filepicker.constructWidget(this.$("input#constructed-widget"));
		
		return this;
	},
	
	filepicker: function (event) {
		console.log("hi");
		event.preventDefault();
		var that = this;
		
		filepicker.pick(function (blob) {
			this.$("div.filepicker").append("<p>" + blob.url + "</p>");
			that.photo_url = blob.url;
		});
	}, 
	
	createProfessor: function (event) {
		event.preventDefault();
		var form_attrs = this.$("form").serializeJSON();
		if (this.photo_url) {
			form_attrs.filepicker_url = this.photo_url;
		}
		
		console.log(form_attrs);
		
		var professor = new RateMyPurrfessors.Models.Professor();
		
		professor.set(form_attrs);
		professor.save();
	}
});