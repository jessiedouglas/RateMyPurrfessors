RateMyPurrfessors.Views.ProfessorsNew = Backbone.View.extend({
	template: JST["professors/new"],
	
	render: function () {
		var renderedContent = this.template({
			professor: this.model,
			colleges: RateMyPurrfessors.colleges,
			departments: RateMyPurrfessors.departments
		});
		this.$el.html(renderedContent);
		
		return this;
	},
});