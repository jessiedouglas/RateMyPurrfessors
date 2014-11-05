RateMyPurrfessors.Views.ProfessorRatingsForm = Backbone.View.extend({
	initialize: function (options) {
		this.action = options.action;
		this.method = options.method;
	},
	
	template: JST["professor_ratings/form"],
	
	render: function () {
		var renderedContent = this.template({
			professor: this.model,
			action: this.action,
			method: this.method,
			grades: RateMyPurrfessors.grades
		});
		
		this.$el.html(renderedContent);
		
		return this;
	}
});