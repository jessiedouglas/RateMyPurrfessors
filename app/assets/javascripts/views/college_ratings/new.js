RateMyPurrfessors.Views.CollegeRatingsNew = Backbone.CompositeView.extend({
	template: JST["college_ratings/new"],
	
	render: function () {
		var renderedContent = this.template({
			college: this.model
		});
		this.$el.html(renderedContent);
		
		this.renderForm();
		
		return this;
	},
	
	renderForm: function () {
		var formView = new RateMyPurrfessors.Views.CollegeRatingsForm({
			college: this.model,
			action: "api/colleges/" + this.model.get("id") + "/college_ratings",
			method: "POST",
			cancelUrl: "#/colleges/" + this.model.get("id")
		});
		
		$("div.form").html(formView);
		
		this.addSubview("div.form", formView);
	},
});