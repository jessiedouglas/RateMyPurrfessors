RateMyPurrfessors.Views.Header = Backbone.View.extend({
	template: JST["header/header"],
	
	initialize: function () {
		this.listenTo(RateMyPurrfessors.currentUser, "change", this.render);
	},
	
	render: function () {
		var renderedContent = this.template({
			user: RateMyPurrfessors.currentUser
		});
		
		this.$el.html(renderedContent);
		
		return this;
	}
});