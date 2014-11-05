RateMyPurrfessors.Views.CollegeRatingsForm = Backbone.View.extend({
	initialize: function (options) {
		this.action = options.action;
		this.method = options.method;
	},
	
	template: JST["college_ratings/form"],
	
	render: function () {
		var renderedContent = this.template({
			college: this.model,
			action: this.action,
			method: this.method,
			gradYears: RateMyPurrfessors.gradYears
		});
		
		this.$el.html(renderedContent);
		
		return this;
	}
});