RateMyPurrfessors.Views.SessionNew = Backbone.View.extend({
	template: JST["sessions/new"],
	
	render: function () {
		var renderedContent = this.template();
		this.$el.html(renderedContent);
		
		return this;
	}
});
