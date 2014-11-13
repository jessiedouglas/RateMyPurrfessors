RateMyPurrfessors.Views.ProfessorRatingsNew = Backbone.CompositeView.extend({
	initialize: function () {
		this.listenTo(this.model, "sync", this.render);
	},
	
	template: JST["professor_ratings/new"],
	
	render: function () {
		if (this.model.get("college_id")) {
			var college = RateMyPurrfessors.colleges.get(this.model.get("college_id"));
			var renderedContent = this.template({
				professor: this.model,
				college: college
			});
			this.$el.html(renderedContent);
		
			this.renderForm();
		}
		
		return this;
	},
	
	renderForm: function () {
		var formView = new RateMyPurrfessors.Views.ProfessorRatingsForm({
			professor: this.model,
			action: "api/professors/" + this.model.get("id") + "/professor_ratings",
			method: "POST",
			cancelUrl: "#/professors/" + this.model.get("id")
		});
		
		$("div.form").html(formView);
		
		this.addSubview("div.form", formView);
	}
});